#lang racket

(provide make-slist-leaf-iterator subst-leftmost)

(define make-slist-leaf-iterator
  (lambda (a)
    (nyi)))

(define subst-leftmost
  (lambda (a b c d)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
