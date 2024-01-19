#lang racket

(require "chez-init.rkt")
(require racket/trace)

; prepend to all takes value and a list of lists
; and returns a new list of lists with the value
; prepended to all

; (prepend-to-all 0 '((1 2) (3))) -> '((0 1 2) (0 3))

(define prepend-to-all
  (lambda (val lst)
    (if (null? lst)
        lst
        (cons (cons val (car lst))
              (prepend-to-all val (cdr lst))))))


; TODO - convert prepend-to-all to tail form function

(define prepend-to-all-tail
  (lambda (val lst acc)
    'nyi))

; IN CLASS LIVE EXERCISE - convert powerset to tail form function

(define powerset
  (lambda (lst)
    (if (null? lst)
        '(())
        (let* ((sub-powerset (powerset (cdr lst)))
               (sub-powerset-with-car (prepend-to-all (car lst) sub-powerset)))
          (append sub-powerset sub-powerset-with-car)))))

; we'll need these

(define-datatype continuation continuation?
  [init-k]
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
      [init-k () v])))

(define prepend-to-all-cps
  (lambda (val lst acc k)
    'nyi))

(define powerset-cps
  (lambda (lst k)
    'nyi))
  
(trace powerset-cps apply-k prepend-to-all-cps)               