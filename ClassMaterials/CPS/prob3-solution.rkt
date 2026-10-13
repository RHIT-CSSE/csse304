#lang racket

(require "chez-init.rkt")
(require "cps-conversion-helper.rkt")
(require racket/trace)

(provide max-of-cps
         (rename-out [apply-k max-of-apply-k]
                     [init-k max-of-init-k]))

; PROB 3 - max-of
;
; (max-of lst) returns the largest number in a non-empty list of numbers.

(define max-of
  (lambda (lst)
    (if (null? (cdr lst))
        (car lst)
        (let ([best (max-of (cdr lst))])
          (if (> (car lst) best)
              (car lst)
              best)))))

; we'll need these

(define-datatype continuation continuation?
  [init-k]
  [step1 (lst list?) (k continuation?)]
  )

(define-cps-procedure (apply-k k v)
  (cases continuation k
    [init-k () v]
    [step1 (lst k)
           (if (> (car lst) v)
               (apply-k k (car lst))
               (apply-k k v))]
    ))

; EXERCISE - convert max-of to CPS

(define-cps-procedure (max-of-cps lst k)
  (if (null? (cdr lst))
      (apply-k k (car lst))
      (max-of-cps (cdr lst) (step1 lst k))))

; Uncomment to watch it run.  Tracing rebinds the name to a wrapper, so leave it
; commented while you run the tests: they look procedures up by identity.
; (trace max-of-cps apply-k)
