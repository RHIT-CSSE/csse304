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
  (set!-local-variables equal? ; (run-test set!-local-variables)
    [(eval-one-exp '(let ((f #f) (x 3)) (set! f (lambda (n) (+ 3 (* n 10)))) (set! x 7) (f x))) 73 5] ; (run-test set!-local-variables 1)
    [(eval-one-exp '((lambda (x) (set! x (+ x 1)) (+ x 2)) 90)) 93 5] ; (run-test set!-local-variables 2)
    [(eval-one-exp '(let ((x 5) (y 3)) (let ((z (begin (set! x (+ x y)) x))) (+ z (+ x y))))) 19 5] ; (run-test set!-local-variables 3)
    [(eval-one-exp '(let ((a 5)) (if (not (= a 6)) (begin (set! a (+ 1 a)) (set! a (+ 1 a))) 3) (+ 1 a))) 8 6] ; (run-test set!-local-variables 4)
    [(eval-one-exp '(let ((f #f)) (let ((dummy (begin (set! f (lambda (n) (+ 3 (* n 10)))) 3))) (f 4)))) 43 6] ; (run-test set!-local-variables 5)
  )

  (simple-defines equal? ; (run-test simple-defines)
    [(eval-one-exp '(begin (define a 5) (+ a 3))) 8 5] ; (run-test simple-defines 1)
    [(eval-one-exp '(begin (define c 5) (define d (+ c 2)) (+ d (add1 c)))) 13 6] ; (run-test simple-defines 2)
    [(eval-one-exp '(begin (define e 5) (let ((f (+ e 2))) (set! e (+ e f)) (set! f (* 2 f)) (list e f)))) '(12 14) 6] ; (run-test simple-defines 3)
    [(eval-one-exp '(begin (define ff (letrec ((ff (lambda (x) (if (= x 1) 2 (+ (* 2 x) (ff (- x 2))))))) ff)) (ff 7))) 32 6] ; (run-test simple-defines 4)
    [(begin (eval-one-exp '(define cons +)) (eval-one-exp '(cons 2 3))) 5 4] ; (run-test simple-defines 5)
    [(eval-one-exp '(begin (define double-fact (lambda (x) (fact (* 2 x)))) (define fact (lambda (x) (if (zero? x) 1 (* x (fact (sub1 x)))))) (double-fact 4))) 40320 12] ; (run-test simple-defines 6)
  )

  (letrec-and-define equal? ; (run-test letrec-and-define)
    [(begin (reset-global-env) (eval-one-exp '(letrec ((f (lambda (n) (if (= n 0) 0 (+ n (f (sub1 n))))))) (f 10)))) 55 6] ; (run-test letrec-and-define 1)
    [(eval-one-exp '(letrec ((f (lambda (n) (if (zero? n) 0 (+ 4 (g (sub1 n)))))) (g (lambda (n) (if (zero? n) 0 (+ 3 (f (sub1 n))))))) (f (g (f 5))))) 221 6] ; (run-test letrec-and-define 2)
    [(begin (reset-global-env) (eval-one-exp '(define zer0? (lambda (x) (= x 0)))) (eval-one-exp '(letrec ([f (lambda (n) (if (zer0? n) 0 (+ n (f (sub1 n)))))]) (f 10)))) 55 7] ; (run-test letrec-and-define 3)
  )

  (named-let-and-define equal? ; (run-test named-let-and-define)
    [(eval-one-exp '(begin (define fact (lambda (n) (let loop ((n n) (m 1)) (if (= n 0) m (loop (- n 1) (* m n)))))) (fact 5))) 120 8] ; (run-test named-let-and-define 1)
    [(eval-one-exp '(let fact ((n 5) (m 1)) (if (= n 0) m (fact (- n 1) (* m n))))) 120 8] ; (run-test named-let-and-define 2)
    [(begin (reset-global-env) (eval-one-exp '(define rotate-linear (letrec ((reverse (lambda (lyst revlist) (if (null? lyst) revlist (reverse (cdr lyst) (cons (car lyst) revlist)))))) (lambda (los) (let loop ((los los) (sofar '())) (cond ((null? los) los) ((null? (cdr los)) (cons (car los) (reverse sofar '()))) (else (loop (cdr los) (cons (car los) sofar))))))))) (eval-one-exp '(rotate-linear '(1 2 3 4 5 6 7 8)))) '(8 1 2 3 4 5 6 7) 9] ; (run-test named-let-and-define 3)
    [(begin (reset-global-env) (eval-one-exp '(define fib-memo (let ((max 2) (sofar '((1 . 1) (0 . 1)))) (lambda (n) (if (< n max) (cdr (assq n sofar)) (let* ((v1 (fib-memo (- n 1))) (v2 (fib-memo (- n 2))) (v3 (+ v2 v1))) (set! max (+ n 1)) (set! sofar (cons (cons n v3) sofar)) v3)))))) (eval-one-exp '(fib-memo 15))) 987 9] ; (run-test named-let-and-define 4)
    [(begin (reset-global-env) (eval-one-exp '(define f1 (lambda (x) (f2 (+ x 1))))) (eval-one-exp '(define f2 (lambda (x) (* x x)))) (eval-one-exp '(f1 3))) 16 7] ; (run-test named-let-and-define 5)
    [(begin (reset-global-env) (eval-one-exp '(define ns-list-recur (lambda (seed item-proc list-proc) (letrec ((helper (lambda (ls) (if (null? ls) seed (let ((c (car ls))) (if (or (pair? c) (null? c)) (list-proc (helper c) (helper (cdr ls))) (item-proc c (helper (cdr ls))))))))) helper)))) (eval-one-exp '(define append (lambda (s t) (if (null? s) t (cons (car s) (append (cdr s) t)))))) (eval-one-exp '(define reverse* (let ((snoc (lambda (x y) (append y (list x))))) (ns-list-recur '() snoc snoc)))) (eval-one-exp '(reverse* '(1 (2 3) (((4))) () 5)))) '(5 () (((4))) (3 2) 1) 10] ; (run-test named-let-and-define 6)
  )

  (set!-global-variables equal? ; (run-test set!-global-variables)
    [(begin (reset-global-env) (eval-one-exp '(define a 3)) (eval-one-exp '(set! a 7)) (eval-one-exp 'a)) 7 7] ; (run-test set!-global-variables 1)
    [(begin (reset-global-env) (eval-one-exp '(define a 3)) (eval-one-exp '(define f '())) (eval-one-exp '(set! f (lambda (x) (+ x 1)))) (eval-one-exp '(f a))) 4 7] ; (run-test set!-global-variables 2)
    [(begin (reset-global-env) (eval-one-exp '(define a 5)) (eval-one-exp '(define f '())) (eval-one-exp '(set! f (lambda (x) (if (= x 0) 1 (* x (f (- x 1))))))) (eval-one-exp '(f a))) 120 7] ; (run-test set!-global-variables 3)
    [(begin (reset-global-env) (eval-one-exp '(define a 5)) (eval-one-exp '(let ((b 7)) (set! a 9))) (eval-one-exp 'a)) 9 7] ; (run-test set!-global-variables 4)
  )

  (order-matters! equal? ; (run-test order-matters!)
    [(eval-one-exp '(let ((r 2) (ls '(3)) (count 7)) (let loop () (if (> count 0) (begin (set! ls (cons r ls)) (set! r (+ r count)) (set! count (- count 1)) (loop)))) (list r ls count))) '(30 (29 27 24 20 15 9 2 3) 0) 12] ; (run-test order-matters! 1)
    [(eval-one-exp '(begin (define latest 1) (define total 1) (or (begin (set! latest (+ latest 1)) (set! total (+ total latest)) (> total 50)) (begin (set! latest (+ latest 1)) (set! total (+ total latest)) (> total 50)) (begin (set! latest (+ latest 1)) (set! total (+ total latest)) (> total 50)) (begin (set! latest (+ latest 1)) (set! total (+ total latest)) (> total 50)) (begin (set! latest (+ latest 1)) (set! total (+ total latest)) (> total 50)) (begin (set! latest (+ latest 1)) (set! total (+ total latest)) (> total 50)) (begin (set! latest (+ latest 1)) (set! total (+ total latest)) (> total 50)) (begin (set! latest (+ latest 1)) (set! total (+ total latest)) (> total 50)) (begin (set! latest (+ latest 1)) (set! total (+ total latest)) (> total 50)) (begin (set! latest (+ latest 1)) (set! total (+ total latest)) (> total 50))) total)) 55 12] ; (run-test order-matters! 2)
  )

  (misc equal? ; (run-test misc)
    [(eval-one-exp '(apply apply (list + '(1 2)))) 3 5] ; (run-test misc 1)
    [(eval-one-exp '(apply map (list (lambda (x) (+ x 3)) '(2 4)))) '(5 7) 5] ; (run-test misc 2)
    [(begin (reset-global-env) (eval-one-exp '(let ([x 2]) (or (begin (set! x (add1 x)) #f) (begin (set! x (add1 x)) #f) (begin (set! x (+ 10 x)) #t)) (or x (set! x 25) x)))) 14 8] ; (run-test misc 3)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
