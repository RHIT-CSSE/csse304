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

; The unconverted dup-all, for reference.  Commented out so that a recursive
; call in your conversion cannot reach it by accident: writing
; (dup-all (cdr lst)) inside dup-all-cps reports dup-all as unbound, instead of
; quietly calling the original.
;
; (define dup-all
;   (lambda (lst)
;     (if (null? lst)
;         '()
;         (cons (car lst) (cons (car lst) (dup-all (cdr lst)))))))

; we'll need these

(define-datatype continuation continuation?
  [init-k]
  )

(define-cps-procedure (apply-k k v)
  (cases continuation k
    [init-k () v]))

; EXERCISE - convert dup-all to CPS

(define-cps-procedure (dup-all-cps lst k)
  'nyi)

; Uncomment to watch it run.  Tracing rebinds the name to a wrapper, so leave it
; commented while you run the tests: they look procedures up by identity.
; (trace dup-all-cps apply-k)
