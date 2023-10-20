#lang racket

(require "chez-init.rkt")
(require racket/trace)

; prepend to all takes value and a list of lists
; and returns a new list of lists with the value
; prepended to all

; (prepend-to-all 0 '((1 2) (3))) -> '((0 1 2) (0 3))

(define prepend-to-all
  (lambda (val lst)
    (if (null? lst)
        lst
        (cons (cons val (car lst))
              (prepend-to-all val (cdr lst))))))


; TODO - convert prepend-to-all to tail form function

(define prepend-to-all-tail
  (lambda (val lst acc)
    (if (null? lst)
        (reverse acc)
        (prepend-to-all-tail
         val
         (cdr lst)
         (cons (cons val (car lst)) acc)))))

; IN CLASS LIVE EXERCISE - convert powerset to tail form function

(define powerset
  (lambda (lst)
    (if (null? lst)
        '(())
        (let* ((sub-powerset (powerset (cdr lst)))
               (sub-powerset-with-car (prepend-to-all-tail (car lst) sub-powerset '())))
          (append sub-powerset sub-powerset-with-car)))))

; we'll need these

(define-datatype continuation continuation?
  [init-k]
  [step1 (lst list?) (k continuation?)]
  [step2 (sub-powerset list?) (k continuation?)]
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
      [step1 (lst k)
             (let* ((sub-powerset v))
               (prepend-to-all-cps (car lst) sub-powerset '() (step2 sub-powerset k)))]                    
      [step2 (sub-powerset k)
             (apply-k k (append sub-powerset v))]
      [init-k () v])))

(define prepend-to-all-cps
  (lambda (val lst acc k)
    (if (null? lst)
        (apply-k k (reverse acc))
        (prepend-to-all-cps
         val
         (cdr lst)
         (cons (cons val (car lst)) acc)
         k))))

(define powerset-cps
  (lambda (lst k)
    (if (null? lst)
        (apply-k k '(()))
        (powerset-cps (cdr lst) (step1 lst k)))))
        
  
(trace powerset-cps apply-k prepend-to-all-cps)               