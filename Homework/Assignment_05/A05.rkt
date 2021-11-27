#lang racket

(provide minimize-interval-list exists? product replace remove-last)

(define minimize-interval-list
  (lambda (a)
    (nyi)))

(define exists?
  (lambda (a b)
    (nyi)))

(define product
  (lambda (a b)
    (nyi)))

(define replace
  (lambda (a b c)
    (nyi)))

(define remove-last
  (lambda (a b)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
