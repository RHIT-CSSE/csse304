#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A04.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test
  (matrix-ref equal?
    [(matrix-ref '((1 2 3 4 5) (4 3 2 1 5) (5 4 3 2 1)) 2 3) 2 1]
    [(matrix-ref '((1 2 3 4) (4 3 2 1)) 1 1) 3 1]
    [(matrix-ref '((1 2 3 4 5) (4 3 2 1 5) (5 4 3 2 1)) 0 4) 5 1]
  )

  (matrix? equal?
    [(matrix? 5) #f 2]
    [(matrix? "matrix") #f 1]
    [(matrix? matrix?) #f 2]
    [(matrix? '(1 2 3)) #f 2]
    [(matrix? '((1 2 3) (5 a 4))) #f 2]
    [(matrix? '((1.5 2 3)(4 5.7 6))) #t 1]
    [(matrix? '#((1 2 3)(4 5 6))) #f 1]
    [(matrix? '((1 2 3)(4 5 6)(7 8))) #f 1]
    [(matrix? '((1))) #t 1]
    [(matrix? '((1) (2) (3) (4))) #t 1]
    [(matrix? '(()()())) #f 1]
  )

  (matrix-transpose equal?
    [(matrix-transpose '((1 2 3) (4 5 6))) '((1 4) (2 5) (3 6)) 4]
    [(matrix-transpose '((1 2 3))) '((1) (2) (3)) 3]
    [(matrix-transpose '((1) (2) (3))) '((1 2 3)) 3]
  )

  (filter-in equal?
    [(filter-in positive? '(-1 2 0 3 -6 5)) '(2 3 5) 3]
    [(filter-in null? '(() (1 2) (3 4) () ())) '(() () ()) 1]
    [(filter-in list? '(() (1 2) (3 . 4) #2(4 5))) '(() (1 2)) 2]
    [(filter-in pair? '(() (1 2) (3 . 4) #2(4 5))) '((1 2) (3 . 4)) 2]
    [(filter-in positive? '()) '() 2]
  )

  (invert equal?
    [(invert '((1 2) (3 4) (5 6))) '((2 1) (4 3) (6 5)) 6]
    [(invert '()) '() 4]
  )

  (pascal-triangle equal?
    [(pascal-triangle 4) '((1 4 6 4 1) (1 3 3 1) (1 2 1) (1 1) (1)) 6]
    [(pascal-triangle 12) '((1 12 66 220 495 792 924 792 495 220 66 12 1) (1 11 55 165 330 462 462 330 165 55 11 1) (1 10 45 120 210 252 210 120 45 10 1) (1 9 36 84 126 126 84 36 9 1) (1 8 28 56 70 56 28 8 1) (1 7 21 35 35 21 7 1) (1 6 15 20 15 6 1) (1 5 10 10 5 1) (1 4 6 4 1) (1 3 3 1) (1 2 1) (1 1) (1)) 10]
    [(pascal-triangle 0) '((1)) 2]
    [(pascal-triangle -3) '() 2]
  )
))
