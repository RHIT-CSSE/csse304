#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A04.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
              (pop-song?
               equal?
               [(pop-song? '(verse refrain refrain)) #t 2]
               [(pop-song? '(verse refrain verse refrain refrain)) #t 2]
               [(pop-song? '(verse refrain verse refrain verse refrain verse refrain refrain)) #t 2]
               [(pop-song? '(verse guitar-solo refrain guitar-solo guitar-solo verse refrain verse guitar-solo guitar-solo refrain verse refrain refrain)) #t 2]
               [(pop-song? '(verse refrain)) #f 2]
               [(pop-song? '(refrain refrain)) #f 2]
               [(pop-song? '(verse verse refrain refrain)) #f 2]
               [(pop-song? '(guitar-solo verse refrain refrain)) #f 2]
               [(pop-song? '(verse refrain refrain guitar-solo)) #f 2]
               [(pop-song? '(verse refrain guitar-solo refrain)) #t 2]
               )
                (running-sum
                 equal? ; (run-test running-sum)
                 [(running-sum '(1 2)) '(1 3) 3] ; (run-test running-sum 1)
                 [(running-sum '(2 20 200 2000)) '(2 22 222 2222) 3]
                 [(running-sum '(2 4 8 16)) '(2 6 14 30) 4]
                 )

                (invert
                 equal? ; (run-test invert)
                 [(invert '((1 2) (3 4) (5 6))) '((2 1) (4 3) (6 5)) 6] ; (run-test invert 1)
                 [(invert '()) '() 4] ; (run-test invert 2)
                 )
                (combine-consec
                 equal? ; (run-test combine-consec)
                 [(combine-consec '(1 5)) '((1 1) (5 5)) 4] ; (run-test combine-consec 1)
                 [(combine-consec '(1 2 3 4 5)) '((1 5)) 5] ; (run-test combine-consec 2)
                 [(combine-consec '(1 2 3 4 5 7 8 9)) '((1 5) (7 9)) 5] ; (run-test combine-consec 3)
                 [(combine-consec '(1 2 4 7 8 9 20)) '((1 2) (4 4) (7 9) (20 20)) 5] ; (run-test combine-consec 4)
                 [(combine-consec '()) '() 1] ; (run-test combine-consec 5)                  
                 )

))

(implicit-run test) ; run tests as soon as this file is loaded
