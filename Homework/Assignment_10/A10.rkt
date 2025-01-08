#lang racket

(provide free-vars bound-vars lexical-address un-lexical-address)

(define free-vars
  (lambda (a)
    (nyi)))

(define bound-vars
  (lambda (a)
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
