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
  (legacy equal? ; (run-test legacy)
    [(eval-one-exp '(let ((x 5) (y 3)) (let ((z (begin (set! x (+ x y)) x))) (+ z (+ x y))))) 19 1] ; (run-test legacy 1)
    [(begin (reset-global-env) (eval-one-exp '(begin (define cde 5) (define def (+ cde 2)) (+ def (add1 cde))))) 13 1] ; (run-test legacy 2)
    [(begin (reset-global-env) (eval-one-exp '(letrec ((f (lambda (n) (if (zero? n) 0 (+ 4 (g (sub1 n)))))) (g (lambda (n) (if (zero? n) 0 (+ 3 (f (sub1 n))))))) (g (f (g (f 5))))))) 773 1] ; (run-test legacy 3)
    [(begin (reset-global-env) (eval-one-exp '(define rotate-linear (letrec ((reverse (lambda (lyst revlist) (if (null? lyst) revlist (reverse (cdr lyst) (cons (car lyst) revlist)))))) (lambda (los) (let loop ((los los) (sofar '())) (cond ((null? los) los) ((null? (cdr los)) (cons (car los) (reverse sofar '()))) (else (loop (cdr los) (cons (car los) sofar))))))))) (eval-one-exp '(rotate-linear '(1 2 3 4 5 6 7 8)))) '(8 1 2 3 4 5 6 7) 1] ; (run-test legacy 4)
    [(begin (reset-global-env) (eval-one-exp '(let ((r 2) (ls '(3)) (count 7)) (let loop () (if (> count 0) (begin (set! ls (cons r ls)) (set! r (+ r count)) (set! count (- count 1)) (loop)))) (list r ls count)))) '(30 (29 27 24 20 15 9 2 3) 0) 1] ; (run-test legacy 5)
    [(eval-one-exp '(apply apply (list + '(1 2)))) 3 1] ; (run-test legacy 6)
    [(eval-one-exp '(apply map (list (lambda (x) (+ x 3)) '(2 4)))) '(5 7) 1] ; (run-test legacy 7)
    [(eval-one-exp '(letrec ( (apply-continuation (lambda (k val) (k val))) (subst-left-cps (lambda (new old slist changed unchanged) (let loop ((slist slist) (changed changed) (unchanged unchanged)) (cond ((null? slist) (apply-continuation unchanged #f)) ((symbol? (car slist)) (if (eq? (car slist) old) (apply-continuation changed (cons new (cdr slist))) (loop (cdr slist) (lambda (changed-cdr) (apply-continuation changed (cons (car slist) changed-cdr))) unchanged))) (else (loop (car slist) (lambda (changed-car) (apply-continuation changed (cons changed-car (cdr slist)))) (lambda (t) (loop (cdr slist) (lambda (changed-cdr) (apply-continuation changed (cons (car slist) changed-cdr))) unchanged))))))))) (let ((s '((a b (c () (d e (f g)) h)) i))) (subst-left-cps 'new 'e s (lambda (changed-s) (subst-left-cps 'new 'q s (lambda (wont-be-changed) 'whocares) (lambda (r) (list changed-s)))) (lambda (p) "It's an error to get here"))))) '(((a b (c () (d new (f g)) h)) i)) 1] ; (run-test legacy 8)
    [(eval-one-exp '((lambda () 3 4 5))) 5 1] ; (run-test legacy 9)
  )

  (simple-call/cc equal? ; (run-test simple-call/cc)
    [(eval-one-exp '(+ 5 (call/cc (lambda (k) (+ 6 (k 7)))))) 12 1] ; (run-test simple-call/cc 1)
    [(eval-one-exp '(+ 3 (call/cc (lambda (k) (* 2 5))))) 13 1] ; (run-test simple-call/cc 2)
    [(eval-one-exp '(+ 5 (call/cc (lambda (k) (or #f #f (+ 7 (k 4)) #f))))) 9 1] ; (run-test simple-call/cc 3)
    [(eval-one-exp '(list (call/cc procedure?))) '(#t) 1] ; (run-test simple-call/cc 4)
    [(eval-one-exp '(+ 2 (call/cc (lambda (k) (+ 3 (let* ((x 5) (y (k 7))) (+ 10 (k 5)))))))) 9 1] ; (run-test simple-call/cc 5)
    [(eval-one-exp '((car (call/cc list)) (list cdr 1 2 3))) '(1 2 3) 1] ; (run-test simple-call/cc 6)
    [(eval-one-exp '(let ((a 5) (b 6)) (set! a (+ 7 (call/cc (lambda (k) (set! b (k 11)))))) (list a b))) '(18 6) 1] ; (run-test simple-call/cc 7)
  )

  (complex-call/cc equal? ; (run-test complex-call/cc)
    [(begin (reset-global-env) (eval-one-exp '(define xxx #f)) (eval-one-exp '(+ 5 (call/cc (lambda (k) (set! xxx k) 2)))) (eval-one-exp '(* 7 (xxx 4)))) 9 1] ; (run-test complex-call/cc 1)
    [(begin (eval-one-exp '(define break-out-of-map #f)) (eval-one-exp '(set! break-out-of-map (call/cc (lambda (k) (lambda (x) (if (= x 7) (k 1000) (+ x 4))))))) (eval-one-exp '(map break-out-of-map '(1 3 5 7 9 11))) (eval-one-exp 'break-out-of-map)) 1000 1] ; (run-test complex-call/cc 2)
    [(begin (eval-one-exp '(define jump-into-map #f)) (eval-one-exp '(define do-the-map (lambda (x) (map (lambda (v) (if (= v 7) (call/cc (lambda (k) (set! jump-into-map k) 100)) (+ 3 v))) x)))) (eval-one-exp '(do-the-map '(3 4 5 6 7 8 9 10)))) '(6 7 8 9 100 11 12 13) 1] ; (run-test complex-call/cc 3)
    [(begin (eval-one-exp '(define jump-into-map #f)) (eval-one-exp '(define do-the-map (lambda (x) (map (lambda (v) (if (= v 7) (call/cc (lambda (k) (set! jump-into-map k) 100)) (+ 3 v))) x)))) (eval-one-exp '(list (do-the-map '(3 4 5 6 7 8 9 10)))) (eval-one-exp '(jump-into-map 987654321))) '((6 7 8 9 987654321 11 12 13)) 1] ; (run-test complex-call/cc 4)
    [(eval-one-exp '(let ((y (call/cc (call/cc (call/cc call/cc))))) (y list) (y 4))) '(4) 1] ; (run-test complex-call/cc 5)
    [(eval-one-exp '(+ 4 (apply call/cc (list (lambda (k) (* 2 (k 5))))))) 9 1] ; (run-test complex-call/cc 6)
    [(eval-one-exp '(letrec ((a (lambda (x) (+ 12 (call/cc (lambda (k) (if (k x) 7 (a (- x 3))))))))) (+ 6 (a 7)))) 25 1] ; (run-test complex-call/cc 7)
    [(eval-one-exp '(map (call/cc (lambda (k) (lambda (v) (if (= v 1) (k add1) (+ 4 v))))) '( 2 1 4 1 4))) '(3 2 5 2 5) 1] ; (run-test complex-call/cc 8)
    [(eval-one-exp '(begin (define a 4) (define f (lambda () (call/cc (lambda (k) (set! a (+ 1 a)) (set! a (+ 2 a)) (k a) (set! a (+ 5 a)) a)))) (f))) 7 1] ; (run-test complex-call/cc 9)
  )

  (exit-list equal? ; (run-test exit-list)
    [(eval-one-exp '(+ 4 (exit-list 5 (exit-list 6 7)))) '(6 7) 1] ; (run-test exit-list 1)
    [(eval-one-exp '(+ 3 (- 2 (exit-list 5)))) '(5) 1] ; (run-test exit-list 2)
    [(eval-one-exp '(- 7 (if (exit-list 3) 4 5))) '(3) 1] ; (run-test exit-list 3)
    [(eval-one-exp '(call/cc (lambda (k) (+ 100 (exit-list (+ 3 (k 12))))))) 12 1] ; (run-test exit-list 4)
    [(eval-one-exp '(call/cc (lambda (k) (+ 100 (k (+ 3 (exit-list 12))))))) '(12) 1] ; (run-test exit-list 5)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
