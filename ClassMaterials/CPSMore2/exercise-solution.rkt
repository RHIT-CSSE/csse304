#lang racket

(require "chez-init.rkt")

(define flatten
  (lambda (lst)
    (if (null? lst)
        '()
        (let ((flat-cdr (flatten (cdr lst))))
          (if (list? (car lst))
              (append (flatten (car lst)) flat-cdr)
              (cons (car lst) flat-cdr))))))

(define-datatype continuation continuation?
  [init-k]
  [flatten-cdr-k
   (ls list?)
   (k continuation?)]
  [flatten-car-k
   (flattened-cdr list?)
   (k continuation?)]   
  )

(define flatten-cps
  (lambda (ls k)
    (if (null? ls)
	(apply-k k ls)
	(flatten-cps (cdr ls) (flatten-cdr-k ls k)))))


(define apply-k
  (lambda (k v)
	(cases continuation k
          [init-k () v]
          [flatten-cdr-k (ls k)
                         (if (list? (car ls))
                             (flatten-cps (car ls) (flatten-car-k v k))
                             (apply-k k (cons (car ls) v)))]
          [flatten-car-k (flattened-cdr k)
                         (apply-k k (append v flattened-cdr))]
          )))