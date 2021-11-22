#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A01.rkt")
(provide get-weights get-names individual-test test)

(define (equal?-or-swapped list1 list2)
  (cond
    [(not (list? list1)) #f]
    [(not (= (length list1) (length list2))) #f]
    [(equal? list1 list2) #t]
    [else (equal? list1 (list (cadr list2) (car list2)))]))

(define test (make-test
  (interval-contains? equal?
    [(interval-contains? '(5 8) 6) #t 1]
    [(interval-contains? '(5 8) 5) #t 1]
    [(interval-contains? '(5 8) 4) #f 1]
    [(interval-contains? '(5 5) 14) #f 1]
    [(interval-contains? '(5 5) 5) #t 1]
  )

  (interval-intersects? equal?
    [(interval-intersects? '(1 4) '(2 5)) #t 1]
    [(interval-intersects? '(2 5) '(1 4)) #t 1]
    [(interval-intersects? '(1 4) '(4 5)) #t 1]
    [(interval-intersects? '(4 5) '(1 4)) #t 1]
    [(interval-intersects? '(2 5) '(1 14)) #t 1]
    [(interval-intersects? '(1 14) '(2 5)) #t 1]
    [(interval-intersects? '(1 3) '(12 17)) #f 1]
    [(interval-intersects? '(12 17) '(1 3)) #f 1]
  )

  (interval-union equal?-or-swapped
    [(interval-union '(1 5) '(2 6)) '((1 6)) 1]
    [(interval-union '(1 5) '(2 4)) '((1 5)) 1]
    [(interval-union '(2 6) '(1 5)) '((1 6)) 1]
    [(interval-union '(1 5) '(5 5)) '((1 5)) 1]
    [(interval-union '(5 5) '(1 5)) '((1 5)) 1]
    [(interval-union '(1 5) '(15 25)) '((1 5) (15 25)) 1]
    [(interval-union '(5 5) '(25 25)) '((25 25) (5 5)) 1]
    [(interval-union '(5 5) '(5 5)) '((5 5)) 1]
  )

  (first-second-third equal?
    [(my-first '(a b c d e)) 'a 1]
    [(my-second '(a (b c) d e)) '(b c) 1]
    [(my-third '(a b c d e)) 'c 1]
  )

  (make-vec-from-points equal?
    [(make-vec-from-points '(1 3 4) '(3 6 2)) '(2 3 -2) 1]
    [(make-vec-from-points '(-1 3 4) '(3 -6 2)) '(4 -9 -2) 1]
  )

  (dot-product equal?
    [(dot-product '(1 -3 5) '(2 4 7)) 25 1]
    [(dot-product '(1 5 3) '(3 3 -6)) 0 1]
  )

  (vector-magnitude equal?
    [(vector-magnitude '(3 -4 12)) 13 1]
    [(vector-magnitude '(0 0 0)) 0 1]
  )

  (distance equal?
    [(distance '(4 7 8) '(7 11 -4) ) 13 1]
    [(distance '(3 1 2) '(15 -15 23)) 29 1]
    [(distance '(4 7 8) '(4 7 8)) 0 1]
  )
))
