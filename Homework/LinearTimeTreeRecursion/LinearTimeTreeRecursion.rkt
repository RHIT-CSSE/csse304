#lang racket

(require racket/contract)

(provide group-by-two group-by-n bt-leaf-sum bt-inorder-list bt-max bt-max-interior)

(define (bintree? t)
  (or (integer? t)
      (and (list? t)
           (= 3 (length t))
           (symbol? (car t))
           (bintree? (cadr t))
           (bintree? (caddr t)))))

(define/contract (group-by-two ls)
  (-> (listof any/c) (listof (listof any/c)))
  (nyi))

(define/contract (group-by-n ls n)
  (-> (listof any/c) (and/c integer? (>=/c 2)) (listof (listof any/c)))
  (nyi))

(define/contract (bt-leaf-sum t)
  (-> bintree? integer?)
  (nyi))

(define/contract (bt-inorder-list t)
  (-> bintree? (listof symbol?))
  (nyi))

(define/contract (bt-max t)
  (-> bintree? integer?)
  (nyi))

(define/contract (bt-max-interior t)
  (-> bintree? symbol?)
  (nyi))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
