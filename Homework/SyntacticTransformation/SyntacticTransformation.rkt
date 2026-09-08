#lang racket

(require racket/contract)

(provide let->application let*->let qsort sort-list-of-symbols)

(define (scheme-code? v)
  (or (null? v)
      (symbol? v)
      (number? v)
      (string? v)
      (boolean? v)
      (char? v)
      (and (pair? v)
           (scheme-code? (car v))
           (scheme-code? (cdr v)))))

(define/contract (let->application expr)
  (-> scheme-code? scheme-code?)
  (nyi))

(define/contract (let*->let expr)
  (-> scheme-code? scheme-code?)
  (nyi))

(define/contract (qsort pred ls)
  (-> procedure? (listof any/c) (listof any/c))
  (nyi))

(define/contract (sort-list-of-symbols los)
  (-> (listof symbol?) (listof symbol?))
  (nyi))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
