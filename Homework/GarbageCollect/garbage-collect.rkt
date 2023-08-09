#lang racket

(require rackunit)

(provide info-struct info-struct-name make-memstruct define-memstruct memstruct-info memstruct-num reset-memory ptr ptr->info get-val get-ptr ptr=? set-field! put! null-ptr null-ptr? simple-dump all-reachable garbage-collect validate-memory)

(struct info-struct
  ([name]
   [num]
   [pointer-fields]
   [value-fields]))

;; The functions you need to edit for this assignment are at the bottom

;; You may notice that the functions in this code have
;; comments with type information.  This is because
;; I wrote the original implementation in Typed Racket.
;;
;; Typed Racket is cool but adds some additional constraints
;; that can be annoying initially.  For that reason, I've converted
;; this to regular racket - but I left the types as comments because
;; I think they improve readability.
;;
;; Here's how to read them:
;; (: get-val (-> Symbol Symbol ptr Integer))
;;
;; The variable in get-val is a function that takes 2 symbols and a pointer.
;; It returns an Integer (the last entry in a functions annotation is always
;; its return type).  If you see a (U Type1 Type2) in means union (i.e.
;; both types are allowed in whatever context).

;; Part of the internal definition of memstructs
;; Not really important to understand
;;
;;(: memstructs (HashTable Symbol info-struct))
(define memstructs (make-hash))

;; Part of the internal definition of memstructs
;; Not really important to understand
;;
;;(: make-memstruct (-> Symbol (Listof Symbol) (Listof Symbol) Void))
(define make-memstruct
  (lambda (name pointers values)
    (when (hash-has-key? memstructs name) (error "already a struct with name" name))
    (hash-set! memstructs name (info-struct name (hash-count memstructs) pointers values))))

;; See the lab for a description of how define-memstruct works
;;
(define-syntax define-memstruct
  (syntax-rules (ptrs: vals:)
    [(define-memstruct name ptrs: (pnames ...) vals: (vnames ...))
     (make-memstruct (quote name) (quote (pnames ...)) (quote (vnames ...)))]
    ; that one above is the one that counts.  These below just
    ; make either field optional
    [(define-memstruct name ptrs: (pnames ...))
     (define-memstruct name ptrs: (pnames ...) vals: ())]
    [(define-memstruct name vals: (vnames ...))
     (define-memstruct name ptrs: () vals: (vnames ...))]))

;; Given a memstruct symbol name returns the associated metadata object
;;
;; Probably not needed to use, there are fuctions the access most of what
;; you need.
;;
;;(: memstruct-info (-> Symbol info-struct))
(define memstruct-info
  (lambda (memstruct-name)
    (or (hash-ref memstructs memstruct-name)
        (error "unknown memstruct" memstruct-name))))

;; Given a memstruct symbol name returns the associated type code
;;
;; Probably not needed to use, there are fuctions the access most of what
;; you need.
;;
;;(: memstruct-num (-> Symbol Integer))
(define memstruct-num
  (lambda (memstruct-name)
    (info-struct-num (memstruct-info memstruct-name))))

;; Given a pointer, returns the associated metadata object by using its
;; typecode field. 
;;
;; Probably not needed to use, there are fuctions the access most of what
;; you need.
;;
;;(: ptr->info (-> ptr info-struct))
(define ptr->info
  (lambda (ptr)
    (let* ((structs (hash-values memstructs))
           (typenum (vector-ref memory (ptr-index ptr)))
           (type-matches (lambda (i) (= (info-struct-num i) typenum))))
      (or (findf type-matches structs)
          (error "cant find memstruct with typenum" typenum)))))
      

;; The vector where all memstructs are stored
;;
;;(: memory (Vectorof Integer))
(define memory (make-vector 2000 -1))

;; Keeps track of the next unused index in memory
;;
;;(: next-index Integer)
(define next-index 0)   

;; Resets memory to an empty vector of the given size
;;
;; Frequently used in tests
;;
;; (: reset-memory (-> Integer Void))
(define reset-memory
  (lambda (new-size)
    (set! memory (make-vector new-size -1))
    (set! next-index 0)))

