#lang racket

(require "chez-init.rkt")
(require racket/trace)


(define (remove-zeros lst)
  (cond
    [(null? lst) '()]
    [(zero? (car lst)) (remove-zeros (cdr lst))]
    [else (cons (car lst) (remove-zeros (cdr lst)))]))

(define-datatype continuation continuation?
  [init-k]
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
      [init-k () v])))

(define remove-zeros-cps
  (lambda (lst k)
    'nyi))

