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
  [step1 (k continuation?)]
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
      [init-k () v]
      [step1 (k)
             (apply-k k (+ 1 v))
             ]
      )))

(define count-binones-cps
  (lambda (n k)
    (cond
      [(zero? n) (apply-k k 0)]                               ; base case
      [(even? n) (count-binones-cps (quotient n 2) k)]       ; tail-recursive case
      [else (count-binones-cps (quotient n 2) (step1 k))])))