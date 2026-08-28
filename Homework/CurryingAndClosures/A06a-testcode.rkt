#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A06.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
  (curry2 equal? ; (run-test curry2)
    [(((curry2 -) 8) 2) 6 6] ; (run-test curry2 1)
    [(let((conscurry (curry2 cons))) ((conscurry 17) 29)) '(17 . 29) 4] ; (run-test curry2 2)
  )

  (curried-compose equal? ; (run-test curried-compose)
    [(((curried-compose car) list) 'arg) 'arg 5] ; (run-test curried-compose 1)
    [(((curried-compose car) car) '((1 7) (2 9))) 1 5] ; (run-test curried-compose 2)
  )

  (compose equal? ; (run-test compose)
    [((compose car car) '((1 7) (2 9))) 1 4] ; (run-test compose 1)
    [((compose car car cdr) '((1 7) (2 9))) 2 6] ; (run-test compose 2)
  )

  (make-list-c equal? ; (run-test make-list-c)
    [((make-list-c 4) 7) '(7 7 7 7) 4] ; (run-test make-list-c 1)
    [((make-list-c 5) '()) '(() () () () ()) 3] ; (run-test make-list-c 2)
    [((make-list-c 0) 10) '() 3] ; (run-test make-list-c 3)
  )

  (reverse-it equal? ; (run-test reverse-it)
    [(reverse-it '()) '() 1] ; (run-test reverse-it 1)
    [(reverse-it '(1)) '(1) 2] ; (run-test reverse-it 2)
    [(reverse-it '(1 2 3 4 5)) '(5 4 3 2 1) 7] ; (run-test reverse-it 3)
  )

  (map-by-position equal? ; (run-test map-by-position)
    [(map-by-position (list cadr - length add1 (lambda(x)(- x 3))) '((1 2) -2 (3 4) 1 5)) '(2 2 2 2 2) 10] ; (run-test map-by-position 1)
  )

  (BST equal? ; (run-test BST)
    [(empty-BST? (empty-BST)) #t 1] ; (run-test BST 1)
    [(BST-inorder (empty-BST)) '() 1] ; (run-test BST 2)
    [(BST-inorder (BST-insert 1 (empty-BST))) '(1) 1] ; (run-test BST 3)
    [(BST-inorder (BST-insert 1 (BST-insert 2 (empty-BST)))) '(1 2) 2] ; (run-test BST 4)
    [(BST-inorder (BST-insert 2 (BST-insert 1 (BST-insert 3 (empty-BST))))) '(1 2 3) 2] ; (run-test BST 5)
    [(BST-inorder (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 8))) '(1 3 4 5 6 7 8 9) 3] ; (run-test BST 6)
    [(BST-inorder (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 6 8))) '(1 3 4 5 6 7 8 9) 3] ; (run-test BST 7)
    [(BST-element (BST-left (BST-right (BST-right (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 8)))))) 8 5] ; (run-test BST 8)
    [all-or-nothing 1 ; (run-test BST 9)
      ((BST-contains? (empty-BST) 1) #f)
      ((BST-contains? (BST-insert 1 (empty-BST)) 1) #t)]
    [all-or-nothing 1 ; (run-test BST 10)
      ((BST-contains? (empty-BST) 1) #f)
      ((BST-contains? (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 8)) 8) #t)]
    [all-or-nothing 2 ; (run-test BST 11)
      ((BST-contains? (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 8)) 10) #f)
      ((BST-contains? (BST-insert 1 (empty-BST)) 1) #t)]
    [all-or-nothing 1 ; (run-test BST 12)
      ((BST-contains? (empty-BST) 1) #f)
      ((BST-contains? (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 8)) 1) #t)]
    [all-or-nothing 1 ; (run-test BST 13)
      ((BST-contains? (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 8)) 2) #f)
      ((BST-contains? (BST-insert 1 (empty-BST)) 1) #t)]
    [all-or-nothing 1 ; (run-test BST 14)
      ((BST-contains? (empty-BST) 1) #f)
      ((BST-contains? (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 8)) 4) #t)]
    [all-or-nothing 1 ; (run-test BST 15)
      ((BST-contains? (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 8)) 0) #f)
      ((BST-contains? (BST-insert 1 (empty-BST)) 1) #t)]
    [all-or-nothing 1 ; (run-test BST 16)
      ((BST? #t) #f)
      ((BST? '()) #t)]
    [all-or-nothing 1 ; (run-test BST 17)
      ((BST? '(1)) #f)
      ((BST? '()) #t)]
    [all-or-nothing 1 ; (run-test BST 18)
      ((BST? '(1 2 3)) #f)
      ((BST? '()) #t)]
    [all-or-nothing 2 ; (run-test BST 19)
      ((BST? '(1 ())) #f)
      ((BST? '()) #t)]
    [all-or-nothing 1 ; (run-test BST 20)
      ((BST? '(1 () ())) #t)
      ((BST? '()) #t)]
    [all-or-nothing 1 ; (run-test BST 21)
      ((BST? '(a () ())) #f)
      ((BST? '()) #t)]
    [all-or-nothing 2 ; (run-test BST 22)
      ((BST? '(1 (2 () ()) ())) #f)
      ((BST? '()) #t)]
    [all-or-nothing 2 ; (run-test BST 23)
      ((BST? #t) #f)
      ((BST? '(1 () (3 (2 () ()) ()))) #t)]
    [all-or-nothing 2 ; (run-test BST 24)
      ((BST? '(4 () (6 (3 () ()) ()))) #f)
      ((BST? '()) #t)]
    [(let ((t (BST-insert 2 (BST-insert 1 (BST-insert 3 (empty-BST)))))) (list (BST-height t) (BST-inorder t))) '(2 (1 2 3)) 2] ; (run-test BST 25)
    [(let ((t (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 8)))) (list (BST-height t) (BST-inorder t))) '(3 (1 3 4 5 6 7 8 9)) 2] ; (run-test BST 26)
    [(let ((t (BST-insert-nodes (empty-BST) '(10 3 19 18 14 17 16 15)))) (list (BST-height t) (BST-inorder t))) '(6 (3 10 14 15 16 17 18 19)) 2] ; (run-test BST 27)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
