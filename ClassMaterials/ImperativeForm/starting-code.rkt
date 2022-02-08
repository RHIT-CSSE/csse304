#lang racket

; -- Convert to imperative form ----------------------
; -- This puts it into a form where all of the ---------
; -- recursion can be replaced by assignments and "goto"s

(require "chez-init.ss")

(define any? (lambda (x) #t))

(define-datatype continuation continuation?  ; no changes
  [init-k]
  [append-k (a any?) (k continuation?)]
  [rev1-k (car-L any?) (k continuation?)]
  [rev2-k (reversed-cdr (list-of? any?)) (k continuation?)])

; global variables take the place of parameters of
; substantial procedures.
(define L 'nothing)  ; current list
(define k 'nothing)  ; current continuation
(define a 'nothing)  ; used for append
(define b 'nothing)  ; used for append
(define v 'nothing)  ; 2nd parameter of apply-k application

; The next 3 procedures are from the previous file. 
; Convert them.

(define apply-k
  (lambda (k v)
    (cases continuation k
      [init-k () (printf "answer: ~s~n" v)]
      [append-k (a k) (apply-k k (cons (car a) v))]
      [rev1-k (car-L k)
	(if (pair? car-L)
	    (reverse*-cps car-L (rev2-k v k))
	    (append-cps v (list car-L) k))]
      [rev2-k (reversed-cdr k)
	(append-cps reversed-cdr (list v) k)])))

(define reverse*-cps
  (lambda (L k)
    (if (null? L)
        (apply-k k '())
        (reverse*-cps (cdr L)
                      (rev1-k (car L) k)))))
(define append-cps
  (lambda (a b k)
    (if (null? a)
        (apply-k k b)
        (append-cps (cdr a)
                    b
                    (append-k a k)))))

; This driver procedure isn't really substantial,
; So it's okay for it to have a parameter.
(define test-reverse
  (lambda (slist)
    (set! L slist)
    (set! k (init-k))
    (reverse*-cps L k))) ;FIXME

(test-reverse
  '(1 ((2 3) () (((4))))))

(define *tracing* #f)

(define trace-it
  (lambda (sym)
    (when *tracing*
      (printf "~a " sym)
      (printf "L=~s" L)
      (printf "  a=~s" a)
      (printf "  b=~s" b)
      (printf "  v=~s~%" v)
      (printf "           k=~s~%" k))))



