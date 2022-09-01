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
    [(null? (cdr list2)) #f] ; you don't match and there's only one interval
    [else (equal? list1 (list (cadr list2) (car list2)))]))

(define test (make-test ; (r)
  (interval-contains? equal? ; (run-test interval-contains?)
    [(interval-contains? '(5 8) 6) #t 1] ; (run-test interval-contains? 1)
    [(interval-contains? '(5 8) 5) #t 1] ; (run-test interval-contains? 2)
    [(interval-contains? '(5 8) 4) #f 1] ; (run-test interval-contains? 3)
    [(interval-contains? '(5 5) 14) #f 1] ; (run-test interval-contains? 4)
    [(interval-contains? '(5 5) 5) #t 1] ; (run-test interval-contains? 5)
  )

  (interval-intersects? equal? ; (run-test interval-intersects?)
    [(interval-intersects? '(1 4) '(2 5)) #t 1] ; (run-test interval-intersects? 1)
    [(interval-intersects? '(2 5) '(1 4)) #t 1] ; (run-test interval-intersects? 2)
    [(interval-intersects? '(1 4) '(4 5)) #t 1] ; (run-test interval-intersects? 3)
    [(interval-intersects? '(4 5) '(1 4)) #t 1] ; (run-test interval-intersects? 4)
    [(interval-intersects? '(2 5) '(1 14)) #t 1] ; (run-test interval-intersects? 5)
    [(interval-intersects? '(1 14) '(2 5)) #t 1] ; (run-test interval-intersects? 6)
    [(interval-intersects? '(1 3) '(12 17)) #f 1] ; (run-test interval-intersects? 7)
    [(interval-intersects? '(12 17) '(1 3)) #f 1] ; (run-test interval-intersects? 8)
  )

  (interval-union equal?-or-swapped ; (run-test interval-union)
    [(interval-union '(1 5) '(2 6)) '((1 6)) 1] ; (run-test interval-union 1)
    [(interval-union '(1 5) '(2 4)) '((1 5)) 1] ; (run-test interval-union 2)
    [(interval-union '(2 6) '(1 5)) '((1 6)) 1] ; (run-test interval-union 3)
    [(interval-union '(1 5) '(5 5)) '((1 5)) 1] ; (run-test interval-union 4)
    [(interval-union '(5 5) '(1 5)) '((1 5)) 1] ; (run-test interval-union 5)
    [(interval-union '(1 5) '(15 25)) '((1 5) (15 25)) 1] ; (run-test interval-union 6)
    [(interval-union '(5 5) '(25 25)) '((25 25) (5 5)) 1] ; (run-test interval-union 7)
    [(interval-union '(5 5) '(5 5)) '((5 5)) 1] ; (run-test interval-union 8)
  )

  (my-first equal? ; (run-test my-first)
    [(my-first '(a b c d e)) 'a 1] ; (run-test my-first 1)
  )

  (my-second equal? ; (run-test my-second)
    [(my-second '(a (b c) d e)) '(b c) 1] ; (run-test my-second 1)
  )

  (my-third equal? ; (run-test my-third)
    [(my-third '(a b c d e)) 'c 1] ; (run-test my-third 1)
  )

  (make-vec-from-points equal? ; (run-test make-vec-from-points)
    [(make-vec-from-points '(1 3 4) '(3 6 2)) '(2 3 -2) 3] ; (run-test make-vec-from-points 1)
    [(make-vec-from-points '(-1 3 4) '(3 -6 2)) '(4 -9 -2) 2] ; (run-test make-vec-from-points 2)
  )

  (dot-product equal? ; (run-test dot-product)
    [(dot-product '(1 -3 5) '(2 4 7)) 25 3] ; (run-test dot-product 1)
    [(dot-product '(1 5 3) '(3 3 -6)) 0 2] ; (run-test dot-product 2)
  )

  (vector-magnitude equal? ; (run-test vector-magnitude)
    [(vector-magnitude '(3 -4 12)) 13 3] ; (run-test vector-magnitude 1)
    [(vector-magnitude '(0 0 0)) 0 2] ; (run-test vector-magnitude 2)
  )

  (distance equal? ; (run-test distance)
    [(distance '(4 7 8) '(7 11 -4)) 13 2] ; (run-test distance 1)
    [(distance '(3 1 2) '(15 -15 23)) 29 2] ; (run-test distance 2)
    [(distance '(4 7 8) '(4 7 8)) 0 1] ; (run-test distance 3)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
