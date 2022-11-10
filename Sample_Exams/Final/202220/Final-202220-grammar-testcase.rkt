#lang racket

;
; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "Final-202220-grammar.rkt")
(provide get-weights get-names individual-test test)


; this is some stuff for the lazy func test
(define mylist '())
(define reset-mylist (lambda () (set! mylist '())))
(define prepend-mylist (lambda (val) (set! mylist (cons val mylist)))) 

(define example-code
  (lambda ()
    (prepend-mylist 'a)
    (rest)
    (prepend-mylist 'b)
    (rest)
    (prepend-mylist 'c)
    'done))


(define test (make-test ; (r)

              (remove-double equal? ; (run-test remove-double)
                 [(remove-double '(a b c)) '((a b) c) 1] ; (run-test remove-double 1)
                 [(remove-double '((a b c) (a b c))) '(((a b) c) ((a b) c)) 1] ; (run-test remove-double 2)
                 [(remove-double '(lambda (x) (x y z))) '(lambda (x) ((x y) z)) 1] ; (run-test remove-double 3)
                 [(remove-double '((a b c) (d e f) (g h i))) '((((a b) c) ((d e) f)) ((g h) i)) 1] ; (run-test remove-double 4)
                 )

  ))

(implicit-run test) ; run tests as soon as this file is loaded
