#lang racket
(require "chez-init.rkt")

(provide slist-subst-cps list-k init-k)

;; So in this problem we're going considering a slist-subst
;; slist-subst takes an slist old value and new value.  It returns a
;; new slist with all instances of of the old value replaced with the
;; new value.
;;
;; (slist-subst '((a b) a) 'a 'q) => '((q b) q)
;;
;; Here is my solution for this problem:
;;
(define slist-subst-orig
  (lambda (slist old new)
    (cond [(null? slist) '()]
          [(symbol? (car slist))
           (cons (if (eqv? (car slist) old) new (car slist))
                 (slist-subst-orig (cdr slist) old new))]
          [else (cons (slist-subst-orig (car slist) old new)
                      (slist-subst-orig (cdr slist) old new))])))


(define-datatype continuation continuation?
  [init-k]
  [list-k]
  ;more types here
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
      [init-k () v]
      [list-k () (list v)] ; used in test cases
      ;more cases here
      )))


(define slist-subst-cps
  (lambda (slist old new k)
    'nyi))
