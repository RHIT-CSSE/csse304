#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "Exam2-202420.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)

              (combine-to-target equal?
                                 [(combine-to-target-cps '(1 2) '((1) (2)) '((2)) (init-k)) '(1) 1]
                                 [(combine-to-target-cps '(2 2) '((1) (2)) '((2))  (init-k)) '(2) 1]
                                 [(combine-to-target-cps '(2 1) '((1) (2)) '((2))  (init-k)) #f 1]
                                 [(combine-to-target-cps '(3 4 5 6) '((1) (2) (3)) '((4 5 6) (2))  (init-k)) '(3) 1]
                                 [(combine-to-target-cps '(3 4 5) '((1) (3 4) (2) (3)) '((4 5 6) (5) (2))  (init-k)) '(3 4) 1]
                                 [(combine-to-target-cps '(2 3 5) '((1) (3 4) (2) (3)) '((4 5 6) (5) (2))  (list-k)) '(#f) 1]
                                 [(combine-to-target-cps '(2 3 5) '((1) (3 4) (2) (3)) '((4 5 6) (5) (2) (3 5)) (list-k)) '((2)) 1]
                                 )
              
  (all-equal equal?
             [(all-equal 1 1 1 1) #t 1]
             [(all-equal #f #f #f) #t 1]
             [(all-equal 1 1 1 2) #f 1]
             [(all-equal (+ 1 1) (- 3 1) (car '(2 3))) #t 1]
             [(let ((x 1)
                    (y 2))
                (all-equal x x y)) #f 1]
             [(let ((x 1)
                    (y 1))
                (all-equal x x y)) #t 1]
             [(let ((x 1)
                    (y 2))
                (all-equal x x y (error "should not get here"))) #f 1]

             [(let* ((calls 0)
                    (retval (lambda (x) (set! calls (add1 calls)) x)))
                (list (all-equal (retval 2) (retval 2) (retval 2) (retval 2))
                      calls)) '(#t 4) 1]

             [(let* ((calls 0)
                    (retval (lambda (x) (set! calls (add1 calls)) x)))
                (list (all-equal (retval 1) (retval 2) (retval 2) (retval 3))
                      calls)) '(#f 2) 1]
             
             [(let* ((calls 0)
                    (retval (lambda (x) (set! calls (add1 calls)) x)))
                (list (all-equal (retval 1) (retval 1) (retval 2) (retval 3))
                      calls)) '(#f 3) 1]
             )
  (implicit-curry equal?
                  [(eval-one-exp '((lambda (x y) (list 'foo x y)) 2 3)) '(foo 2 3) 1]
                  [(eval-one-exp '(((lambda (x y) (list 'foo x y)) 2) 3)) '(foo 2 3) 1]
                  [(eval-one-exp '(((lambda (x y z) (list 'foo x y z)) 1 2) 3)) '(foo 1 2 3) 1]
                  [(eval-one-exp '(((lambda (x y z) (list 'foo x y z)) 1) 2 3)) '(foo 1 2 3) 1]
                  [(eval-one-exp '((((lambda (x y z) (list 'foo x y z)) 1) 2) 3)) '(foo 1 2 3) 1]
                  [(eval-one-exp '(let ((my-proc (let ((sym 'bar))
                                                   (lambda (x y z) (list sym x y z)))))
                                    ((my-proc 1) 2 3))) '(bar 1 2 3) 1]                        
                  [(eval-one-exp '(let ((my-add (lambda (x y) (+ x y))))
                                    (map (my-add 2) '(0 0 1 2)))) '(2 2 3 4) 1]
                  )
                  
  (num-cases equal?
                  [(eval-one-exp '(num-cases 3 (1 'a) (2 'b) (3 'c) (4 'd) (else 'f))) 'c 1]
                  [(eval-one-exp '(num-cases (+ 5 2) (1 'a) (7 'b) (3 'c) (4 'd) (else 'f))) 'b 1]
                  [(eval-one-exp '(num-cases 7 (1 'a) (else 'b))) 'b 1]
                  [(eval-one-exp '(num-cases (+ 3 8) (1 'a) (2 'b) (3 'c) (11 'd) (else 'f))) 'd 1]
                  [(eval-one-exp '(let ((y 1) (z 3)) (num-cases y (1 (+ y z)) (2 'b) (3 'c) (11 'd) (else 'f)))) 4 1]

                  [(eval-one-exp '(num-cases (+ 3 8) (1 (+ 2 3)) (2 (* 2 3)) (3 (- 11 3)) (11 (* 3 (let ([a 5]) (* a 4)))) (else 'f))) 60 1]
                  [(eval-one-exp '(num-cases ((lambda (x) x) 6) (1 (+ 2 3)) (2 (* 2 3)) (6 (- 11 3)) (11 (* 3 (let ([a 5]) (* a 4)))) (else 'f))) 8 1]
                  [(eval-one-exp '(let ([v (vector 0)])
                                    (num-cases (vector-set! v 0 (+ (vector-ref v 0) 1)) (1 v) (2 v) (3 v) (else v)))) '#(1) 1]

)
  

  ))

(implicit-run test) ; run tests as soon as this file is loaded
