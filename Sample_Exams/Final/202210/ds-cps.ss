(load "chez-init.ss")
;; DATASTRUCT CPS QUESTION (10 points)
;;
;; suffix-sums takes a list of numbers as its argument.  It returns a
;; list of the sums of the non-empty suffixes of the list.  For
;; example, (suffix-sums '(1 2 3)) returns (1+2+3 2+3 3) i.e. (6 5 3).
;;
;; suffix-sums uses sumlist which sums all the elements in a list
;;
;; Here's the original version of the functions

(define (suffix-sums-orig lst)
  (if (null? lst)
      '()
      (cons (sumlist-orig lst) (suffix-sums-orig (cdr lst)))))

(define (sumlist-orig lst)
  (if (null? lst)
      0
      (+ (car lst) (sumlist-orig (cdr lst)))))


;; Here's the same code, converted to lambda-style cps.  Note I'ved
;; added a -l suffix so its clear these are the lambda versions.

(define apply-k-l
  (lambda (k v)
    (k v)))

(define make-k-l    ; lambda is the "real" continuation 
  (lambda (v) v)) ; constructor here.



(define (sumlist-l-cps lst k)
  (if (null? lst)
      (apply-k-l k 0)
      (sumlist-l-cps (cdr lst) (make-k-l (lambda (cdr-sum)
                                       (apply-k-l k (+ (car lst) cdr-sum)))))))

(define (suffix-sums-l-cps lst k)
  (if (null? lst)
      (apply-k-l k '())
      (sumlist-l-cps lst (make-k-l (lambda (lst-sum)
                                 (suffix-sums-l-cps (cdr lst) (make-k-l (lambda (list-of-sums)
                                                                   (apply-k-l k (cons lst-sum list-of-sums))))))))))

;; Now convert this algorithm to datastructure cps.  You may use
;; either the original code or the lambda cps code as your starting
;; point, but you may not make a new version of the code that works
;; differently.  You may assume any function used in the lambda-cps
;; version in a non-tail position is non-substantial.


(define-datatype continuation continuation?
  [init-k]      ;; this is used by the tests
  [list-init-k] ;; this is used by the tests
  ;; add your continuation types here
  )


(define apply-k-ds
  (lambda (k v)
    (cases continuation k
	   [init-k () v] ;; used by the tests
           [list-init-k () (list v)] ;; used by the tests
           ;; your new continuation types here
           )))


(define (sumlist-ds-cps lst k)
  'nyi
)


(define (suffix-sums-ds-cps lst k)
  'nyi
)
