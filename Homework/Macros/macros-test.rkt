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

  (my-let equal? ; (run-test my-let)
    [(my-let foo ((a 1)) a) 1 1] ; (run-test my-let 1)
    [(my-let foo ((bar 'sym) (baz 'sym)) (and (procedure? foo) (symbol? bar) (symbol? baz))) #t 1]
    [(my-let loop ((L (quote (1 2 3 4 5 6 7 8 9 10))) (A 0)) (if (null? L) A (loop (cdr L) (+ (car L) A)))) 55 1] ; (run-test my-let 2)
    [(my-let ((a 5)) (+ 3 (my-let fact ((n a)) (if (zero? n) 1 (* n (fact (- n 1))))))) 123 4] ; (run-test my-let 3)
    [((lambda (n) (my-let fact2 ((acc 1) (n n)) (if (zero? n) acc (fact2 (* n acc) (sub1 n))))) 4) 24 1]
    )

  (null-let equal?
            [(null-let (a b) (list a b)) '(() ()) 2]
            [(null-let (a b c) (set! a 7) (set! b 12) (list a b c)) '(7 12 ()) 2]
            [(null-let () 'foobar) 'foobar 2]
            [(null-let (z) (list z (let [(z 3)] z))) '(() 3) 2]
            [(let ((x 3) (y 4)) (null-let (x) (list x y))) '(() 4) 2])
  
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
            


  (ifelse equal?
          [(list (ifelse #t 1 else 2) (ifelse #f 1 else 2)) '(1 2) 6]
          [(let ((v #t)) (list (ifelse v v else 2) (ifelse (not v) 1 else 2))) '(#t 2) 6]
          [(let ((v #t)) (list (ifelse v (set! v 1) (set! v (add1 v)) v else 2 6)
                               (ifelse (not v) 1 2 else 3 4 5 6))) '(2 6) 8]
)
    (let-destruct equal? ; (run-test let-destruct)          
    [(let-destruct a (+ 1 10) (+ 1 a)) 12 0.1] ; (run-test let-destruct 1)
    [(let-destruct () '() 'youll-want-this-base-case) 'youll-want-this-base-case 0.1]
    [(let-destruct (a) (list 10) (+ 1 a)) 11 0.1]
    [(let-destruct (a b) (cons 1 (cons 2 '())) (cons a b)) '(1 . 2) 0.1]
    [(let-destruct ((a) b) '((1) 2) (cons a b)) '(1 . 2) 0.1]
    [(let-destruct (a b) '((1) ((2))) (cons a b)) '((1) . ((2))) 0.1]
    [(let-destruct ((a) ((b)) (((c)))) '((1) ((2)) (((3)))) (list a b c)) '(1 2 3) 0.1]
    [(let-destruct ((a b) c) '((1 2) 3) (list a b c)) '(1 2 3) 0.1]
    [(let-destruct ((a b) c) '((1 2) 3) (list a b c) 'body2) 'body2 0.1]
    [(let ((myval '((1 2) (3 4) (5 (6)))))
       (let-destruct ((a b) c (d (e))) myval (list a b c d e))) '(1 2 (3 4) 5 6) 0.1]
  )

              

  ))


(implicit-run test) ; run tests as soon as this file is loaded
