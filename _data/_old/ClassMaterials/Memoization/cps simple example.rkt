#lang racket

(define double-list
  (lambda (lst)
    (if (null? lst)
        '()
        (cons (* 2 (car lst)) (double-list (cdr lst))))))

(define double-example
  (lambda (ex1 ex2)
    (display "doubled first list: ")
    (display (double-list ex1))
    (newline)
    (display "doubled second list: ")
    (display (double-list ex2))
    'done
    ))

(double-example '(1 2 3) '(4 5 6))

(define apply-k
  (lambda (k v)
    (k v)))

(define make-k    ; lambda is the "real" continuation 
  (lambda (v) v)) ; constructor here.

(define double-list-cps
  (lambda (lst k)
    (if (null? lst)
        (apply-k k '())
        (double-list-cps (cdr lst) (make-k (lambda (doubled-cdr)
                                         (apply-k k (cons (* 2 (car lst)) doubled-cdr))))))))
         

(define double-example-cps
  (lambda (ex1 ex2 k)
    (display "doubled first list: ")
    (double-list-cps ex1 (make-k (lambda (doubled-ex1)
                                   (display doubled-ex1)
                                   (newline)
                                   (display "doubled second list: ")
                                   (double-list-cps ex2 (make-k (lambda (doubled-ex2)
                                                                  
                                                                  (display doubled-ex2)
                                                                  (apply-k k 'done)))))))))
    
