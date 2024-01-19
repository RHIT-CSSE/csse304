#lang racket

(require "chez-init.rkt")
(require racket/trace)


(define divide
  (lambda (pivot lst less eqOrMore)
    (if (null? lst)
        (cons less eqOrMore)
        (if (< (car lst) pivot)
            (divide pivot (cdr lst) (cons (car lst) less) eqOrMore)
            (divide pivot (cdr lst) less (cons (car lst) eqOrMore))))))

(define qsort
  (lambda (lst)
    (if (null? lst) '()
        (let* ((pivot (car lst))
               (split-lst (divide pivot (cdr lst) '() '()))
               (sorted-less (qsort (car split-lst)))
               (sorted-more (qsort (cdr split-lst))))
          (append sorted-less (list pivot) sorted-more)))))
           
; we'll need these

(define-datatype continuation continuation?
  [init-k]
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
      [init-k () v])))

(define divide-cps
  (lambda (val lst acc k)
    'nyi))

(define qsort-cps
  (lambda (lst k)
    'nyi))
  
(trace divide-cps apply-k qsort-cps)                    