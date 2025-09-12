#lang racket

(provide is-shadowed? convert-multip-calls convert-multip-lambdas convert-ifs)


(define is-shadowed?
  (lambda (var lc-exp)
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

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
