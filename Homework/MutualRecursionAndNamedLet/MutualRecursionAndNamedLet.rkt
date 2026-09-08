#lang racket

(require racket/contract)

(provide pop-song? running-sum invert combine-consec)

(define/contract (pop-song? lst)
  (-> (listof symbol?) boolean?)
  (nyi))

(define/contract (running-sum lst)
  (-> (listof number?) (listof number?))
  (nyi))

(define/contract (invert lst)
  (-> (listof (list/c any/c any/c)) (listof (list/c any/c any/c)))
  (nyi))

(define/contract (combine-consec lst)
  (-> (listof integer?) (listof (list/c integer? integer?)))
  (nyi))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
