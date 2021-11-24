#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A0.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
  (fact equal? ; (run-test fact)
    [(fact 0) 1 2] ; (run-test fact 1)
    [(fact 4) 24 1] ; (run-test fact 2)
    [(fact 6) 720 2] ; (run-test fact 3)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
