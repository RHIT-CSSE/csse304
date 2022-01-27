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
  (ref equal? ; (run-test ref)
    [(begin (reset-global-env) (eval-one-exp '(let ((a 3) (b 4) (swap! (lambda ((ref x) (ref y)) (let ((temp x)) (set! x y) (set! y temp))))) (swap! a b) (list a b)))) '(4 3) 8] ; (run-test ref 1)
    [(begin (reset-global-env) (eval-one-exp '(let ((a 3) (b 4) (swap (lambda ((ref x) y) (let ((temp x)) (set! x y) (set! y temp))))) (swap a b) (list a b)))) '(4 4) 7] ; (run-test ref 2)
    [(begin (reset-global-env) (eval-one-exp '(let* ((a '(1 2 3)) (b ((lambda ((ref x)) x) a))) (set! b 'foo) a))) '(1 2 3) 7] ; (run-test ref 3)
    [(begin (reset-global-env) (eval-one-exp '(define x '(a a a))) (eval-one-exp '(define y '(b b b))) (eval-one-exp '(let () ((lambda ((ref x) y) (set! x '(1 2 3)) (set! y '(4 5 6))) x y) (list x y)))) '((1 2 3) (b b b)) 7] ; (run-test ref 4)
    [(begin (reset-global-env) (eval-one-exp '(let ((a 3) (swap! (lambda ((ref x) (ref y)) (let ((temp x)) (set! x y) (set! y temp))))) (swap! a (+ 2 3)) (list a)))) '(5) 8] ; (run-test ref 5)
    [(eval-one-exp '(let ((a 3) (b 4) (rotate (lambda (x (ref y) (ref z)) (let ((temp x)) (set! x y) (set! y z) (set! z temp) (list x y z))))) (let ((result (rotate a b (+ a b)))) (list a b result)))) '(3 7 (4 7 3)) 8] ; (run-test ref 6)
    [(begin (reset-global-env) (eval-one-exp '(let ([a 3] [b 4]) (let* ([double-each (lambda ((ref s) (ref t)) (set! s (* 2 s)) (set! t (* 2 t)))] [double-and-swap! (lambda ((ref x) (ref y)) (double-each x y) (let ([temp x]) (set! x y) (set! y temp)))]) (double-and-swap! a b) (list a b))))) '(8 6) 8] ; (run-test ref 7)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
