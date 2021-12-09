#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A09.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
  (sn-list-sum equal? ; (run-test sn-list-sum)
    [(sn-list-sum (quote ())) 0 2] ; (run-test sn-list-sum 1)
    [(sn-list-sum (quote ((((5)))))) 5 2] ; (run-test sn-list-sum 2)
    [(sn-list-sum (quote (10 ((10) 10 10)))) 40 2] ; (run-test sn-list-sum 3)
    [(sn-list-sum (quote (1 (2 (3 4 ((5 6) 7) 8) 9) 10))) 55 4] ; (run-test sn-list-sum 4)
  )

  (sn-list-map equal? ; (run-test sn-list-map)
    [(sn-list-map (lambda (x) (+ x 1)) (quote (1 2 (3 (4))))) '(2 3 (4 (5))) 2] ; (run-test sn-list-map 1)
    [(sn-list-map (lambda (x) x) (quote ((a x) ((b x) (c x)) (d x)))) '((a x) ((b x) (c x)) (d x)) 4] ; (run-test sn-list-map 2)
    [(sn-list-map (lambda (x) (+ x 10)) (quote (0))) '(10) 4] ; (run-test sn-list-map 3)
  )

  (sn-list-paren-count equal? ; (run-test sn-list-paren-count)
    [(sn-list-paren-count (quote ((()) ()))) 8 2] ; (run-test sn-list-paren-count 1)
    [(sn-list-paren-count (quote ((1) (2) ((3))))) 10 2] ; (run-test sn-list-paren-count 2)
    [(sn-list-paren-count (quote (((1 2)) 1 2))) 6 2] ; (run-test sn-list-paren-count 3)
    [(sn-list-paren-count (quote ())) 2 2] ; (run-test sn-list-paren-count 4)
    [(sn-list-paren-count (quote (((1))))) 6 2] ; (run-test sn-list-paren-count 5)
  )

  (sn-list-reverse equal? ; (run-test sn-list-reverse)
    [(sn-list-reverse (quote ())) '() 1] ; (run-test sn-list-reverse 1)
    [(sn-list-reverse (quote (1))) '(1) 1] ; (run-test sn-list-reverse 2)
    [(sn-list-reverse (quote (b a))) '(a b) 2] ; (run-test sn-list-reverse 3)
    [(sn-list-reverse (quote (((b a))))) '(((a b))) 2] ; (run-test sn-list-reverse 4)
    [(sn-list-reverse (quote (a (b c) () (d (e f))))) '(((f e) d) () (c b) a) 2] ; (run-test sn-list-reverse 5)
    [(sn-list-reverse '((1 2) 3 (4 (5)))) '(((5) 4) 3 (2 1)) 2] ; (run-test sn-list-reverse 6)
  )

  (sn-list-occur equal? ; (run-test sn-list-occur)
    [(sn-list-occur (quote a) (quote (1 2 3 4 (5 (6 (7)))))) 0 2] ; (run-test sn-list-occur 1)
    [(sn-list-occur (quote x) (quote (a b c (d (e (f g (x) h i))) j))) 1 2] ; (run-test sn-list-occur 2)
    [(sn-list-occur (quote z) (quote (z (a (b z) z) z z))) 5 2] ; (run-test sn-list-occur 3)
    [(sn-list-occur (quote a) (quote (a (((((a))) a))))) 3 2] ; (run-test sn-list-occur 4)
    [(sn-list-occur (quote f) (quote (f))) 1 2] ; (run-test sn-list-occur 5)
  )

  (sn-list-depth equal? ; (run-test sn-list-depth)
    [(sn-list-depth (quote ())) 1 1] ; (run-test sn-list-depth 1)
    [(sn-list-depth (quote (x))) 1 1] ; (run-test sn-list-depth 2)
    [(sn-list-depth (quote (a (b (c (d)) e)))) 4 2] ; (run-test sn-list-depth 3)
    [(sn-list-depth (quote (((((1) 2) () 3) 4) 5))) 5 2] ; (run-test sn-list-depth 4)
    [(sn-list-depth (quote (a (b c) d))) 2 2] ; (run-test sn-list-depth 5)
    [(sn-list-depth '(())) 2 1] ; (run-test sn-list-depth 6)
    [(sn-list-depth '(((3) (( )) 2) (2 3) 1)) 4 1] ; (run-test sn-list-depth 7)
  )

  (bt-sum equal? ; (run-test bt-sum)
    [(bt-sum (quote (a (b 3 (c 2 1)) (d (e (f 4 5) 6) 7)))) 28 7] ; (run-test bt-sum 1)
    [(bt-sum 9) 9 3] ; (run-test bt-sum 2)
  )

  (bt-inorder equal? ; (run-test bt-inorder)
    [(bt-inorder (quote (a (b 3 (c 2 1)) (d (e (f 4 5) 6) 7)))) '(b c a f e d) 4] ; (run-test bt-inorder 1)
    [(bt-inorder 9) '() 2] ; (run-test bt-inorder 2)
    [(bt-inorder (quote (a (d (e 6 (f 4 5)) 7) (b 3 (c 2 1))))) '(e f d a b c) 4] ; (run-test bt-inorder 3)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
