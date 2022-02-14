#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A19.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
  (sum-cps equal? ; (run-test sum-cps)
    [(begin (set!-slist '()) (set!-k (id-k)) (sum-cps)) 0 1] ; (run-test sum-cps 1)
    [(begin (set!-slist '(1)) (set!-k (list-k)) (sum-cps)) '(1) 3] ; (run-test sum-cps 2)
    [(begin (set!-slist '(1 2)) (set!-k (id-k)) (sum-cps)) 3 3] ; (run-test sum-cps 3)
    [(begin (set!-slist '((1))) (set!-k (id-k)) (sum-cps)) 1 3] ; (run-test sum-cps 4)
    [(begin (set!-slist '((1) 2)) (set!-k (id-k)) (sum-cps)) 3 4] ; (run-test sum-cps 5)
    [(begin (set!-slist '((1) () 2 (3))) (set!-k (id-k)) (sum-cps)) 6 5] ; (run-test sum-cps 6)
    [(begin (set!-slist '(1 2 (((() 4 ))))) (set!-k (id-k)) (sum-cps)) 7 5] ; (run-test sum-cps 7)
    [(begin (set!-slist '((1) ((2 (3 ()) (((4 5))) () 6)))) (set!-k (id-k)) (sum-cps)) 21 7] ; (run-test sum-cps 8)
  )

  (flatten-cps equal? ; (run-test flatten-cps)
    [(begin (set!-slist '()) (set!-k (id-k)) (flatten-cps)) '() 1] ; (run-test flatten-cps 1)
    [(begin (set!-slist '(a)) (set!-k (id-k)) (flatten-cps)) '(a) 2] ; (run-test flatten-cps 2)
    [(begin (set!-slist '(a b)) (set!-k (id-k)) (flatten-cps)) '(a b) 3] ; (run-test flatten-cps 3)
    [(begin (set!-slist '(a d e c g b t)) (set!-k (list-k)) (flatten-cps)) '((a d e c g b t)) 3] ; (run-test flatten-cps 4)
    [(begin (set!-slist '(d a e c g b (t))) (set!-k (id-k)) (flatten-cps)) '(d a e c g b t) 6] ; (run-test flatten-cps 5)
    [(begin (set!-slist '(((d a () (e) c ) g b) t)) (set!-k (length-k)) (flatten-cps)) 7 6] ; (run-test flatten-cps 6)
    [(begin (set!-slist '(((a d () (((e))) c ) b g) t)) (set!-k (id-k)) (flatten-cps)) '(a d e c b g t) 8] ; (run-test flatten-cps 7)
    [(begin (set!-slist '(t ((a d () (((e))) c ) g ((())) b))) (set!-k (id-k)) (flatten-cps)) '(t a d e c g b) 10] ; (run-test flatten-cps 8)
    [(begin (set!-slist '(( () (a d () c (((e)))) g ((())) b) t)) (set!-k (id-k)) (flatten-cps)) '(a d c e g b t) 10] ; (run-test flatten-cps 9)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
