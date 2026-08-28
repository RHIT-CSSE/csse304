#lang racket

(provide pop-song? running-sum invert combine-consec)

(define pop-song?
  (lambda (lst)
    (nyi)))

(define running-sum
  (lambda (lst)
    (nyi)))


(define invert
  (lambda (lst)
    (nyi)))

(define combine-consec
  (lambda (lst)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
