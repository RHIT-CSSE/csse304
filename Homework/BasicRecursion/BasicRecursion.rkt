#lang racket

(require racket/contract)

(provide interval-contains? interval-intersects? interval-union make-vec-from-points dot-product vector-magnitude distance)

(define (interval-rep? v)
  (and (list? v) (= 2 (length v)) (andmap integer? v)))

(define (vec-rep? v)
  (and (list? v) (= 3 (length v)) (andmap integer? v)))

(define/contract (interval-contains? interval point)
  (-> interval-rep? integer? boolean?)
  (nyi))

(define/contract (interval-intersects? i1 i2)
  (-> interval-rep? interval-rep? boolean?)
  (nyi))

(define/contract (interval-union i1 i2)
  (-> interval-rep? interval-rep? (listof interval-rep?))
  (nyi))

(define/contract (make-vec-from-points p1 p2)
  (-> vec-rep? vec-rep? vec-rep?)
  (nyi))

(define/contract (dot-product v1 v2)
  (-> (listof integer?) (listof integer?) number?)
  (nyi))

(define/contract (vector-magnitude v)
  (-> (listof integer?) number?)
  (nyi))

(define/contract (distance p1 p2)
  (-> (listof integer?) (listof integer?) number?)
  (nyi))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
