#lang racket

(require "chez-init.rkt")
(require "cps-conversion-helper.rkt")
(require racket/trace)

(provide dup-all-cps
         (rename-out [apply-k dup-all-apply-k]
                     [init-k dup-all-init-k]))

; PROB 4 - dup-all
;
; (dup-all lst) returns a list where every element of lst appears twice,
; e.g. (dup-all '(a b)) => (a a b b).

(define dup-all
  (lambda (lst)
    (if (null? lst)
        '()
        (cons (car lst) (cons (car lst) (dup-all (cdr lst)))))))

; we'll need these

(define-datatype continuation continuation?
  [init-k]
  [step1 (x always?) (k continuation?)]
  )

(define-cps-procedure (apply-k k v)
  (cases continuation k
    [init-k () v]
    [step1 (x k)
           (apply-k k (cons x (cons x v)))]
    ))

; EXERCISE - convert dup-all to CPS

(define-cps-procedure (dup-all-cps lst k)
  (if (null? lst)
      (apply-k k '())
      (dup-all-cps (cdr lst) (step1 (car lst) k))))

; Uncomment to watch it run.  Tracing rebinds the name to a wrapper, so leave it
; commented while you run the tests: they look procedures up by identity.
; (trace dup-all-cps apply-k)
