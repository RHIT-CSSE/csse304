#lang racket

(provide let->application let*->let qsort sort-list-of-symbols)

(define let->application
  (lambda (a)
    (nyi)))

(define let*->let
  (lambda (a)
    (nyi)))

(define qsort
  (lambda (a b)
    (nyi)))

(define sort-list-of-symbols
  (lambda (a)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
