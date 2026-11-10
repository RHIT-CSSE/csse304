#lang racket

(require racket/trace)

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


(define (apply-k k v)
  (k v))
(define init-k (lambda (v) v))
(define (dup-all-cps lst k)
  (if (null? lst)
        (apply-k k '())
        (dup-all-cps (cdr lst) (lambda (v) (apply-k k (cons (car lst) (cons (car lst) v)))))))

(dup-all-cps '(a b c) init-k)