;; a pointer is still basically an integer but we give it its own struct
;; to ensure we only use it in the correct contexts
(struct ptr
  ([index]) #:transparent)

;; the special null pointer
;(: null-ptr ptr)
(define null-ptr (ptr -1))

;; is this pointer null?
;;
;;(: null-ptr? (-> ptr Boolean))
(define null-ptr?
  (lambda (ptr)
    (= (ptr-index ptr) -1)))

;; is this a pointer to the same location as another pointer
;;
;(: ptr=? (-> ptr ptr Boolean))
(define ptr=?
  (lambda (p1 p2)
    (= (ptr-index p1) (ptr-index p2))))

;; internal only function - should not be used
;; use get-val get-ptr
;;
;; (: get-index (-> Symbol Symbol Boolean ptr Integer))
(define get-index
  (lambda (memstruct-name field-name is-ptr-field ptr)
    (let* ((memstruct (memstruct-info memstruct-name))
           (fields ((if is-ptr-field info-struct-pointer-fields info-struct-value-fields) memstruct))
           (index (- (length fields) (length (or (member field-name fields)
                                                 (error "unknown field" memstruct-name field-name)))))
           (val-offset (if is-ptr-field 0 (length (info-struct-pointer-fields memstruct)))))
      (+ 1
         val-offset
         (ptr-index ptr)
         index))))

;; get a particular value from a memstruct
;; see lab for details
;;
;;(: get-val (-> Symbol Symbol ptr Integer))
(define get-val
  (lambda (memstruct-name field pointer)    
      (vector-ref memory (get-index memstruct-name field #f pointer))))

;; get a particular pointer from a memstruct
;; see lab for details
;;
;;(: get-ptr (-> Symbol Symbol ptr ptr))
(define get-ptr
  (lambda (memstruct-name field pointer)
    (ptr (vector-ref memory (get-index memstruct-name field #t pointer)))))

;; set a particular value from a memstruct
;; maybe not required but feel free to use it
;;
;; note that it decides if what you're trying to see is a pointer
;; or a value depending on the type of the ptr parameter (ptr or not)
;(: set-field! (-> Symbol Symbol ptr (U ptr Integer) Void))
(define set-field!
  (lambda (memstruct-name field-name ptr value-to-set)
    (vector-set!
     memory
     (get-index memstruct-name field-name (ptr? value-to-set) ptr)
     (if (ptr? value-to-set) (ptr-index value-to-set) value-to-set))))

;; takes a list of values and writes it to the memory array
;; at the given location.
;;
;; this is definitely a internal type function but feel free to use it
;;
;;(: write-array! (-> (Listof Integer) Integer ptr))
(define write-array!
  (lambda (data pos)
    (if (null? data)
            (let ((start next-index))
              (set! next-index pos)
              (ptr start))
            (begin
              (vector-set! memory pos (car data))
              (write-array! (cdr data) (add1 pos))))))

;; Inserts a new memstruct of the given type in the memory array
;;
;; automatically inserts at current next index and adjusts it
;; 
;; see lab for details
;;
;;(: put! (-> Symbol (U ptr Integer) * ptr))
(define put!
  (lambda (memstruct-name . values)
    (let*-values (((info) (memstruct-info memstruct-name))
                  ((ptr-size) (length (info-struct-pointer-fields info)))
                  ((val-size) (length (info-struct-value-fields info)))
                  ((ptrs vals) (split-at values ptr-size)))
      (unless (= (length values) (+ ptr-size val-size))
        (error "bad field list size for " memstruct-name values))
      (unless (andmap ptr? ptrs) (error "non-ptr for ptr field" memstruct-name values))
      (unless (andmap exact-integer? vals) (error "non-int for value" memstruct-name values))
      (write-array! (append (list (info-struct-num info))
                            (map ptr-index ptrs)
                            vals)
                        next-index))))
       

;; Gets the length of the structure stored in the given pointer
;;
;; Will always be 1 + number of fields in the type, but why
;; bother computing it yourself?
;;
;;(: ptr-length (-> ptr Integer))
(define ptr-length
  (lambda (ptr)
    (let ((info (ptr->info ptr)))
      (+ 1
         (length (info-struct-pointer-fields info))
         (length (info-struct-value-fields info))))))



;; Gets all the pointers stored in the structure referenced by the given pointer
;; as a list
;;
;;(: ptr-pointers (-> ptr (Listof ptr)))
(define ptr-pointers
  (lambda (get-ptr)
    (let ((num-ptrs (length (info-struct-pointer-fields (ptr->info get-ptr)))))            
      (let recurse ((index (add1 (ptr-index get-ptr)))
                    (num num-ptrs))
        (if (zero? num)
            '()
            (cons (ptr (vector-ref memory index)) (recurse (add1 index) (sub1 num))))))))

;; Gets all the values stored in the structure referenced by the given pointer
;; as a list
;;
;;(: ptr-values (-> ptr (Listof Integer)))
(define ptr-values
  (lambda (get-ptr)
    (let* ((info (ptr->info get-ptr))
           (num-ptrs (length (info-struct-pointer-fields info)))
           (num-vals (length (info-struct-value-fields info))))            
      (let recurse ((index (+ 1 num-ptrs (ptr-index get-ptr)))
                    (num num-vals))
        (if (zero? num)
            '()
            (cons (vector-ref memory index) (recurse (add1 index) (sub1 num))))))))

;(define-type dump (U Integer Symbol (Listof dump)))

;; Converts a structure to a simple list form, including substructures
;; WILL infinite loop if given a circular reference structure
;;
;; Handy for debugging, don't use it as part of functions
;;
;(: simple-dump (-> ptr dump))
(define simple-dump
  (lambda (ptr)
    (if (null-ptr? ptr)
        'NULL-PTR
        (let ((info (ptr->info ptr)))
          (append
           (list (info-struct-name info))
           (map simple-dump (ptr-pointers ptr))
           (ptr-values ptr))))))
     

;; Gets a list of all memstructs in memory
;;
;; You should not need to use this function, it is part of validate-memory
;;
;(: all-ptrs (-> (Listof ptr)))
(define all-ptrs
  (lambda ()
    (let recur ((current-pos 0)
                (ptrs '()))
      (cond
        [(> current-pos next-index)
         (error "object beyond end of memory~n")
         #f]
        [(= current-pos next-index)
         ptrs]
        [else
         (let ((this (ptr current-pos)))
           (recur (+ (ptr-length this) current-pos)
             (cons this ptrs)))
         ]))))

;; Checks memory integrity and returns the number of objects
;;
;; You should not need to modify or use this function directly. Look at the lab for more details
;;
;(: validate-memory (-> Integer))
(define validate-memory
  (lambda ()
    (let ((ptrs  (all-ptrs)))
      (for-each (lambda (one-ptr) 
                  (for-each (lambda (inner-ptr)
                              (unless (or (null-ptr? inner-ptr)
                                          (member inner-ptr ptrs ptr=?))
                                (error "invalid inner ptr")))
                   (ptr-pointers one-ptr)))
                  
                ptrs)
      (length ptrs))))



;(: all-reachable (-> (Listof ptr) (Listof ptr)))
(define all-reachable
  (lambda (base-ptrs)
    (nyi)))

                       
         
;; MAKE NYI
;(: garbage-collect (-> (Listof ptr) (Listof ptr)))
(define garbage-collect
  (lambda (basis-set)
    (nyi)))
      
                                
      
   
      

; A few little tests to ensure you don't break the way memstructs work

(define-memstruct test1 vals: (a b))
(define-memstruct test2 ptrs: (mytest) vals: (myval))

(define test1val (put! 'test1 1 2))
(define test2val (put! 'test2 test1val 3))
                  
(check-equal? (get-val 'test1 'a test1val) 1)
(check-equal? (get-val 'test1 'b test1val) 2)
(check-equal? (get-val 'test1 'b (get-ptr 'test2 'mytest test2val)) 2)
(check-equal? (get-val 'test2 'myval test2val) 3)
(check-equal? (info-struct-name (ptr->info test1val)) 'test1)
(check-equal? (info-struct-name (ptr->info test2val)) 'test2)


(set-field! 'test2 'myval test2val 333)
(check-equal? (get-val 'test2 'myval test2val) 333)
(set-field! 'test2 'mytest test2val test2val)
(check-equal? (ptr=? (get-ptr 'test2 'mytest test2val) test2val) #t)



; I use this type in the testcases
(define-memstruct test-type ptrs: (p1 p2) vals: (v1))

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))