#lang racket

(require "chez-init.rkt")

; (define apply-k (lambda (k v) (k v)))
; (define make-k (lambda (v) v))

(define-datatype continuation continuation?
  [init-k]
  [append-k
   (L1 list?)
   (k (lambda (x) (or (procedure? x) (continuation? x))))]
  [flatten-cdr-k
   (ls list?)
   (k continuation?)]
  [flatten-car-k
   (flattened-cdr list?)
   (k continuation?)]
   
  )

(define flatten-cps
  (lambda (ls k)
    (if (null? ls)
	(apply-k k ls)
	(flatten-cps (cdr ls) (flatten-cdr-k ls k)))))


(define apply-k
  (lambda (k v)
;    (if (procedure? k)
;	(k v)
	(cases continuation k
           [flatten-cdr-k (ls k)
	      (if (list? (car ls))
		  (flatten-cps (car ls) (flatten-car-k v k))
		  (apply-k k (cons (car ls) v)))]
           [flatten-car-k (flattened-cdr k)
	      (append-cps v flattened-cdr k)]
	  [init-k ()
	    (pretty-print v)
	    (read-flatten-print)]
	  [append-k (L1 k)
	     (apply-k k (cons (car L1) v))]
          )))

(define append-cps 
  (lambda (L1 L2 k)
    (if (null? L1)
	(apply-k k L2)
	(append-cps (cdr L1)
		    L2
		    (append-k L1 k)))))
	     
(define read-flatten-print
  (lambda ()
    (display "enter slist to flatten: ")
    (let ([slist (read)])
      (unless (eq? slist 'exit)
	(flatten-cps slist (init-k))))))






;(trace append-cps flatten-cps apply-k)
