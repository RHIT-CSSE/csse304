#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "Final-202220-imper.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)

              (qsort-imp equal? ; (run-test qsort-imp)
                 [(qsort-imp '(1)) '(1) 1] ; (run-test qsort-imp 1)
                 [(qsort-imp '(2 1)) '(1 2) 1] ; (run-test qsort-imp 2)
                 [(qsort-imp '(8 1 4 2 7 9 0)) '(0 1 2 4 7 8 9) 1] ; (run-test qsort-imp 3)
                 [(qsort-imp '(5 6 7 8 1 2 3 4)) '(1 2 3 4 5 6 7 8) 1] ; (run-test qsort-imp 4)
                 )

              
  ))

(implicit-run test) ; run tests as soon as this file is loaded
