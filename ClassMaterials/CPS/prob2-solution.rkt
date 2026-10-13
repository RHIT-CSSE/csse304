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

(define sum-digits
  (lambda (n)
    (if (< n 10)
        n
        (+ (remainder n 10) (sum-digits (quotient n 10))))))

; we'll need these

(define-datatype continuation continuation?
  [init-k]
  [step1 (n number?) (k continuation?)]
  )

(define-cps-procedure (apply-k k v)
  (cases continuation k
    [init-k () v]
    [step1 (n k)
           (apply-k k (+ (remainder n 10) v))]
    ))

; EXERCISE - convert sum-digits to CPS

(define-cps-procedure (sum-digits-cps n k)
  (if (< n 10)
      (apply-k k n)
      (sum-digits-cps (quotient n 10) (step1 n k))))

; Uncomment to watch it run.  Tracing rebinds the name to a wrapper, so leave it
; commented while you run the tests: they look procedures up by identity.
; (trace sum-digits-cps apply-k)
