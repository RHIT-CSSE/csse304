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
  [step1 (slist list?) (old symbol?) (new symbol?) (k continuation?)]
  [step3 (recur-car list?) (k continuation?)]
  [step2 (slist list?) (old symbol?) (new symbol?) (k continuation?)]
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
      [init-k () v]
      [list-k () (list v)]
      [step1 (slist old new k1)
                  (apply-k k1 (cons (if (eqv? (car slist) old) new (car slist)) v))]
      [step3 (recur-car k2) 
             (apply-k k2 (cons recur-car v))]
      [step2 (slist old new k3)
             (slist-subst-cps (cdr slist) old new (step3 v k3))])))

(define slist-subst-cps
  (lambda (slist old new k)
    (cond [(null? slist) (apply-k k '())]
          [(symbol? (car slist))
           (slist-subst-cps (cdr slist) old new (step1 slist old new k))]
                   
          [else (slist-subst-cps (car slist) old new (step2 slist old new k))])))

