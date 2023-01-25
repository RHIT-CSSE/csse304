#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "Exam2-202310.rkt")
(provide get-weights get-names individual-test test)

(require racket/trace)

(define test (make-test ; (r)
  (myfor equal?
         [(let ((x 0)) (myfor i 1 to 3 (set! x (+ x i))) x) 6 1]
         [(let ((y '())) (myfor j 2 to 5 (set! y (cons j y))) (reverse y)) '(2 3 4 5) 1]
         ; myfor with 2 bodies
         [(let ((x 0)) (myfor i 1 to 3 (set! x (+ x i)) (set! x (+ x i))) x) 12 1]
         )    
))

(implicit-run test) ; run tests as soon as this file is loaded
