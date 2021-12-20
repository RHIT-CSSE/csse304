#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A10.rkt")
(provide get-weights get-names individual-test test)


(define sequal?-grading
  (lambda (l1 l2)
    (cond
     ((null? l1) (null? l2))
     ((null? l2) (null? l1))
     ((or (not (set?-grading l1))
          (not (set?-grading l2)))
      #f)
     ((member (car l1) l2) (sequal?-grading
                            (cdr l1)
                            (rember-grading
                             (car l1)
                             l2)))
     (else #f))))

(define rember-grading
  (lambda (a ls)
    (cond
     ((null? ls) ls)
     ((equal? a (car ls)) (cdr ls))
     (else (cons (car ls) (rember-grading a (cdr ls)))))))

(define test (make-test ; (r)
  (free-vars sequal?-grading ; (run-test free-vars)
    [(free-vars '((lambda (x) y) (lambda (y) x))) '(x y) 1] ; (run-test free-vars 1)
    [(free-vars (quote (x x))) '(x) 1] ; (run-test free-vars 2)
    [(free-vars '((lambda (x) (x y)) (z (lambda (y) (z y))))) '(y z) 1] ; (run-test free-vars 3)
    [(free-vars (quote (lambda (x) y))) '(y) 1] ; (run-test free-vars 4)
    [(free-vars (quote (x (lambda (x) x)))) '(x) 1] ; (run-test free-vars 5)
    [(free-vars (quote (x (lambda (x) (y z))))) '(x y z) 1] ; (run-test free-vars 6)
    [(free-vars (quote (x (lambda (x) y)))) '(x y) 1] ; (run-test free-vars 7)
    [(free-vars (quote ((lambda (y) (lambda (y) y)) (lambda (x) (lambda (x) x))))) '() 1] ; (run-test free-vars 8)
  )

  (bound-vars sequal?-grading ; (run-test bound-vars)
    [(bound-vars (quote (x x))) '() 1] ; (run-test bound-vars 1)
    [(bound-vars (quote (lambda (x) x))) '(x) 1] ; (run-test bound-vars 2)
    [(bound-vars (quote (lambda (y) x))) '() 1] ; (run-test bound-vars 3)
    [(bound-vars (quote (x (lambda (x) x)))) '(x) 1] ; (run-test bound-vars 4)
    [(bound-vars (quote (x (lambda (x) y)))) '() 1] ; (run-test bound-vars 5)
    [(bound-vars (quote (z (lambda (x) (lambda (y) x))))) '(x) 1] ; (run-test bound-vars 6)
    [(bound-vars (quote ((lambda (y) (lambda (y) y)) (lambda (x) (z (lambda (x) x)))))) '(y x) 1] ; (run-test bound-vars 7)
  )

  (occurs-free? equal? ; (run-test occurs-free?)
    [(occurs-free? (quote x) (quote (lambda (a b x) x))) #f 1] ; (run-test occurs-free? 1)
    [(occurs-free? (quote x) (quote (lambda () (x)))) #t 1] ; (run-test occurs-free? 2)
    [(occurs-free? (quote x) (quote (x (lambda (y x z) x)))) #t 1] ; (run-test occurs-free? 3)
    [(occurs-free? (quote x) (quote (lambda (a b) (if (x a b) a b)))) #t 1] ; (run-test occurs-free? 4)
    [(occurs-free? (quote a) (quote (lambda (a b) (if (x a b) a b)))) #f 1] ; (run-test occurs-free? 5)
    [(occurs-free? (quote x) (quote (let ((x n)) ((lambda (y) (+ y x)) z)))) #f 2] ; (run-test occurs-free? 6)
    [(occurs-free? (quote x) (quote (let ((w a) (y x)) ((lambda (y) (+ y x)) z)))) #t 2] ; (run-test occurs-free? 7)
    [(occurs-free? (quote x) (quote (let* ((x a) (y x)) (y)))) #f 2] ; (run-test occurs-free? 8)
    [(occurs-free? (quote b) (quote (let* ((y a) (x b)) ((x y) z)))) #t 1] ; (run-test occurs-free? 9)
    [(occurs-free? (quote set!) (quote (lambda (x) (set! x y)))) #f 1] ; (run-test occurs-free? 10)
    [(occurs-free? (quote x) (quote (lambda () (let* ((x a) (y x)) (if (y z) (lambda () x) (lambda () y)))))) #f 1] ; (run-test occurs-free? 11)
    [(occurs-free? (quote x) (quote (lambda () (let ((x a) (y x)) (if (y z) (lambda () x) (lambda () y)))))) #t 2] ; (run-test occurs-free? 12)
    [(occurs-free? (quote y) (quote (let ((y ((lambda (x) (+ x y)) z))) (+ y y)))) #t 2] ; (run-test occurs-free? 13)
    [(occurs-free? (quote z) (quote (let ((y ((lambda (x) (+ x y)) z))) (+ y y)))) #t 1] ; (run-test occurs-free? 14)
    [(occurs-free? 'x '(set! x y)) #f 1] ; (run-test occurs-free? 15)
    [(occurs-free? 'y '(set! x y)) #t 1] ; (run-test occurs-free? 16)
  )

  (occurs-bound? equal? ; (run-test occurs-bound?)
    [all-or-nothing 1 ; (run-test occurs-bound? 1)
      ((occurs-bound? (quote x) (quote (lambda (a b x) x))) #t)
      ((occurs-bound? (quote y) (quote (lambda (x a b) y))) #f)]
    [all-or-nothing 1 ; (run-test occurs-bound? 2)
      ((occurs-bound? (quote x) (quote (x (lambda (y x z) x)))) #t)
      ((occurs-bound? (quote x) (quote (lambda (a b) (if (x a b) a b)))) #f)]
    [(occurs-bound? (quote x) (quote (let ((x n)) ((lambda (y) (+ y x)) z)))) #t 1] ; (run-test occurs-bound? 3)
    [(occurs-bound? (quote x) (quote (let ((w a) (y x)) ((lambda (y) (+ y x)) z)))) #f 1] ; (run-test occurs-bound? 4)
    [(occurs-bound? (quote x) (quote (let* ((x a) (y x)) (y)))) #t 1] ; (run-test occurs-bound? 5)
    [(occurs-bound? (quote b) (quote (let* ((y a) (x b)) ((x y) z)))) #f 1] ; (run-test occurs-bound? 6)
    [(occurs-bound? (quote a) (quote (let* ((a x) (b c) (c b)) c))) #f 1] ; (run-test occurs-bound? 7)
    [(occurs-bound? (quote b) (quote (let* ((a x) (b c) (c b)) c))) #t 1] ; (run-test occurs-bound? 8)
    [(occurs-bound? (quote c) (quote (let* ((a x) (b c) (c b)) c))) #t 1] ; (run-test occurs-bound? 9)
    [(occurs-bound? (quote set!) (quote (lambda (x) (set! x y)))) #f 1] ; (run-test occurs-bound? 10)
    [(occurs-bound? (quote x) (quote (lambda (x) (x)))) #t 1] ; (run-test occurs-bound? 11)
    [(occurs-bound? (quote x) (quote (lambda () x))) #f 1] ; (run-test occurs-bound? 12)
    [(occurs-bound? (quote x) (quote (lambda () (let* ((x a) (y x)) (if (y z) (lambda () x) (lambda () y)))))) #t 1] ; (run-test occurs-bound? 13)
    [(occurs-bound? (quote z) (quote (lambda () (let* ((x a) (y x)) (if (y z) (lambda () x) (lambda () y)))))) #f 1] ; (run-test occurs-bound? 14)
    [(occurs-bound? (quote y) (quote (let ((y ((lambda (x) (+ x y)) z))) (+ y y)))) #t 1] ; (run-test occurs-bound? 15)
    [(occurs-bound? (quote z) (quote (let ((y ((lambda (x) (+ x y)) z))) (+ y y)))) #f 1] ; (run-test occurs-bound? 16)
    [all-or-nothing 1 ; (run-test occurs-bound? 17)
      ((occurs-bound? 'x '(lambda (x) (set! y x))) #t)
      ((occurs-bound? 'y '(lambda (x) (set! y x))) #f)]
    [all-or-nothing 2 ; (run-test occurs-bound? 18)
      ((occurs-bound? 'x '(if y x (lambda (x) (lambda (y) x)))) #t)
      ((occurs-bound? 'y '(if y x (lambda (x) (lambda (y) x)))) #f)]
  )

  (lexical-address equal? ; (run-test lexical-address)
    [(lexical-address (quote x)) '(: free x) 1] ; (run-test lexical-address 1)
    [(lexical-address (quote (x y))) '((: free x) (: free y)) 2] ; (run-test lexical-address 2)
    [(lexical-address (quote (lambda (x y) (cons x y)))) '(lambda (x y) ((: free cons) (: 0 0) (: 0 1))) 2] ; (run-test lexical-address 3)
    [(lexical-address (quote (lambda (x y z) (if y x z)))) '(lambda (x y z) (if (: 0 1) (: 0 0) (: 0 2))) 2] ; (run-test lexical-address 4)
    [(lexical-address (quote (lambda (x y) (lambda () ((lambda (z) (lambda (x w) (lambda () (x y z w)))) (x y z w)))))) '(lambda (x y) (lambda () ((lambda (z) (lambda (x w) (lambda () ((: 1 0) (: 4 1) (: 2 0) (: 1 1))))) ((: 1 0) (: 1 1) (: free z) (: free w))))) 4] ; (run-test lexical-address 5)
    [(lexical-address (quote (lambda (a b c) (if (eq? b c) ((lambda (c) (cons a c)) a) b)))) '(lambda (a b c) (if ((: free eq?)(: 0 1) (: 0 2)) ((lambda (c) ((: free cons) (: 1 0) (: 0 0))) (: 0 0)) (: 0 1))) 3] ; (run-test lexical-address 6)
    [(lexical-address '((lambda (x y) (((lambda (z) (lambda (w y) (+ x z w y))) (list w x y z)) (+ x y z))) (y z))) '((lambda (x y) (((lambda (z) (lambda (w y) ((: free +) (: 2 0) (: 1 0) (: 0 0) (: 0 1)))) ((: free list) (: free w) (: 0 0) (: 0 1) (: free z))) ((: free +) (: 0 0) (: 0 1) (: free z)))) ((: free y) (: free z))) 4] ; (run-test lexical-address 7)
    [(lexical-address (quote (if ((lambda (x) (y x)) (lambda (y) (y x))) (lambda (z) (if x y (cons z z))) (x y)))) '(if ((lambda (x) ((: free y) (: 0 0))) (lambda (y) ((: 0 0) (: free x)))) (lambda (z) (if (: free x) (: free y) ((: free cons) (: 0 0) (: 0 0)))) ((: free x) (: free y))) 3] ; (run-test lexical-address 8)
    [(lexical-address '(+ a (let ((a b) (b a)) (a b)))) '((: free +) (: free a) (let ((a (: free b)) (b (: free a))) ((: 0 0) (: 0 1)))) 3] ; (run-test lexical-address 9)
    [(lexical-address '(lambda (a b) (+ a b (let ((x (+ a c)) (y (- a b))) (let ((x x) (z (+ y a)) (w (b x))) ((lambda (t) (a (lambda (a) (x y a b)))) (t w))))))) '(lambda (a b) ((: free +) (: 0 0) (: 0 1) (let ((x ((: free +) (: 0 0) (: free c))) (y ((: free -) (: 0 0) (: 0 1)))) (let ((x (: 0 0)) (z ((: free +) (: 0 1) (: 1 0))) (w ((: 1 1) (: 0 0)))) ((lambda (t) ((: 3 0) (lambda (a) ((: 2 0) (: 3 1) (: 0 0) (: 4 1))))) ((: free t) (: 0 2))))))) 3] ; (run-test lexical-address 10)
    [(lexical-address '((lambda (a b) (set! a b)) (let ((c a)) (set! d c)))) '((lambda (a b) (set! a (: 0 1))) (let ((c (: free a))) (set! d (: 0 0)))) 3] ; (run-test lexical-address 11)
  )

  (un-lexical-address equal? ; (run-test un-lexical-address)
    [(un-lexical-address (lexical-address (quote (x y)))) '(x y) 4] ; (run-test un-lexical-address 1)
    [(un-lexical-address (lexical-address (quote (if ((lambda (x) (y x)) (lambda (y) (y x))) (lambda (z) (if x y (cons z z))) (x y))))) '(if ((lambda (x) (y x)) (lambda (y) (y x))) (lambda (z) (if x y (cons z z))) (x y)) 7] ; (run-test un-lexical-address 2)
    [(un-lexical-address (lexical-address (quote (lambda (x y) (lambda () ((lambda (z) (lambda (x w) (lambda () (x y z w)))) (x y z w))))))) '(lambda (x y) (lambda () ((lambda (z) (lambda (x w) (lambda () (x y z w)))) (x y z w)))) 7] ; (run-test un-lexical-address 3)
    [(un-lexical-address (lexical-address (quote (+ a (let ((a b) (b a)) (a b)))))) '(+ a (let ((a b) (b a)) (a b))) 4] ; (run-test un-lexical-address 4)
    [(un-lexical-address (lexical-address (quote (lambda (a b) (+ a b (let ((x (+ a c)) (y (- a b))) (let ((x x) (z (+ y a)) (w (b x))) ((lambda (t) (a (lambda (a) (x y a b)))) (t w))))))))) '(lambda (a b) (+ a b (let ((x (+ a c)) (y (- a b))) (let ((x x) (z (+ y a)) (w (b x))) ((lambda (t) (a (lambda (a) (x y a b)))) (t w)))))) 6] ; (run-test un-lexical-address 5)
    [(un-lexical-address (lexical-address (quote ((lambda (a b) (set! a b)) (let ((c a)) (set! d c)))))) '((lambda (a b) (set! a b)) (let ((c a)) (set! d c))) 2] ; (run-test un-lexical-address 6)
  )
))

(define set?-grading
  (lambda (s)
    (cond [(null? s) #t]
          [(not (list? s)) #f]
          [(member (car s) (cdr s)) #f]
          [else (set?-grading (cdr s))])))

(implicit-run test) ; run tests as soon as this file is loaded
