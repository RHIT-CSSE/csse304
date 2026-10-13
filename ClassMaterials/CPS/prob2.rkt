#lang racket

(require "chez-init.rkt")
(require "cps-conversion-helper.rkt")
(require racket/trace)

(provide sum-digits-cps
         (rename-out [apply-k sum-digits-apply-k]
                     [init-k sum-digits-init-k]))

; PROB 2 - sum-digits
;
; (sum-digits n) returns the sum of the decimal digits of n, e.g.
; (sum-digits 902) => 9 + 0 + 2 => 11.

; The unconverted sum-digits, for reference.  Commented out so that a recursive
; call in your conversion cannot reach it by accident: writing
; (sum-digits (quotient n 10)) inside sum-digits-cps reports sum-digits as
; unbound, instead of quietly calling the original.
;
; (define sum-digits
;   (lambda (n)
;     (if (< n 10)
;         n
;         (+ (remainder n 10) (sum-digits (quotient n 10))))))

; we'll need these

(define-datatype continuation continuation?
  [init-k]
  )

(define-cps-procedure (apply-k k v)
  (cases continuation k
    [init-k () v]))

; EXERCISE - convert sum-digits to CPS

(define-cps-procedure (sum-digits-cps n k)
  'nyi)

; Uncomment to watch it run.  Tracing rebinds the name to a wrapper, so leave it
; commented while you run the tests: they look procedures up by identity.
; (trace sum-digits-cps apply-k)
