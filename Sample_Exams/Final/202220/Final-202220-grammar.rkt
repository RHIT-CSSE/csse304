#lang racket
(provide remove-double)

;; GRAMMAR QUESTION - 10 points
;;
;; So in this problem you will write code that works on a varation of the lambda calculus.
;; Recall that the lambda calculus has a 3 rules:

;; <LcExp> :- <identifier> | ( lambda (<identifier>) <LcExp> ) | ( <LcExp> <LcExp> )

;; This variation adds one more rule - a "double" application (i.e. an application with 2 parameters):
;;
;; ( <LcExp> <LcExp> <LcExp> )
;;
;; This is actually a shorthand for a "curried" function application
;;
;; ( <LcExp> <LcExp> <LcExp> ) is equivalent to ( ( <LcExp> <LcExp> ) <LcExp> )
;;
;; Write a function that takes an expression in the variant lambda calculus and returns the equivalent
;; structure in the original lambda calculus.
;;
;; For example:
;;
;; ((lambda (x) (lambda (y) (y x))) a (p q r)) becomes
;; (((lambda (x) (lambda (y) (y x))) a) ((p q) r))
;;
;; See the test cases for more examples.
;;
;; You can also assume that the reserved word "lambda" can never be an identifier (if you don't
;; do this, the variation grammar might seem ambigious).  If you didn't notice that - don't worry
;; about it.

(define remove-double
  (lambda (lc-exp)
    (nyi)))
        

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))