#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A05.rkt")
(provide get-weights get-names individual-test test)

(define set-equals?  ; are these list-of-symbols equal when
  (lambda (s1 s2)    ; treated as sets?
    (if (or (not (list? s1)) (not (list? s2)))
        #f
        (not (not (and (is-a-subset? s1 s2) (is-a-subset? s2 s1)))))))

(define test (make-test ; (r)
  (minimize-interval-list set-equals? ; (run-test minimize-interval-list)
    [(minimize-interval-list (quote ((1 4) (2 10) (3 5) (3 4) (3 7)))) '((1 10)) 2] ; (run-test minimize-interval-list 1)
    [(minimize-interval-list (quote ((1 4) (2 5) (6 8)))) '((1 5) (6 8)) 1] ; (run-test minimize-interval-list 2)
    [(minimize-interval-list (quote ((1 2) (2 3)))) '((1 3)) 1] ; (run-test minimize-interval-list 3)
    [(minimize-interval-list (quote ((1 2) (1 3) (1 4) (2 5) (1 3) (1 4) (1 2) (1 3)))) '((1 5)) 1] ; (run-test minimize-interval-list 4)
    [(minimize-interval-list (quote ((1 2) (4 5) (7 10)))) '((1 2) (4 5) (7 10)) 2] ; (run-test minimize-interval-list 5)
    [(minimize-interval-list (quote ((1 2) (4 5) (5 6) (6 7) (7 8) (8 9) (9 10)))) '((1 2) (4 10)) 2] ; (run-test minimize-interval-list 6)
    [(minimize-interval-list (quote ((1 4)))) '((1 4)) 1] ; (run-test minimize-interval-list 7)
    [(minimize-interval-list '((1 3) (2 3))) '((1 3)) 1] ; (run-test minimize-interval-list 8)
    [(minimize-interval-list '((1 2) (3 4))) '((1 2) (3 4)) 1] ; (run-test minimize-interval-list 9)
    [(minimize-interval-list '((1 3) (8 10) (2 4) (9 11))) '((1 4) (8 11)) 2] ; (run-test minimize-interval-list 10)
    [(minimize-interval-list '((2 5) (1 7) (6 10) (10 11))) '((1 11)) 2] ; (run-test minimize-interval-list 11)
    [(minimize-interval-list '((1 2) (4 7) (1 2))) '((1 2) (4 7)) 2] ; (run-test minimize-interval-list 12)
    [(minimize-interval-list '((1 2) (3 20) (4 7) (5 6) (5 7) (11 14) (8 9))) '((1 2) (3 20)) 2] ; (run-test minimize-interval-list 13)
  )

  (exists? eq? ; (run-test exists?)
    [all-or-nothing 3 ; (run-test exists? 1)
      ((exists? symbol? (quote (1 2 3 a 5))) #t)
      ((exists? not (quote (#t #t #t #t))) #f)]
    [all-or-nothing 2 ; (run-test exists? 2)
      ((exists? null? '(1 2 () 3)) #t)
      ((exists? null? '()) #f)]
  )

  (product set-equals? ; (run-test product)
    [(product (quote ()) (quote ())) '() 2] ; (run-test product 1)
    [(product (quote (x y z)) (quote ())) '() 1] ; (run-test product 2)
    [(product (quote ()) (quote (a b c))) '() 1] ; (run-test product 3)
    [(product (quote (x y)) (quote (a b c))) '((x a) (x b) (x c) (y a) (y b) (y c)) 6] ; (run-test product 4)
  )

  (replace equal? ; (run-test replace)
    [(replace 5 7 '()) '() 2] ; (run-test replace 1)
    [(replace 5 7 '(1 5 2 5 4)) '(1 7 2 7 4) 2] ; (run-test replace 2)
    [(replace 5 7 '(7 5 7 5 7)) '(7 7 7 7 7) 3] ; (run-test replace 3)
    [(replace 5 7 '(1 3 2 6 4)) '(1 3 2 6 4) 3] ; (run-test replace 4)
  )

  (remove-last equal? ; (run-test remove-last)
    [(remove-last 'b '(a b c b d)) '(a b c d) 1] ; (run-test remove-last 1)
    [(remove-last 'b '(a c d)) '(a c d) 1] ; (run-test remove-last 2)
    [(remove-last 'b '(a b c b d b e b f)) '(a b c b d b e f) 4] ; (run-test remove-last 3)
    [(remove-last 'b '(a b c b d b e b f)) '(a b c b d b e f) 4] ; (run-test remove-last 4)
    [(remove-last 'b '()) '() 1] ; (run-test remove-last 5)
    [(remove-last 'b '(b b b b)) '(b b b) 4] ; (run-test remove-last 6)
  )
))
(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))


(implicit-run test) ; run tests as soon as this file is loaded
