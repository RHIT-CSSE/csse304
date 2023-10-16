#lang racket

(require "chez-init.rkt")
(require racket/trace)

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
  [step1 (lst list?) (k continuation?)]
  [step2 (old-v list?) (k continuation?)]
  ; more types here 
  )

(define flatten-cps
  (lambda (lst k)
    (if (null? lst)
        (apply-k k '())
        (flatten-cps (cdr lst) (step1 lst k)))))


(define apply-k
  (lambda (k v)
	(cases continuation k
          [init-k () v]
          [step1 (lst k)
                 (if (list? (car lst))
                     (flatten-cps (car lst) (step2 v k))
                     (apply-k k (cons (car lst) v)))]
          [step2 (old-v k)
                 (apply-k k (append v old-v))]
          )))

(trace flatten-cps apply-k)

(flatten-cps '(a (b c) (d ((e (f))) g)) '(init-k))