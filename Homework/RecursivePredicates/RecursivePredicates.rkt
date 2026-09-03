#lang racket

(require racket/contract)

(provide intersection subset? relation? domain reflexive? multi-set? ms-size last all-but-last)

(define (relation-obj? r)
  (and (list? r)
       (andmap (lambda (p) (and (list? p) (= 2 (length p)))) r)))

(define (multi-set-rep? ms)
  (and (list? ms)
       (andmap (lambda (pair-rep)
                 (and (list? pair-rep)
                      (= 2 (length pair-rep))
                      (symbol? (car pair-rep))
                      (exact-positive-integer? (cadr pair-rep))))
               ms)))

(define/contract (intersection a b)
  (-> (listof any/c) (listof any/c) (listof any/c))
  (nyi))

(define/contract (subset? a b)
  (-> (listof any/c) (listof any/c) boolean?)
  (nyi))

(define/contract (relation? a)
  (-> any/c boolean?)
  (nyi))

(define/contract (domain a)
  (-> relation-obj? (listof any/c))
  (nyi))

(define/contract (reflexive? a)
  (-> relation-obj? boolean?)
  (nyi))

(define/contract (multi-set? a)
  (-> any/c boolean?)
  (nyi))

(define/contract (ms-size a)
  (-> multi-set-rep? integer?)
  (nyi))

(define/contract (last a)
  (-> (listof any/c) any/c)
  (nyi))

(define/contract (all-but-last a)
  (-> (listof any/c) (listof any/c))
  (nyi))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
