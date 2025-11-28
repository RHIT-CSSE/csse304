#lang racket

(require "chez-init.rkt")
(require racket/trace)


; Counts the number of 1s in a numbers binary representation
(define (count-binones n)
  (cond
    [(zero? n) 0]                               ; base case
    [(even? n) (count-binones (quotient n 2))]       ; tail-recursive case
    [else (+ 1 (count-binones (quotient n 2)))]))    ; non-tail-recursive case


(define-datatype continuation continuation?
  [init-k]
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
      [init-k () v])))

(define count-binones
  (lambda (lst k)
    'nyi))

