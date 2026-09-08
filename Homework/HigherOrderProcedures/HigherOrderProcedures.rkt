#lang racket

(require racket/contract)

(provide minimize-interval-list exists? product best remove-last)

; this first one is probably the hardest in the set
; so if you get stuck I'd try the later ones

(define (interval-rep? v)
  (and (list? v) (= 2 (length v)) (andmap integer? v)))

(define/contract (minimize-interval-list a)
  (-> (listof interval-rep?) (listof interval-rep?))
  (nyi))

(define/contract (exists? pred ls)
  (-> procedure? (listof any/c) boolean?)
  (nyi))

(define/contract (best proc lst)
  (-> procedure? (listof any/c) any/c)
  (nyi))

(define/contract (product s1 s2)
  (-> (listof any/c) (listof any/c) (listof (list/c any/c any/c)))
  (nyi))

(define/contract (remove-last element ls)
  (-> symbol? (listof symbol?) (listof symbol?))
  (nyi))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
