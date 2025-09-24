#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "testcode-base.rkt")
(require "Exam1-202510.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
              (make-increasing equal? ; (run-test make-increasing)
                           [(make-increasing '(1 2 0 4)) '(1 2 4) 1]
                           [(make-increasing '(5 3 4 2 1)) '(5) 1]
                           [(make-increasing '(1 2 3 4)) '(1 2 3 4) 1]
                           [(make-increasing '(7 8 5 6 10)) '(7 8 10) 1]
                           [(make-increasing '(0 1 2 1 3 4)) '(0 1 2 3 4) 1]
                           )
              (expand-ranges equal? ; (run test expand-ranges)
                           [(expand-ranges '((1 3) (10 14))) '(1 2 3 10 11 12 13 14) 1]
                           [(expand-ranges '((5 7) (8 10))) '(5 6 7 8 9 10) 1]
                           [(expand-ranges '((1 1) (2 2))) '(1 2) 1]            ; Single element ranges
                           [(expand-ranges '((3 5) (6 8))) '(3 4 5 6 7 8) 1]   ; Consecutive ranges
                           [(expand-ranges '((0 0) (4 5))) '(0 4 5) 1]          ; Disjoint ranges
                           [(expand-ranges '()) '() 1])

              (adjustable-proc equal?
                          [(let* ((a+ (adjustable-proc +))
                                  (a- (adjustable-proc -))
                                  (add1 (a+ 'run 1 2))
                                  (ignored1 (a+ 'adjust 1))
                                  (add2 (a+ 'run 1 2))
                                  (sub1 (a- 'run 5 4))
                                  (ignored2 (a- 'adjust 100))
                                  (sub2 (a- 'run 11 1))
                                  (add3 (a+ 'run 1 2)))
                             (list add1 add2 sub1 sub2 add3))
                           '(3 4 1 110 4) 1]
                          [(let* ((mul (adjustable-proc *))
                                  (add (adjustable-proc +))
                                  (mult1 (mul 'run 2 3))          
                                  (ignored1 (mul 'adjust 4))      
                                  (mult2 (mul 'run 2 3))          
                                  (add1 (add 'run 3 4))           
                                  (ignored2 (add 'adjust 3))      
                                  (add2 (add 'run 3 4))           
                                  (mult3 (mul 'run 2 3)))         
                             (list mult1 mult2 add1 add2 mult3))
                           '(6 10 7 10 10) 1])
              (sneaky equal?
                      [(let* ((a+ (adjustable-proc +))
                              (ignored1 (a+ 'adjust 1))
                              (a+2 (make-sneaky a+)))
                         (a+2 10 10 10 10)) 41 1])
                         

              (expand-step equal?
                           [(expand-step '(A)) '(A A) 1]
                           [(expand-step '(B)) '(A (B) B) 1]
                           [(expand-step '((A) (B))) '((A A) (A (B) B)) 1]
                           
                           [(expand-step '(A A)) '(A A A A) 1]
                           [(expand-step '(B B)) '(A (B) B A (B) B) 1]
                           [(expand-step '(A B A)) '(A A A (B) B A A) 1]
                           [(expand-step '((A B) (A))) '((A A A (B) B) (A A)) 1]
                           [(expand-step '((B))) '((A (B) B)) 1]
                           [(expand-step '()) '() 1]
                           [(expand-step '(A (B A))) '(A A (A (B) B A A)) 1]
                           )
                             
              (numerical-recur equal?
                               [(let ((my-fac (numerical-recur 1 *)))
                                  (map my-fac '(1 2 3 4))) '(1 2 6 24) 1]
                               [(let ((my-even? (numerical-recur #t (lambda (n agg) (not agg)))))
                                  (map my-even? '(1 2 3 4 33 34))) '(#f #t #f #t #f #t) 1]
                               [(let ((sum-squares (numerical-recur 0 (lambda (n agg) (+ (* n n) agg)))))
                                  (map sum-squares '(0 1 2 3 6))) '(0 1 5 14 91) 1]
                               )
                                               

              ))

(implicit-run test) ; run tests as soon as this file is loaded
