#lang racket

(require "chez-init.rkt")

(define flatten
  (lambda (lst)
    (if (null? lst)
        '()
        (let ((flat-cdr (flatten (cdr lst))))
          (if (list? (car lst))
              (append (flatten (car lst)) flat-cdr)
              (cons (car lst) flat-cdr))))))

(define-datatype continuation continuation?
  [init-k]
  ; more types here 
  )

(define flatten-cps
  (lambda (ls k)
    'nyi
    ))


(define apply-k
  (lambda (k v)
	(cases continuation k
          [init-k () v]
          ; more code here
          )))

(flatten-cps '(a (b c) (d ((e (f))) g)) '(init-k))