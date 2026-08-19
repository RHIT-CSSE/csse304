#lang racket
(require "chez-init.rkt")

(define slist-find
  (lambda (target slist k)
    (cond [(null? slist) (apply-k k #f)]
          [(symbol? (car slist))
           (if (eqv? (car slist) target)
               (apply-k k #t)
               (slist-find target (cdr slist) k))]
          [else 
           (slist-find target
                       (car slist)
                       (car-find target
                                 slist
                                 k))])))
(define-datatype continuation continuation?
  [init-k]
  [car-find (target symbol?)
            (slist list?)
            (k continuation?)])

(define apply-k
  (lambda (k v)
	(cases continuation k
          [car-find (target slist k)
                    (if v
                        (apply-k k #t)
                        (slist-find target (cdr slist) k))]
          [init-k () v]
          )))

