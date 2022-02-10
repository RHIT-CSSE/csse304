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
  (simple-call/cc equal? ; (run-test simple-call/cc)
    [(eval-one-exp '(+ 5 (call/cc (lambda (k) (+ 6 (k 7)))))) 12 7] ; (run-test simple-call/cc 1)
    [(eval-one-exp '(+ 3 (call/cc (lambda (k) (* 2 5))))) 13 4] ; (run-test simple-call/cc 2)
    [(eval-one-exp '(+ 5 (call/cc (lambda (k) (or #f #f (+ 7 (k 4)) #f))))) 9 7] ; (run-test simple-call/cc 3)
    [(eval-one-exp '(list (call/cc procedure?))) '(#t) 4] ; (run-test simple-call/cc 4)
    [(eval-one-exp '(+ 2 (call/cc (lambda (k) (+ 3 (let* ((x 5) (y (k 7))) (+ 10 (k 5)))))))) 9 7] ; (run-test simple-call/cc 5)
    [(eval-one-exp '((car (call/cc list)) (list cdr 1 2 3))) '(1 2 3) 7] ; (run-test simple-call/cc 6)
    [(eval-one-exp '(begin (define a (list (lambda (k) (* 2 (k 5))) (lambda (k) (* 2 (k 5))))) (+ 4 (car (map call/cc a))))) 9 5] ; (run-test simple-call/cc 7)
    [(eval-one-exp '(let [(sum 0) (a 5)] (+ 3 (call/cc (lambda (k) (while (< a 12) (set! sum (+ a sum)) (if (> sum 11) (k sum)) (set! a (add1 a)))))))) 21 7] ; (run-test simple-call/cc 8)
    [(eval-one-exp '(let ((a 5) (b 6)) (set! a (+ 7 (call/cc (lambda (k) (set! b (k 11)))))) (list a b))) '(18 6) 6] ; (run-test simple-call/cc 9)
  )

  (complex-call/cc equal? ; (run-test complex-call/cc)
    [(begin (reset-global-env) (eval-one-exp '(define xxx #f)) (eval-one-exp '(+ 5 (call/cc (lambda (k) (set! xxx k) 2)))) (eval-one-exp '(* 7 (xxx 4)))) 9 10] ; (run-test complex-call/cc 1)
    [(begin (eval-one-exp '(define break-out-of-map #f)) (eval-one-exp '(set! break-out-of-map (call/cc (lambda (k) (lambda (x) (if (= x 7) (k 1000) (+ x 4))))))) (eval-one-exp '(map break-out-of-map '(1 3 5 7 9 11))) (eval-one-exp 'break-out-of-map)) 1000 12] ; (run-test complex-call/cc 2)
    [(begin (eval-one-exp '(define jump-into-map #f)) (eval-one-exp '(define do-the-map (lambda (x) (map (lambda (v) (if (= v 7) (call/cc (lambda (k) (set! jump-into-map k) 100)) (+ 3 v))) x)))) (eval-one-exp '(do-the-map '(3 4 5 6 7 8 9 10)))) '(6 7 8 9 100 11 12 13) 12] ; (run-test complex-call/cc 3)
    [(begin (eval-one-exp '(define jump-into-map #f)) (eval-one-exp '(define do-the-map (lambda (x) (map (lambda (v) (if (= v 7) (call/cc (lambda (k) (set! jump-into-map k) 100)) (+ 3 v))) x)))) (eval-one-exp '(list (do-the-map '(3 4 5 6 7 8 9 10)))) (eval-one-exp '(jump-into-map 987654321))) '((6 7 8 9 987654321 11 12 13)) 10] ; (run-test complex-call/cc 4)
    [(eval-one-exp '(let ((y (call/cc (call/cc (call/cc call/cc))))) (y list) (y 4))) '(4) 10] ; (run-test complex-call/cc 5)
    [(eval-one-exp '(+ 4 (apply call/cc (list (lambda (k) (* 2 (k 5))))))) 9 8] ; (run-test complex-call/cc 6)
    [(eval-one-exp '(letrec ((a (lambda (x) (+ 12 (call/cc (lambda (k) (if (k x) 7 (a (- x 3))))))))) (+ 6 (a 7)))) 25 6] ; (run-test complex-call/cc 7)
    [(eval-one-exp '(map (call/cc (lambda (k) (lambda (v) (if (= v 1) (k add1) (+ 4 v))))) '( 2 1 4 1 4))) '(3 2 5 2 5) 8] ; (run-test complex-call/cc 8)
    [(begin (reset-global-env) (eval-one-exp '(define out (list))) (eval-one-exp '(define strange2 (lambda (x) (set! out (cons 1 out)) (call/cc x) (set! out (cons 2 out)) (call/cc x) (set! out (cons 3 out))))) (eval-one-exp '(strange2 (call/cc (lambda (k) k)))) (eval-one-exp 'out)) '(3 1 2 1 1) 8] ; (run-test complex-call/cc 9)
    [(eval-one-exp '(begin (define a 4) (define f (lambda () (call/cc (lambda (k) (set! a (+ 1 a)) (set! a (+ 2 a)) (k a) (set! a (+ 5 a)) a)))) (f))) 7 7] ; (run-test complex-call/cc 10)
  )

  (exit-list equal? ; (run-test exit-list)
    [(eval-one-exp '(+ 4 (exit-list 5 (exit-list 6 7)))) '(6 7) 7] ; (run-test exit-list 1)
    [(eval-one-exp '(+ 3 (- 2 (exit-list 5)))) '(5) 2] ; (run-test exit-list 2)
    [(eval-one-exp '(- 7 (if (exit-list 3) 4 5))) '(3) 7] ; (run-test exit-list 3)
    [(eval-one-exp '(call/cc (lambda (k) (+ 100 (exit-list (+ 3 (k 12))))))) 12 7] ; (run-test exit-list 4)
    [(eval-one-exp '(call/cc (lambda (k) (+ 100 (k (+ 3 (exit-list 12))))))) '(12) 7] ; (run-test exit-list 5)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
