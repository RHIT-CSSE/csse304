#lang racket

(provide intersection subset? relation? domain reflexive? multi-set? ms-size last all-but-last)

(define intersection
  (lambda (a b)
    (nyi)))

(define subset?
  (lambda (a b)
    (nyi)))

(define relation?
  (lambda (a)
    (nyi)))

(define domain
  (lambda (a)
    (nyi)))

(define reflexive?
  (lambda (a)
    (nyi)))

(define multi-set?
  (lambda (a)
    (nyi)))

(define ms-size
  (lambda (a)
    (nyi)))

(define last
  (lambda (a)
    (nyi)))

(define all-but-last
  (lambda (a)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
