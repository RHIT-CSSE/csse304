#lang racket

(require "chez-init.rkt")
(require "cps-conversion-helper.rkt")

(provide flatten-cps apply-k continuation? init-k)

;; The unconverted flatten, for reference.  Commented out so that a recursive
;; call in the conversion cannot reach it by accident: a call to flatten inside
;; flatten-cps reports flatten as unbound instead of quietly calling the
;; original.
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
  [flatten-cdr-k
   (ls list?)
   (k continuation?)]
  [flatten-car-k
   (flattened-cdr list?)
   (k continuation?)]   
  )

;; Every call to a substantial procedure here -- flatten-cps and apply-k -- is
;; the last thing its clause does, so the tail position checks find none of them
;; in a non-tail position.
(define-cps-procedure (flatten-cps ls k)
  (if (null? ls)
      (apply-k k ls)
      (flatten-cps (cdr ls) (flatten-cdr-k ls k))))

(define-cps-procedure (apply-k k v)
  (cases continuation k
    [init-k () v]
    [flatten-cdr-k (ls k)
                   (if (list? (car ls))
                       (flatten-cps (car ls) (flatten-car-k v k))
                       (apply-k k (cons (car ls) v)))]
    [flatten-car-k (flattened-cdr k)
                   (apply-k k (append v flattened-cdr))]
    ))
