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
    [(eval-one-exp '(let ((x 5) (y 3)) (let ((z (begin (set! x (+ x y)) x))) (+ z (+ x y))))) 19 2] ; (run-test legacy 1)
    [(begin (reset-global-env) (eval-one-exp '(begin (define cde 5) (define def (+ cde 2)) (+ def (add1 cde))))) 13 2] ; (run-test legacy 2)
    [(begin (reset-global-env) (eval-one-exp '(letrec ((f (lambda (n) (if (zero? n) 0 (+ 4 (g (sub1 n)))))) (g (lambda (n) (if (zero? n) 0 (+ 3 (f (sub1 n))))))) (f (g (f 5)))))) 221 3] ; (run-test legacy 3)
    [(begin (reset-global-env) (eval-one-exp '(define rotate-linear (letrec ((reverse (lambda (lyst revlist) (if (null? lyst) revlist (reverse (cdr lyst) (cons (car lyst) revlist)))))) (lambda (los) (let loop ((los los) (sofar '())) (cond ((null? los) los) ((null? (cdr los)) (cons (car los) (reverse sofar '()))) (else (loop (cdr los) (cons (car los) sofar))))))))) (eval-one-exp '(rotate-linear '(1 2 3 4 5 6 7 8)))) '(8 1 2 3 4 5 6 7) 4] ; (run-test legacy 4)
    [(begin (reset-global-env) (eval-one-exp '(let ((r 2) (ls '(3)) (count 7)) (let loop () (if (> count 0) (begin (set! ls (cons r ls)) (set! r (+ r count)) (set! count (- count 1)) (loop)))) (list r ls count)))) '(30 (29 27 24 20 15 9 2 3) 0) 1] ; (run-test legacy 5)
    [(eval-one-exp '(apply apply (list + '(1 2)))) 3 2] ; (run-test legacy 6)
    [(eval-one-exp '(apply map (list (lambda (x) (+ x 3)) '(2 4)))) '(5 7) 3] ; (run-test legacy 7)
    [(eval-one-exp '(letrec ( (apply-continuation (lambda (k val) (k val))) (subst-left-cps (lambda (new old slist changed unchanged) (let loop ((slist slist) (changed changed) (unchanged unchanged)) (cond ((null? slist) (apply-continuation unchanged #f)) ((symbol? (car slist)) (if (eq? (car slist) old) (apply-continuation changed (cons new (cdr slist))) (loop (cdr slist) (lambda (changed-cdr) (apply-continuation changed (cons (car slist) changed-cdr))) unchanged))) (else (loop (car slist) (lambda (changed-car) (apply-continuation changed (cons changed-car (cdr slist)))) (lambda (t) (loop (cdr slist) (lambda (changed-cdr) (apply-continuation changed (cons (car slist) changed-cdr))) unchanged))))))))) (let ((s '((a b (c () (d e (f g)) h)) i))) (subst-left-cps 'new 'e s (lambda (changed-s) (subst-left-cps 'new 'q s (lambda (wont-be-changed) 'whocares) (lambda (r) (list changed-s)))) (lambda (p) "It's an error to get here"))))) '(((a b (c () (d new (f g)) h)) i)) 5] ; (run-test legacy 8)
    [(eval-one-exp '((lambda () 3 4 5))) 5 3] ; (run-test legacy 9)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
