#lang racket

(require "chez-init.rkt")
(require racket/trace)

(define prepend-to-all
  (lambda (val lst)
    (if (null? lst)
        lst
        (cons (cons val (car lst))
              (prepend-to-all val (cdr lst))))))

(define prepend-to-all-tail
  (lambda (val lst acc)
    (if (null? lst)
        (reverse acc)
        (prepend-to-all-tail
         val
         (cdr lst)
         (cons (cons val (car lst)) acc)))))
        
(define powerset
  (lambda (lst)
    (if (null? lst)
        '(())
        (let* ((sub-powerset (powerset (cdr lst)))
               (sub-powerset-with-car (prepend-to-all (car lst)
                                                      sub-powerset)))
          (append sub-powerset sub-powerset-with-car)))))

;(define-datatype continuation continuation?
;  [init-k]
;  )
;
;(define apply-k
;  (lambda (k v)
;    (cases continuation k
;      [init-k () v])))

(define-datatype continuation continuation?
  [init-k]
  [step2 (lst-car number?) (k continuation?)]
  [step3 (sub-powerset list?) (k continuation?)]
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
      [init-k () v]
      [step2 (lst-car k)
             (prepend-to-all-cps lst-car
                                 v
                                 '()
                                 (step3 v k))]
      [step3 (sub-powerset k)
             (apply-k k (append sub-powerset v))]
      
      )))

(define prepend-to-all-cps
  (lambda (val lst acc k)
    (if (null? lst)
        (apply-k k (reverse acc))
        (prepend-to-all-cps
         val
         (cdr lst)
         (cons (cons val (car lst)) acc) k))))

(define powerset-cps
  (lambda (lst k)
    (if (null? lst)
        (apply-k k '(()))
        (powerset-cps (cdr lst) (step2 (car lst) k)))))

(trace powerset-cps apply-k prepend-to-all-cps)               