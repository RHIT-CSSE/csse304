#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A08.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
  (make-slist-leaf-iterator equal? ; (run-test make-slist-leaf-iterator)
    [(let ((iter (make-slist-leaf-iterator (quote ((a b ())))))) (begin (iter 'next) (iter 'next)) (iter 'next)) #f 3] ; (run-test make-slist-leaf-iterator 1)
    [(let ((iter (make-slist-leaf-iterator (quote ((())))))) (iter 'next)) #f 3] ; (run-test make-slist-leaf-iterator 2)
    [(let ((iter (make-slist-leaf-iterator (quote ((() a (b c d ()) () e f g)))))) (iter 'next)) 'a 4] ; (run-test make-slist-leaf-iterator 3)
    [(let ((iter (make-slist-leaf-iterator (quote ((() a (b () c (d ())) () e f g)))))) (begin (iter 'next) (iter 'next) (iter 'next) (iter 'next)) (iter 'next)) 'e 5] ; (run-test make-slist-leaf-iterator 4)
    [(let ((iter (make-slist-leaf-iterator (quote ((() (() ()) (a) (z (x) d ()) () e f g)))))) (begin (iter 'next)) (iter 'next)) 'z 7] ; (run-test make-slist-leaf-iterator 5)
    [(let ((iter1 (make-slist-leaf-iterator (quote (a (b (c) (d)) (((e))))))) (iter2 (make-slist-leaf-iterator (quote (z (x n (v) ((m)))))))) (let loop ((count 2) (accum (quote ()))) (if (>= count 0) (loop (- count 1) (cons (iter1 'next) (cons (iter2 'next) accum))) accum))) '(c n b x a z) 12] ; (run-test make-slist-leaf-iterator 6)
    [(let ((iter (make-slist-leaf-iterator (quote ((() (z) (a (x) d ()) () e f g)))))) (begin (iter 'next) (iter 'next) (iter 'next) (iter 'next) (iter 'next) (iter 'next) (iter 'next) (iter 'next) (iter 'next)) (iter 'next)) #f 6] ; (run-test make-slist-leaf-iterator 7)
  )

  (subst-leftmost equal? ; (run-test subst-leftmost)
    [(subst-leftmost 'k 'b '() eq?) '() 2] ; (run-test subst-leftmost 1)
    [(subst-leftmost 'k 'b '(b b) eq?) '(k b) 2] ; (run-test subst-leftmost 2)
    [(subst-leftmost 'k 'b '(a b a b) eq?) '(a k a b) 4] ; (run-test subst-leftmost 3)
    [(subst-leftmost 'k 'b '(a ((b b)) a b) eq?) '(a ((k b)) a b) 6] ; (run-test subst-leftmost 4)
    [(subst-leftmost 'k 'b '((c d a (e () f b (c b)) (a b)) (b)) eq?) '((c d a (e () f k (c b)) (a b)) (b)) 7] ; (run-test subst-leftmost 5)
    [(subst-leftmost 'b 'a '(c (A e) a d) (lambda (x y) (string-ci=? (symbol->string x) (symbol->string y)))) '(c (b e) a d) 7] ; (run-test subst-leftmost 6)
    [(subst-leftmost 'c 'a '((b b) (a e)) eq?) '((b b) (c e)) 6] ; (run-test subst-leftmost 7)
    [(subst-leftmost 'k 'a '(c (g e) a d) eq?) '(c (g e) k d) 6] ; (run-test subst-leftmost 8)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
