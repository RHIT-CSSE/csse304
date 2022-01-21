#lang racket

(require "chez-init.rkt")

(define apply-k (lambda (k v) (k v)))
(define make-k (lambda (v) v))

(define read-flatten-print
  (lambda ()
    (display "enter slist to flatten: ")
    (let ([slist (read)])
      (unless (eq? slist 'exit)
	(flatten-cps slist 
	  (make-k (lambda (val)
		    (pretty-print val)
		    (read-flatten-print))))))))

(define flatten-cps
  (lambda (ls k)
    (if (null? ls)
	(apply-k k ls)
	(flatten-cps (cdr ls)
	  (make-k (lambda (v)
		    (if (list? (car ls))
			(flatten-cps (car ls)
			  (make-k (lambda (u) (append-cps u v k))))
			(apply-k k (cons (car ls) v)))))))))

(define append-cps 
  (lambda (L1 L2 k)
    (if (null? L1)
	(apply-k k L2)
	(append-cps (cdr L1)
		    L2
		    (make-k (lambda (appended-cdr)
			      (apply-k k (cons (car L1)
					       appended-cdr))))))))


;(trace append-cps flatten-cps apply-k)
