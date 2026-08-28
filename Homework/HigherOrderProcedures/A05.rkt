#lang racket

(provide minimize-interval-list exists? product best remove-last)

; this first one is probably the hardest in the set
; so if you get stuck I'd try the later ones
(define minimize-interval-list
  (lambda (a)
    (nyi)))

(define exists?
  (lambda (a b)
    (nyi)))

(define best
  (lambda (proc lst)
    (nyi)))

(define product
  (lambda (a b)
    (nyi)))

(define remove-last
  (lambda (a b)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
