#lang racket

(provide free-vars bound-vars occurs-free? occurs-bound? lexical-address un-lexical-address)

(define free-vars
  (lambda (a)
    (nyi)))

(define bound-vars
  (lambda (a)
    (nyi)))

(define occurs-free?
  (lambda (a b)
    (nyi)))

(define occurs-bound?
  (lambda (a b)
    (nyi)))

(define lexical-address
  (lambda (a)
    (nyi)))

(define un-lexical-address
  (lambda (a)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
