#lang racket

(require racket/contract)

(provide curry2 curried-compose compose make-list-c reverse-it map-by-position empty-BST empty-BST? BST-insert BST-inorder BST? BST-element BST-left BST-right BST-insert-nodes BST-contains? BST-height)

(define (bst-rep? v)
  (or (null? v)
      (and (list? v)
           (= 3 (length v))
           (integer? (car v))
           (bst-rep? (cadr v))
           (bst-rep? (caddr v)))))

(define/contract (curry2 f)
  (-> procedure? procedure?)
  (nyi))

(define/contract (curried-compose f)
  (-> procedure? procedure?)
  (nyi))

(define/contract compose
  (->* () #:rest (listof procedure?) procedure?)
  (lambda fns
    (nyi)))

(define/contract (make-list-c n)
  (-> exact-nonnegative-integer? procedure?)
  (nyi))

(define/contract (reverse-it lst)
  (-> (listof any/c) (listof any/c))
  (nyi))

(define/contract (map-by-position fns args)
  (-> (listof procedure?) (listof any/c) (listof any/c))
  (nyi))

(define/contract (empty-BST)
  (-> bst-rep?)
  (nyi))

(define/contract (empty-BST? obj)
  (-> any/c boolean?)
  (nyi))

(define/contract (BST-insert num bst)
  (-> integer? bst-rep? bst-rep?)
  (nyi))

(define/contract (BST-inorder bst)
  (-> bst-rep? (listof integer?))
  (nyi))

(define/contract (BST? obj)
  (-> any/c boolean?)
  (nyi))

(define/contract (BST-element bst)
  (-> bst-rep? integer?)
  (nyi))

(define/contract (BST-left bst)
  (-> bst-rep? bst-rep?)
  (nyi))

(define/contract (BST-right bst)
  (-> bst-rep? bst-rep?)
  (nyi))

(define/contract (BST-insert-nodes bst nums)
  (-> bst-rep? (listof integer?) bst-rep?)
  (nyi))

(define/contract (BST-contains? bst num)
  (-> bst-rep? integer? boolean?)
  (nyi))

(define/contract (BST-height bst)
  (-> bst-rep? integer?)
  (nyi))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
