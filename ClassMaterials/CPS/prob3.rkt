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

; The unconverted max-of, for reference.  Commented out so that a recursive call
; in your conversion cannot reach it by accident: writing (max-of (cdr lst))
; inside max-of-cps reports max-of as unbound, instead of quietly calling the
; original.
;
; (define max-of
;   (lambda (lst)
;     (if (null? (cdr lst))
;         (car lst)
;         (let ([best (max-of (cdr lst))])
;           (if (> (car lst) best)
;               (car lst)
;               best)))))

; we'll need these

(define-datatype continuation continuation?
  [init-k]
  )

(define-cps-procedure (apply-k k v)
  (cases continuation k
    [init-k () v]))

; EXERCISE - convert max-of to CPS

(define-cps-procedure (max-of-cps lst k)
  'nyi)

; Uncomment to watch it run.  Tracing rebinds the name to a wrapper, so leave it
; commented while you run the tests: they look procedures up by identity.
; (trace max-of-cps apply-k)
