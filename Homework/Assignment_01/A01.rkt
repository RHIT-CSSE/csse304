#lang racket

(provide interval-contains? interval-intersects? interval-union my-first my-second my-third make-vec-from-points dot-product vector-magnitude distance)

(define interval-contains?
  (lambda (a b)
    (nyi)))

(define interval-intersects?
  (lambda (a b)
    (nyi)))

(define interval-union
  (lambda (a b)
    (nyi)))

(define my-first
  (lambda (a)
    (nyi)))

(define my-second
  (lambda (a)
    (nyi)))

(define my-third
  (lambda (a)
    (nyi)))

(define make-vec-from-points
  (lambda (a b)
    (nyi)))

(define dot-product
  (lambda (a b)
    (nyi)))

(define vector-magnitude
  (lambda (a)
    (nyi)))

(define distance
  (lambda (a b)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
