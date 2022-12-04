#lang racket

(require "../chez-init.rkt")
(provide qsort-imp)

;; IMPERATIVE FORM QUESTION - 10 points

;; So here I have an implementation of the classic quick sort sorting algorithm.
;;
;; I have included both the original version and a version converted to datatype
;; style cps.

(define qsort-helper
  (lambda (in pivot less more)
    (if (null? in)
        (append (qsort less) (list pivot) (qsort more))
        (if (< (car in) pivot)
            (qsort-helper (cdr in) pivot (cons (car in) less) more)
            (qsort-helper (cdr in) pivot less (cons (car in) more))))))

(define qsort
  (lambda (lst)
    (if (null? lst)
        lst
        (qsort-helper (cdr lst) (car lst) '() '()))))


(define-datatype continuation continuation?
  [init-k]
  [qsort-more-k (pivot number?) (sorted-less list?) (k continuation?)]
  [qsort-less-k (pivot number?) (more list?) (k continuation?)]

  )
  
(define apply-k
  (lambda (k v)
    (cases continuation k
      [qsort-less-k (pivot more k)
                    (qsort-cps more (qsort-more-k pivot v k))]
      [qsort-more-k (pivot sorted-less k)
                    (apply-k k (append sorted-less (list pivot) v))]
      [init-k () v])))
  
(define qsort-cps
  (lambda (lst k)
    (if (null? lst)
        (apply-k k lst)
        (qsort-helper-cps (cdr lst) (car lst) '() '() k))))
  
(define qsort-helper-cps
  (lambda (in pivot less more k)
    (if (null? in)
        (qsort-cps less (qsort-less-k pivot more k))
        (if (< (car in) pivot)
            (qsort-helper-cps (cdr in) pivot (cons (car in) less) more k)
            (qsort-helper-cps (cdr in) pivot less (cons (car in) more) k)))))


;; add more globals as you need

(define k 'bad)
(define lst 'bad)

;; Convert this implementation to imperative form.  You can either
;; edit the cps code directly above or copy that code to new functions.
;;
;; Either way, modify the non-cps/imperative function below to call your
;; new imperative code appropiately

(define qsort-imp
  (lambda (lst2)
    (set! lst lst2)
    (set! k (init-k))
    (qsort-imp2)))


(define apply-k-imp2
  (lambda () ; (k2 v)
    (cases continuation k
      [qsort-less-k (pivot more k1)
                    (set! lst more)
                    (set! k (qsort-more-k pivot v k1))
                    (qsort-imp2)]
      [qsort-more-k (pivot sorted-less k1)
                    (set! v (append sorted-less (list pivot) v))
                    (set! k k1)
                    (apply-k-imp2)]
      [init-k () v])))
  
(define qsort-imp2
  (lambda () ; (lst k)
    (if (null? lst)
        (begin
          (set! v lst)
          (apply-k-imp2))
        (begin
          (set! in (cdr lst))
          (set! pivot (car lst))
          (set! less '())
          (set! more '())
          (qsort-helper-imp2)))))
  
(define qsort-helper-imp2
  (lambda () ; (in pivot less more k1)
    (if (null? in)
        (begin
          (set! lst less)
          (set! k (qsort-less-k pivot more k))
          (qsort-imp2))
        (if (< (car in) pivot)
            (begin
              (set! less (cons (car in) less))
              (set! in (cdr in))
              (qsort-helper-imp2))
            (begin
              (set! more (cons (car in) more))
              (set! in (cdr in))
              (qsort-helper-imp2))))))