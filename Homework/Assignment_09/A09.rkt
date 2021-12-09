#lang racket

(provide sn-list-recur sn-list-sum sn-list-map sn-list-paren-count sn-list-reverse sn-list-occur sn-list-depth bt-recur bt-sum bt-inorder)

(define sn-list-recur
  (lambda (a b c)
    (nyi)))

(define sn-list-sum
  (lambda (a)
    (nyi)))

(define sn-list-map
  (lambda (a b)
    (nyi)))

(define sn-list-paren-count
  (lambda (a)
    (nyi)))

(define sn-list-reverse
  (lambda (a)
    (nyi)))

(define sn-list-occur
  (lambda (a b)
    (nyi)))

(define sn-list-depth
  (lambda (a)
    (nyi)))

(define bt-recur
  (lambda (a b)
    (nyi)))

(define bt-sum
  (lambda (a)
    (nyi)))

(define bt-inorder
  (lambda (a)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
