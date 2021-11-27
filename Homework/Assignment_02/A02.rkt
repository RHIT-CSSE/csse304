#lang racket

(provide choose sum-of-squares range my-set? union cross-product parallel? collinear?)

(define choose
  (lambda (a b)
    (nyi)))

(define sum-of-squares
  (lambda (a)
    (nyi)))

(define range
  (lambda (a b)
    (nyi)))

(define my-set?
  (lambda (a)
    (nyi)))

(define union
  (lambda (a b)
    (nyi)))

(define cross-product
  (lambda (a b)
    (nyi)))

(define parallel?
  (lambda (a b)
    (nyi)))

(define collinear?
  (lambda (a b c)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
