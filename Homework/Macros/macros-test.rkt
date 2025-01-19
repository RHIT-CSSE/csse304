#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "macros.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)

;; init
  
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
                (all-equal x x y (error "should not get here"))) #f 2]

             [(let* ((calls 0)
                    (retval (lambda (x) (set! calls (add1 calls)) x)))
                (list (all-equal (retval 2) (retval 2) (retval 2) (retval 2))
                      calls)) '(#t 4) 2]

             [(let* ((calls 0)
                    (retval (lambda (x) (set! calls (add1 calls)) x)))
                (list (all-equal (retval 1) (retval 2) (retval 2) (retval 3))
                      calls)) '(#f 2) 1]
             
             [(let* ((calls 0)
                    (retval (lambda (x) (set! calls (add1 calls)) x)))
                (list (all-equal (retval 1) (retval 1) (retval 2) (retval 3))
                      calls)) '(#f 3) 1]
             )

  (begin-unless equal?
                [(let ((a 0) (b #f))
                   (list (begin-unless b
                                       (set! a (+ 1 a))
                                       (set! a (+ 1 a))                           
                                       (set! b 99)
                                       (set! a (+ 1 a)))
                         a))

                 '(99 2) 2]
                [(let ((a 0) (b #t))
                   (list (begin-unless b
                                       (set! a (+ 1 a))
                                       (set! a (+ 1 a))                           
                                       (set! b 99)
                                       (set! a (+ 1 a)))
                         a))

                 '(#t 0) 2]
                [(let ((a 0) (b #f))
                   (list (begin-unless b
                                       (set! a (+ 1 a))
                                       (set! a (+ 1 a))                           
                                       (set! a (+ 1 a)))
                         a))

                   '(#f 3) 2]
                [(let ((a 0) (foo #f) (bar #f))
                   (list (begin-unless foo
                                       (set! a (+ 1 a))
                                       (begin-unless bar
                                                     (set! a (+ 1 a))
                                                     (set! bar #t)
                                                     (set! a (+ 1 a)))
                                       (set! a (+ 1 a))
                                       (set! a (+ 1 a))
                                       (set! foo 'qqq)                                       
                                       (set! a (+ 1 a)))
                         a))

                 '(qqq 4) 2]
                                [(let ((a 0) (foo #f) (bar #f))
                                   (list (begin-unless foo
                                                       (set! a (+ 1 a))
                                                       (begin-unless bar
                                                                     (set! a (+ 1 a))
                                                                     (set! foo #t)
                                                                     (set! a (+ 1 a)))
                                                       (set! a (+ 1 a))
                                                       (set! a (+ 1 a))
                                                       (set! foo 'qqq)                                       
                                                       (set! a (+ 1 a)))
                         a))

                   '(#t 3) 2]



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

;; for loop

              

  ))


(implicit-run test) ; run tests as soon as this file is loaded
