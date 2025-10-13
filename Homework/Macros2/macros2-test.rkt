#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "macros2.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)

    (ifelse equal?
          [(list (ifelse #t 1 else 2) (ifelse #f 1 else 2)) '(1 2) 6]
          [(let ((v #t)) (list (ifelse v v else 2) (ifelse (not v) 1 else 2))) '(#t 2) 6]
          [(let ((v #t)) (list (ifelse v (set! v 1) (set! v (add1 v)) v else 2 6)
                               (ifelse (not v) 1 2 else 3 4 5 6))) '(2 6) 8]
)
    (let-destruct equal? ; (run-test let-destruct)          
    [(let-destruct a (+ 1 10) (+ 1 a)) 12 0.1] ; (run-test let-destruct 1)
    [(let-destruct () '() 'youll-want-this-base-case) 'youll-want-this-base-case 0.1]
    [(let-destruct (a) (list 10) (+ 1 a)) 11 0.1]
    [(let-destruct (a b) (cons 1 (cons 2 '())) (cons a b)) '(1 . 2) 0.1]
    [(let-destruct ((a) b) '((1) 2) (cons a b)) '(1 . 2) 0.1]
    [(let-destruct (a b) '((1) ((2))) (cons a b)) '((1) . ((2))) 0.1]
    [(let-destruct ((a) ((b)) (((c)))) '((1) ((2)) (((3)))) (list a b c)) '(1 2 3) 0.1]
    [(let-destruct ((a b) c) '((1 2) 3) (list a b c)) '(1 2 3) 0.1]
    [(let-destruct ((a b) c) '((1 2) 3) (list a b c) 'body2) 'body2 0.1]
    [(let ((myval '((1 2) (3 4) (5 (6)))))
       (let-destruct ((a b) c (d (e))) myval (list a b c d e))) '(1 2 (3 4) 5 6) 0.1]
  )

              

  ))


(implicit-run test) ; run tests as soon as this file is loaded
