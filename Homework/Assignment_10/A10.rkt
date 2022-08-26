#lang racket

(provide free-vars bound-vars lexical-address un-lexical-address convert-multip-calls convert-multip-lambdas convert-ifs)

(define free-vars
  (lambda (a)
    (nyi)))

(define bound-vars
  (lambda (a)
    (nyi)))


(define convert-multip-calls
  (lambda (lcexp)
    (nyi)))


(define convert-multip-lambdas
  (lambda (lcexp)
    (nyi)))

(define convert-ifs
  (lambda (exp)
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
