#lang racket

(provide matrix-ref matrix? matrix-transpose filter-in invert pascal-triangle)

(define matrix-ref
  (lambda (a b c)
    (nyi)))

(define matrix?
  (lambda (a)
    (nyi)))

(define matrix-transpose
  (lambda (a)
    (nyi)))

(define filter-in
  (lambda (a b)
    (nyi)))

(define invert
  (lambda (a)
    (nyi)))

(define pascal-triangle
  (lambda (a)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
