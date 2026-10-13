#lang racket

(require "chez-init.rkt")
(require "cps-conversion-helper.rkt")
(require racket/trace)

(provide list-last-cps
         (rename-out [apply-k list-last-apply-k]
                     [init-k list-last-init-k]))

; PROB 1 - list-last
;
; (list-last lst) returns the last element of a non-empty list.
;
; There are no case 3 cases in this one: every recursive call is already in tail
; position, so converting it uses step 1 (the directly calculated result) and
; step 2 (the tail recursive call) only.

; The unconverted list-last, for reference.  Commented out so that a recursive
; call in your conversion cannot reach it by accident: writing
; (list-last (cdr lst)) inside list-last-cps reports list-last as unbound,
; instead of quietly calling the original.
;
; (define list-last
;   (lambda (lst)
;     (if (null? (cdr lst))
;         (car lst)
;         (list-last (cdr lst)))))

; we'll need these

(define-datatype continuation continuation?
  [init-k]
  )

(define-cps-procedure (apply-k k v)
  (cases continuation k
    [init-k () v]))

; EXERCISE - convert list-last to CPS

(define-cps-procedure (list-last-cps lst k)
  'nyi)

; Uncomment to watch it run.  Tracing rebinds the name to a wrapper, so leave it
; commented while you run the tests: they look procedures up by identity.
; (trace list-last-cps apply-k)
