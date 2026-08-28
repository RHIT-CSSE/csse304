#lang racket

(provide slist-map slist-reverse slist-paren-count slist-depth slist-symbols-at-depth path-to make-c...r)

(define slist-map
  (lambda (a b)
    (nyi)))

(define slist-reverse
  (lambda (a)
    (nyi)))

(define slist-paren-count
  (lambda (a)
    (nyi)))

(define slist-depth
  (lambda (a)
    (nyi)))

(define slist-symbols-at-depth
  (lambda (a b)
    (nyi)))

(define path-to
  (lambda (a b)
    (nyi)))

(define make-c...r
  (lambda (str)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
