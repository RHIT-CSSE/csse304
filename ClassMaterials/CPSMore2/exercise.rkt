#lang racket

(require "chez-init.rkt")
(require "cps-conversion-helper.rkt")
(require racket/trace)

(provide flatten-cps apply-k continuation? init-k)

;; The unconverted flatten, for reference.  It is commented out so that a
;; recursive call in your conversion cannot reach it by accident: writing
;; (flatten (cdr lst)) inside flatten-cps reports flatten as unbound, instead of
;; quietly calling the original.
;
; (define flatten
;   (lambda (lst)
;     (if (null? lst)
;         '()
;         (let ((flat-cdr (flatten (cdr lst))))
;           (if (list? (car lst))
;               (append (flatten (car lst)) flat-cdr)
;               (cons (car lst) flat-cdr))))))

(define-datatype continuation continuation?
  [init-k]
  ; more types here 
  )

;; flatten-cps and apply-k are declared with define-cps-procedure instead of
;; define.  It behaves the same, and also keeps enough of the code for the tail
;; position checks: for each substantial procedure, they look for calls to a
;; substantial procedure from a non-tail position, and flatten-cps and apply-k
;; are the substantial ones here.
;;
;; Those checks look procedures up by identity, so a plain define would not be
;; found, and tracing rebinds a name to a wrapper.  Leave the trace line
;; commented out while the tests run.
(define-cps-procedure (flatten-cps lst k)
  'nyi)

(define-cps-procedure (apply-k k v)
  (cases continuation k
    [init-k () v]
    ))

; (trace flatten-cps apply-k)

; (flatten-cps '(a (b c) (d ((e (f))) g)) (init-k))
