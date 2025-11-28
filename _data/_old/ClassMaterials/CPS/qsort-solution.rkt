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
  [step1 (pivot number?) (k continuation?)]
  [step2 (split-lst list?) (pivot number?) (k continuation?)]
  [step3 (sorted-less list?) (pivot number?) (k continuation?)]
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
      [init-k () v]
      [step1 (pivot k)
             (let* ((split-lst v))
                    (qsort-cps (car split-lst) (step2 split-lst pivot k)))]
      [step2 (split-lst pivot k)
             (let* ((sorted-less v))
               (qsort-cps (cdr split-lst) (step3 sorted-less pivot k)))]
      [step3 (sorted-less pivot k)
             (let* ((sorted-more v))
               (apply-k k (append sorted-less (list pivot) sorted-more)))]

      )))

(define divide-cps
  (lambda (pivot lst less eqOrMore k)
    (if (null? lst)
        (apply-k k (cons less eqOrMore))
        (if (< (car lst) pivot)
            (divide-cps pivot (cdr lst) (cons (car lst) less) eqOrMore k)
            (divide-cps pivot (cdr lst) less (cons (car lst) eqOrMore) k)))))

(define qsort-cps
  (lambda (lst k)
    (if (null? lst) (apply-k k '())
        (let* ((pivot (car lst)))
               (divide-cps pivot (cdr lst) '() '() (step1 pivot k))))))
  
(trace divide-cps apply-k qsort-cps)                    