#lang racket

(require "chez-init.rkt")

(define leftmost-even
  (lambda (nlist) ; like an slist but for numbers
    (cond [(null? nlist) #f]
          [(number? (car nlist))
           (if (even? (car nlist))
               (car nlist)
               (leftmost-even (cdr nlist)))]
          [else
           (let ((car-result (leftmost-even (car nlist))))
             (if car-result
                 car-result
                 (leftmost-even (cdr nlist))))])))

(define-datatype continuation continuation?
  [init-k]
  [step1 (nlist list?) (k continuation?)])

(define apply-k
  (lambda (k v)
	(cases continuation k
          [init-k () v]
          [step1 (nlist k)
                 (let ((car-result v))
                   (if car-result
                       (apply-k k car-result)
                       (leftmost-even (cdr nlist) k)))]
          )))


(define leftmost-even-cps
  (lambda (nlist k) ; like an slist but for numbers
    (cond [(null? nlist) (apply-k k #f)]
          [(number? (car nlist))
           (if (even? (car nlist))
               (apply-k k (car nlist))
               (leftmost-even-cps (cdr nlist) k))]
          [else
           (leftmost-even-cps (car nlist) (step1 nlist k))])))

