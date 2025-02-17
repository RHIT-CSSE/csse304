#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "interpreter.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)

              
  (define equal?
    [(begin (top-level-eval '(define a 3)) (top-level-eval 'a)) 3 4]
    [(begin (top-level-eval '(define a 3))(top-level-eval '(define a 5))(top-level-eval 'a)) 5 4]
    [(begin (top-level-eval '(define fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))))
            (top-level-eval '(fac 1))) 1 4]
    [(begin (top-level-eval '(define fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))))
            (top-level-eval '(fac 5))) 120 5]    
    [(begin (top-level-eval '(define fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))))
            (top-level-eval '(fac 10))) 3628800 6] 
    [(begin (top-level-eval '(define fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))))
            (top-level-eval '(fac 100))) 93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000 7] 
   )

   (set! equal?
    [(begin (top-level-eval '(define a 3))
            (top-level-eval '(set! a 42))
            (top-level-eval 'a)) 42 6]
    [(begin (top-level-eval '(define a 3))
            (top-level-eval '(set! a 42))
            (top-level-eval '(set! a 88))
            (top-level-eval 'a)) 88 4]
    
    [(top-level-eval '((lambda (a b) (set! a 5) a) 2 3)) 5 5]
    [(top-level-eval '((lambda (a b) (lambda () (set! a 5)) a) 2 3)) 2 5]
    [(top-level-eval '((lambda (a b) ((lambda (c d) (set! a 5)) 6 7) a) 2 3)) 5 5]
    [(top-level-eval '((lambda (a b) ((lambda (c d) c) ((lambda () (set! a 5) 6)) 7) a) 5 3)) 5 5]
   )
     (letrec equal?
       [(top-level-eval '(letrec ([a 3]) a)) 3 2]
       [(top-level-eval '(letrec ([a 3][b 4]) b)) 4 2]
       [(top-level-eval '(letrec ([a 3][b (letrec ([c 7]) c)]) b)) 7 2]
       [(top-level-eval '(letrec ([a 3][b 8]) (letrec ([c (+ a b)]) c))) 11 2]
       [(top-level-eval '(letrec ([fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))]) (fac 1))) 1 3]
       [(top-level-eval '((letrec ([fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))]) fac) 1)) 1 3]
       [(top-level-eval '(letrec ([fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))]) (fac 5))) 120 3]
       [(top-level-eval '(letrec ([fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))]) (fac 10))) 3628800 7]
       [(top-level-eval '(letrec ([fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))]) (fac 100))) 93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000 7]
       [(top-level-eval '(letrec ([fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))]) (letrec ([fac2 fac]) (fac2 5)))) 120 3]
       [(top-level-eval '((letrec ([odd (lambda (n) (if (= n 0) #f (even (- n 1))))] [even (lambda (n) (if (= n 0) #t (odd (- n 1))))]) odd) 5)) #t 3]
       [(top-level-eval '((letrec ([odd (lambda (n) (if (= n 0) #f (even (- n 1))))] [even (lambda (n) (if (= n 0) #t (odd (- n 1))))]) odd) 6)) #f 3]
       )

  
))

(implicit-run test) ; run tests as soon as this file is loaded
