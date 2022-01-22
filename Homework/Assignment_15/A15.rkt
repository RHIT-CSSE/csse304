#lang racket

(require "../chez-init.rkt")
(provide set-of-cps make-k apply-k 1st-cps map-cps make-cps domain-cps member?-cps andmap-cps free-vars-cps continuation? init-k list-k union-cps remove-cps memoize subst-leftmost)

(define set-of-cps
  (lambda (a b)
    (nyi)))

(define make-k
  (lambda (a)
    (nyi)))

(define apply-k
  (lambda (a b)
    (nyi)))

(define 1st-cps
  (lambda (a b)
    (nyi)))

(define map-cps
  (lambda (a b c)
    (nyi)))

(define make-cps
  (lambda (a)
    (nyi)))

(define domain-cps
  (lambda (a b)
    (nyi)))

(define member?-cps
  (lambda (a b c)
    (nyi)))

(define andmap-cps
  (lambda (a b c)
    (nyi)))

(define free-vars-cps
  (lambda (a b)
    (nyi)))

(define-datatype continuation continuation? 
[init-k] 
[list-k])

(define union-cps
  (lambda (a b c)
    (nyi)))

(define remove-cps
  (lambda (a b c)
    (nyi)))

(define memoize
  (lambda (a b c)
    (nyi)))

(define subst-leftmost
  (lambda (a b c d)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
