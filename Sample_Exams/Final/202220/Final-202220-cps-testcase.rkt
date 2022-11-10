#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "Final-202220-cps.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)

              (sel-sort-d-cps equal? ; (run-test sel-sort-d-cps)
                 [(sel-sort-d-cps '(1) (init-k)) '(1) 1] ; (run-test sel-sort-d-cps 1)
                 [(sel-sort-d-cps '(2 1) (init-k)) '(1 2) 1] ; (run-test sel-sort-d-cps 2)
                 [(sel-sort-d-cps '(8 1 4 2 7 9 0) (init-k)) '(0 1 2 4 7 8 9) 1] ; (run-test sel-sort-d-cps 3)
                 [(sel-sort-d-cps '(5 6 7 8 1 2 3 4) (init-k)) '(1 2 3 4 5 6 7 8) 1] ; (run-test sel-sort-d-cps 4)
                 )
              
  ))

(implicit-run test) ; run tests as soon as this file is loaded
