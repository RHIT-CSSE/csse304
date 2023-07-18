#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "testcode-base.rkt")
(require "macros-solution.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)

  (my-let equal? ; (run-test my-let)
    [(my-let foo ((a 1)) a) 1 1] ; (run-test my-let 1)
    [(my-let foo ((bar 'sym) (baz 'sym)) (and (procedure? foo) (symbol? bar) (symbol? baz))) #t 1]
    [(my-let loop ((L (quote (1 2 3 4 5 6 7 8 9 10))) (A 0)) (if (null? L) A (loop (cdr L) (+ (car L) A)))) 55 1] ; (run-test my-let 2)
    [(my-let ((a 5)) (+ 3 (my-let fact ((n a)) (if (zero? n) 1 (* n (fact (- n 1))))))) 123 4] ; (run-test my-let 3)
    [((lambda (n) (my-let fact2 ((acc 1) (n n)) (if (zero? n) acc (fact2 (* n acc) (sub1 n))))) 4) 24 1]
    )

   (my-or equal? ; (run-test my-or)
    [(begin (define a #f) (my-or #f (begin (set! a (not a)) a) #f)) #t 1] ; (run-test my-or 1)
    [(let loop ((L (quote (a b 2 5 #f (a b c) #(2 s c) foo a))) (A (quote ()))) (if (null? L) A (loop (cdr L) (if (my-or (number? (car L)) (vector? (car L)) (char? (car L))) (cons (car L) A) A)))) '(#(2 s c) 5 2) 1] ; (run-test my-or 2)
    [(let loop ((L (quote (1 2 3 4 5 a 6)))) (if (null? L) #f (my-or (symbol? (car L)) (loop (cdr L))))) #t 1] ; (run-test my-or 3)
    [(my-or) #f 2] ; (run-test my-or 4)
    [(let ((x 0)) (if (my-or #f 4 (begin (set! x 12) #t)) (set! x (+ x 1)) (set! x (+ x 3))) x) 1 2] ; (run-test my-or 5)
    [(my-or #f 4 3) 4 1] ; (run-test my-or 6)
    [(let ((x 0)) (my-or (begin (set! x (+ 1 x)) x) #f)) 1 2] ; (run-test my-or 7)
    [(my-or 6) 6 2] ; (run-test my-or 8)
  ) 
  
  (range-cases equal? ; (run-test range-cases)
    [(let ((passed (lambda(x) (range-cases x (< 65 'fail) (else 'pass)))))
       (map passed '(50 65 66))) '(fail pass pass) 6]
    [(let* ((score-increment 10)
            (adjustment (lambda(x) (range-cases x
                                              (< score-increment 0)
                                              (< (* 2 score-increment) (/ x 2))
                                              (else x))))) 
       (map adjustment '(5 16 25))) '(0 8 25) 8]
    [(with-handlers ([symbol? (lambda (s) s)] )
       (letrec ((getvalue (lambda ()
                            (set! getvalue (lambda () (raise 'dont-call-me-twice)))
                            3)))
         (range-cases (getvalue)
                      (< 1 'tiny)
                      (< 2 'small)
                      (< 3 'medium)
                      (< 4 'large)
                      (else 'huge)))) 'large 6]
    )
            
  (let-destruct equal? ; (run-test let-destruct)          
    [(let-destruct a (+ 1 10) (+ 1 a)) 12 2] ; (run-test let-destruct 1)
    [(let-destruct () '() 'youll-want-this-base-case) 'youll-want-this-base-case 2]
    [(let-destruct (a) (list 10) (+ 1 a)) 11 2]
    [(let-destruct (a b) (cons 1 (cons 2 '())) (cons a b)) '(1 . 2) 2]
    [(let-destruct ((a) b) '((1) 2) (cons a b)) '(1 . 2) 2]
    [(let-destruct (a b) '((1) ((2))) (cons a b)) '((1) . ((2))) 2]
    [(let-destruct ((a) ((b)) (((c)))) '((1) ((2)) (((3)))) (list a b c)) '(1 2 3) 2]
    [(let-destruct ((a b) c) '((1 2) 3) (list a b c)) '(1 2 3) 2]
    [(let-destruct ((a b) c) '((1 2) 3) (list a b c) 'body2) 'body2 2]
    [(let ((myval '((1 2) (3 4) (5 (6)))))
       (let-destruct ((a b) c (d (e))) myval (list a b c d e))) '(1 2 (3 4) 5 6) 2]
  )

  (ifelse equal?
          [(list (ifelse #t 1 else 2) (ifelse #f 1 else 2)) '(1 2) 6]
          [(let ((v #t)) (list (ifelse v v else 2) (ifelse (not v) 1 else 2))) '(#t 2) 6]
          [(let ((v #t)) (list (ifelse v (set! v 1) (set! v (add1 v)) v else 2 6)
                               (ifelse (not v) 1 2 else 3 4 5 6))) '(2 6) 8]
)
  (objects equal?
           [(begin
              (define-object point x y)

              (define-method point point.getx
                () x)

              (define-method point point.manhat_dist (ox oy)
                (+ (abs (- x ox)) (abs (- y oy))))
              
              (list (point.getx '(33 44))
                    (point.manhat_dist '(1 2) 0 -1))) '(33 4) 1]) 
              

  ))


(implicit-run test) ; run tests as soon as this file is loaded
