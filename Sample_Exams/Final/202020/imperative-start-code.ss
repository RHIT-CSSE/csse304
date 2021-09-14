(load "chez-init.ss")

; Original solution to reflexive? problem (non-cps)

(define all-symbols  ; Find all symbols in the domain and range.
  (lambda (rel)      ; Perhaps it could be slightly more efficient, 
    (if (null? rel)  ; but every approach will be Omega(N^2).
	'()
	(union (list (caar rel))
	       (union (list (cadar rel))
		      (all-symbols (cdr rel)))))))

(define reflexive-pairs
  (lambda (rel)
    (if (null? rel) 
	'()
	(let ([rest (reflexive-pairs (cdr rel))])
	  (if (equal? (caar rel) (cadar rel))
	      (cons (car rel) rest)
	      rest)))))

(define reflexive?
  (lambda (rel)
    (= (length (all-symbols rel)) (length (reflexive-pairs rel)))))

(define memq
   (lambda (sym ls)
     (cond [(null? ls) #f]
	   [(eq? sym (car ls)) #t]
	   [else (memq sym (cdr ls))])))

(define union ; assumes that both arguments are sets.
   (lambda (s1 s2) (if (null? s1)
			 s2
			 (let ([cdr-union (union (cdr s1) s2)])
			   (if (memq (car s1) s2)
			       cdr-union
			       (cons (car s1) cdr-union))))))

; --------------------------- cps solution with datatype continuation representation

(define-datatype kontinuation kontinuation? ; should not have to change
  [init-k]
  [list-k]
  [cdr-union-k (car-s1 symbol?)
	       (s2 (list-of symbol?)) ; and it's a set
	       (k kontinuation?)]
  [union-memq-k (car-s1 symbol?)
		(cdr-union list?)
		(k kontinuation?)]
  [all-syms-k  (car-rel (list-of symbol?))
	       (k kontinuation?)]
  [all-union-k (caar symbol?)
	       (k kontinuation?)]
  [ref-pairs-k (car-rel (list-of symbol?))
	       (k kontinuation?)]
  [ref-all-k  (rel (list-of (list-of symbol?)))
	       (k kontinuation?)]
  [ref-ref-pairs-k (all-syms (list-of symbol?))
		   (k kontinuation?)])

(define apply-k
  (lambda (k v)
    (cases kontinuation k
	   [init-k () v] ; v is final enswer
	   [list-k () (list v)]
	   [cdr-union-k (car-s1 s2  k)
			(memq-cps car-s1 s2 (union-memq-k car-s1 v k))]
	   [union-memq-k (car-s1 cdr-union k) (apply-k k (if v
							     cdr-union
							     (cons car-s1 cdr-union)))]
	   [all-syms-k (car-rel k)
		       (union-cps (list (cadr car-rel)) v (all-union-k (car car-rel) k))]
	   [all-union-k (caar k)
			(union-cps (list caar) v k)]
	   [ref-pairs-k (car-rel k)
			(apply-k k (if (equal? (car car-rel) (cadr car-rel))
				       (cons car-rel v)
				       v))]
	   [ref-all-k (rel k)
		      (reflexive-pairs-cps rel (ref-ref-pairs-k v k))]
	   [ref-ref-pairs-k (all-syms k)
			    (apply-k k (= (length all-syms) (length v)))])))
    
(define all-symbols-cps  ; Find all symbols in the domain and range.
  (lambda (rel k)      ; Perhaps it could be slightly more efficient, but 
    (if (null? rel)  ; any approach will be O(N^2).
	(apply-k k '())
	(all-symbols-cps (cdr rel) (all-syms-k (car rel) k)))))

(define reflexive-pairs-cps
  (lambda (rel k)
    (if (null? rel) 
	(apply-k k '())
	(reflexive-pairs-cps (cdr rel) (ref-pairs-k (car rel) k)))))

(define reflexive?-cps
  (lambda (rel k)
    (all-symbols-cps rel (ref-all-k rel k))))

(define union-cps ; assumes that both arguments are sets.
  (lambda (s1 s2 k) (if (null? s1)
			(apply-k k s2)
			(union-cps (cdr s1) s2 (cdr-union-k (car s1) k)))))

(define memq-cps
  (lambda (sym ls k) (cond [(null? ls) (apply-k k #f)]
			   [(eq? (car ls) sym) (apply-k k #t)]
			   [else (memq-cps sym (cdr ls) k)])))

; tests

(reflexive?-cps '() (init-k))
(reflexive?-cps '((a a)) (init-k)) 
(reflexive?-cps '((a b)) (init-k))
(reflexive?-cps '((b a)) (init-k))
(reflexive?-cps '((b a) (a b)) (init-k))
(reflexive?-cps '((b a) (a a) (a b) (b b)) (init-k))

'(trace apply-k reflexive?-cps memq-cps union-cps reflexive-pairs-cps all-symbols-cps)

; ---------------------- Your solution goes here:

(define-datatype kontinuation kontinuation? ; copied here so you don't have to scroll so much
  [init-k]
  [list-k]
  [cdr-union-k (car-s1 symbol?)
	       (s2 (list-of symbol?)) ; and it's a set
	       (k kontinuation?)]
  [union-memq-k (car-s1 symbol?)
		(cdr-union list?)
		(k kontinuation?)]
  [all-syms-k  (car-rel (list-of symbol?))
	       (k kontinuation?)]
  [all-union-k (caar symbol?)
	       (k kontinuation?)]
  [ref-pairs-k (car-rel (list-of symbol?))
	       (k kontinuation?)]
  [ref-all-k  (rel (list-of (list-of symbol?)))
	       (k kontinuation?)]
  [ref-ref-pairs-k (all-syms (list-of symbol?))
		   (k kontinuation?)])

; You may not need all of these variables, and you may need others. 
; These are here to help you quickly begin to think of what is needed.
(define k) 
(define v)
(define rel-ref)    ; relation variable for "argument" to reflexive?-imp
(define rel-all)    ; relation variable for "argument" to all-syms-imp
(define rel-pairs)  ; relation variable for "argument" to reflexive-pairs-imp
(define s1)         ; first "argument" to union-imp
(define s2)         ; second "argument" to union-imp
(define sym-memq)   ; sym "argument" to memq-imp
(define ls)         ; ls :arument" to memq-imp

; The calls to trace-it will do nothing unless you set the global variable *tracing* to #t.
; This makes it easy to turn tracing on and off.
; I suggest that you leave all of the calls to trace-it in place, just in case you need to use it.
; I improved (I hope you'll agree) trace-it so that instead of printing all of the global 
; variables each time, it prints only the ones that are relevant to the current call (I always print k).

(define apply-k-imp
  (lambda ()
    (trace-it "apply-k")
    (cases kontinuation k
	   [init-k () v] ; v is final answer
	   [list-k () (list v)]
	   [cdr-union-k (car-s1 s2  k1) ; I did this one for you.
	      (set! sym-memq car-s1)
	      (set! ls s2)
	      (set! k (union-memq-k car-s1 v k1))
	      (memq-imp)]
	   [union-memq-k (car-s1 cdr-union k1)  ; I did this one for you.
	      (set! v (if v
			  cdr-union
			  (cons car-s1 cdr-union)))
	      (set! k k1)
	      (apply-k-imp)]
	   [all-syms-k (car-rel k1)
	      'fill-it-in]

	   [all-union-k (caar k1)
	      'fill-it-in]

	   [ref-pairs-k (car-rel k1)
	      'fill-it-in] 

	   [ref-all-k (rel k1)
	      'fill-it-in]

	   [ref-ref-pairs-k (all-syms k1)
	      'fill-it-in] )))

(define reflexive?-imp
  (lambda ()
    (trace-it "reflex? ")
    'fill-it-in
    ))

(define reflexive-pairs-imp
  (lambda ()
    (trace-it "pairs   ")
    'fill-it-in
    ))

(define all-syms-imp
  (lambda ()
    (trace-it "all-syms")
    'fill-it-in
    ))

(define union-imp ; I did this one for you.
  (lambda ()
    (trace-it "union   ")
    (if (null? s1)
	(begin (set! v s2)
	       (apply-k-imp))
	(begin (set! k (cdr-union-k (car s1) s2 k))
	       (set! s1 (cdr s1))
	       (union-imp)))))

(define memq-imp ; I did this one for you.
  (lambda ()
    (trace-it "memq    ")
    (cond [(null? ls) (set! v #f) (apply-k-imp)]
	  [(eq? (car ls) sym-memq) (set! v #t) (apply-k-imp)]
	  [else (set! ls (cdr ls)) (memq-imp)])))

(define test
  (lambda (rel)
    (set! rel-ref rel)
    (set! k (init-k))
    (reflexive?-imp)))


; -----------------------------  tracing

(define *tracing* #f)

(define trace-it
  (lambda (sym)
    (when *tracing*
      (printf "~a " sym)
      (if (string=? sym "reflex? ") (printf "rel-ref=~a " rel-ref))
      (if (string=? sym "all-syms") (printf "rel-all=~a " rel-all))
      (if (string=? sym "pairs   ") (printf "rel-pairs=~a " rel-pairs))
      (if (string=? sym "union   ") (printf "s1=~s " s1))
      (if (string=? sym "union   ") (printf "s2=~s " s2))
      (if (string=? sym "memq    ") (printf "sym-memq=~s " sym-memq))
      (if (string=? sym "memq    ") (printf "ls=~s" ls))
      (unless (string=? sym "apply-k") (printf "~%         "))
      (if (string=? sym "apply-k")  (printf " v=~s " v))
      (printf "k=~s~%" k))))


; some tests:

'(test '())
'(test '((a a)))
'(test '((a b)))



  
  
