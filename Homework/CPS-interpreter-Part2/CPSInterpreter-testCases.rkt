#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "testcode-base.rkt")
(require "interpreter.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)

     (letrec equal?
       [(eval-one-exp '(letrec ([a 3]) a)) 3 1]
       [(eval-one-exp '(letrec ([a 3][b 4]) b)) 4 1]
       [(eval-one-exp '(letrec ([a 3][b (letrec ([c 7]) c)]) b)) 7 2]
       [(eval-one-exp '(letrec ([a 3][b 8]) (letrec ([c (+ a b)]) c))) 11 2]
       [(eval-one-exp '(letrec ([fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))]) (fac 1))) 1 2]
       [(eval-one-exp '((letrec ([fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))]) fac) 1)) 1 2]
       [(eval-one-exp '(letrec ([fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))]) (fac 5))) 120 2]
       [(eval-one-exp '(letrec ([fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))]) (fac 100))) 93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000 2]
       [(eval-one-exp '(letrec ([fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))]) (letrec ([fac2 fac]) (fac2 5)))) 120 2]
       [(eval-one-exp '((letrec ([odd (lambda (n) (if (= n 0) #f (even (- n 1))))] [even (lambda (n) (if (= n 0) #t (odd (- n 1))))]) odd) 5)) #t 2]
       [(eval-one-exp '((letrec ([odd (lambda (n) (if (= n 0) #f (even (- n 1))))] [even (lambda (n) (if (= n 0) #t (odd (- n 1))))]) odd) 6)) #f 2]
       )

   (call/cc equal?
       [(eval-one-exp '(+ 3 (call/cc (lambda (k) (k 8))) 7)) 18 2]
       [(eval-one-exp '(+ 3 (call/cc (lambda (k) (+ 4 (k 5) 6))) 8)) 16 2]
       [(eval-one-exp '(+ 3 (call/cc (lambda (k) (+ 4 (call/cc (lambda (c) (+ 5 (k 42) (c 6))))))) 8)) 53 2]
       [(begin (eval-one-exp '(define state #f))
               (eval-one-exp '(define fac (lambda (n)
                                              (if (= n 0)
                                                  ((lambda () (call/cc (lambda (k) (set! state k))) 1))
                                                  (* n (fac (- n 1)))))))
               (eval-one-exp '(fac 5))
               (eval-one-exp '(state 1))) 120 6]
       [(eval-one-exp '(let ([x (call/cc (lambda (k) k))])
                           (x (lambda (ignore) 7)))) 7 4]
       [(eval-one-exp '(((call/cc (lambda (k) k)) (lambda (x) x)) 7)) 7 4]
       )


  (while equal?
       [(eval-one-exp '(while #f 3)) '(void) 2]
       [(eval-one-exp '(let ([c 1]) (begin (while (< c 10) (set! c (+ c 1))) c))) 10 4]
       [(eval-one-exp '(let ([c 1]) (let ([d (begin (while (< c 10) (set! c (+ c 1))) c)])
                                        (begin (while (< d 20) (set! d (+ d 1))) d)))) 20 4]
           
       )

  ;; try-catch to come
))

(implicit-run test) ; run tests as soon as this file is loaded
