#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "Exam2-202220.rkt")
(provide get-weights get-names individual-test test)

(require racket/trace)



(define test (make-test ; (r)
  
  (combine-consec-cps equal? ; (run-test combine-consec)
                 [(combine-consec '(1 5)) '((1 1) (5 5)) 1] ; (run-test combine-consec 1)
                 [(combine-consec '(1 2 3 4 5)) '((1 5)) 1] ; (run-test combine-consec 2)
                 [(combine-consec '(1 2 3 4 5 7 8 9)) '((1 5) (7 9)) 1] ; (run-test combine-consec 3)
                 [(combine-consec '(1 2 4 7 8 9 20)) '((1 2) (4 4) (7 9) (20 20)) 1] ; (run-test combine-consec 4)
                 [(combine-consec '()) '() 1] ; (run-test combine-consec 5)
                 ; this one test calls the helper with a non-identity continuation
                 [(combine-consec-helper-cps 1 1 '(3 4) reverse) '((3 4) (1 1)) 1] ; (run-test combine-consec 6)
                  )
  (or= equal? ; (run-test or=)
                 [(or= 1 3 2 1) #t 1] ; (run-test or= 1)
                 [(or= 0 3 2 1) #f 1] ; (run-test or= 2)
                 [(let ((x 1) (y 2)) (or= (+ 1 2) y x (+ x y))) #t 1] ; (run-test or= 3)
                 [(let ((x 1) (y 2)) (or= (* y y) y x (+ x y))) #f 1] ; (run-test or= 4)
                 [(let ((x 1)) (or= 1 1 (set! x 2)) x) 1 1] ; (run-test or= 5)
                 [(let ((x 1)) (or= 1 2 3 4 (set! x 2)) x) 2 1] ; (run-test or= 6)
                  )
  (myforeach equal? ; (run-test myforeach)
             [(eval-one-exp '(myforeach x (list 1 2) (+ x 10))) '(11 12) 1] ; (run-test myforeach 1)
             [(eval-one-exp '(myforeach qqq (list 1 2 3) (list qqq))) '((1) (2) (3)) 1] ; (run-test myforeach 3)             
             [(eval-one-exp '(myforeach qqq '() (list qqq))) '() 1] ; (run-test myforeach 3)
             [(eval-one-exp '(let ((x '(1 2 3)) (y 4)) (myforeach z x (+ z y)))) '(5 6 7) 1] ; (run-test myforeach 3)
             )
  (outer equal? ; (run-test outer)
         ; this just ensures you didn't break basic vars
         [(eval-one-exp '(let ((x 1)) (let ((x 2)) x))) 2 1] ; (run-test outer 1)
         ; on to the real tests
         [(eval-one-exp '(let ((x 1)) (let ((x 2)) (outer x)))) 1 1] ; (run-test outer 2)
         [(eval-one-exp '(let ((x 1)) (let ((x 2)) (let ((x 3)) (outer x))))) 2 1] ; (run-test outer 3)
         [(eval-one-exp '(let ((x 1)) (let ((x 2)) (let ((x 3)) (outer outer x))))) 1 1] ; (run-test outer 4)
         [(eval-one-exp '(let ((x 1)) (let ((x 2)) (let ((y 3)) (outer x))))) 1 1] ; (run-test outer 5)
         [(eval-one-exp '(let ((x 1)) (let ((y 2)) (let ((x 3)) (outer x))))) 1 1] ; (run-test outer 6)
         [(eval-one-exp '(let ((x 1)) (let ((x 2)) (let ((x 3)) (let ((x 4)) (outer outer x)))))) 2 1] ; (run-test outer 7)
         [(eval-one-exp '(let ((x 1)) (let ((x 2)) (let ((x 3)) (let ((x 4)) (outer outer outer x)))))) 1 1] ; (run-test outer 8) 
         [(eval-one-exp '((let ((x 1)) (lambda (x) (outer x))) 99)) 1 1]
         [(eval-one-exp '(let ((+ *)) ((outer +) 1 5))) 6 1]
         )
    
))

(implicit-run test) ; run tests as soon as this file is loaded
