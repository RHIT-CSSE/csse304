#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "testcode-base.rkt")
(require "inclass-code.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
   (median-of-three equal? ; (run-test median-of-three)
    [(median-of-three 3 2 6) 3 1] ; (run-test  median-of-three 1)
    [(median-of-three 1 2 3) 2 1] ; (run-test  median-of-three 2)
    [(median-of-three 3 2 1) 2 1] ; (run-test  median-of-three 3)
    [(median-of-three 1 2 1) 1 1] ; (run-test  median-of-three 4)
  )

  (add-n-to-each equal? ; (run-test add-n-to-each)
    [(add-n-to-each 5 '()) '() 1] ; (run-test  add-n-to-each 1)
    [(add-n-to-each 4 '(3 5 7 9)) '(7 9 11 13) 1] ; (run-test  add-n-to-each 2)
  )

  (count-occurrences equal?
    [(count-occurrences 3 '()) 0 1]
    [(count-occurrences 2 '(2 3 2 4 2)) 3 1]
    [(count-occurrences 2 '(3 3 2 4 2)) 2 1]
    [(count-occurrences 2 '(2 3 2 4 3)) 2 1]
    [(count-occurrences 7 '(1 2 3 4 5)) 0 1])

  (remove-zeros equal?
    [(remove-zeros '(0 1 2 3)) '(1 2 3) 1]
    [(remove-zeros '(0 1 0 2 0 3 0)) '(1 2 3) 1]
    [(remove-zeros '(0 0 0 0)) '() 1])

  (sum-pairs equal?
    [(sum-pairs '(1 2 3 4)) '(3 7) 1]
    [(sum-pairs '(1 2 3 4 10 11 12)) '(3 7 21 12) 1]
    [(sum-pairs '()) '() 1]
    )

  (compress equal?
    [(compress '(a)) '(a 1) 1]
    [(compress '(b b b)) '(b 3) 1]
    [(compress '(a a a a b b b)) '(a 4 b 3) 1]
    [(compress '(a a b c c c a)) '(a 2 b 1 c 3 a 1) 1]
    [(compress '()) '() 1])
))

(implicit-run test) ; run tests as soon as this file is loaded
