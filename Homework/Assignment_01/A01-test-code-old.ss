; To use these tests:
;   load your 1.ss file into Scheme
;   load this file into Scheme
;   (r)

; If you find errors, fix them, reload 1.ss, and type (r) again.
  

; #1
(define (test-interval-contains?)
  (let ([correct '(#t #t #f #f #t)]
        [answers 
         (list (interval-contains? '(5 8) 6) 
               (interval-contains? '(5 8) 5)       
               (interval-contains? '(5 8) 4)
               (interval-contains? '(5 5) 14)
               (interval-contains? '(5 5) 5))])
    (display-results correct answers equal?)))

; #2
(define (test-interval-intersects?)
  (let ([correct '(#t #t #t #t #t #t #f #f)]
        [answers 
          (list
            (interval-intersects? '(1 4) '(2 5))
           	(interval-intersects? '(2 5) '(1 4))
           	(interval-intersects? '(1 4) '(4 5))
           	(interval-intersects? '(4 5) '(1 4))
           	(interval-intersects? '(2 5) '(1 14))
           	(interval-intersects? '(1 14) '(2 5))
           	(interval-intersects? '(1 3) '(12 17))
           	(interval-intersects? '(12 17) '(1 3)))])
    (display-results correct answers equal?)))


; #3
(define (test-interval-union)
  (let ([correct '(((1 6)) ((1 5)) ((1 6)) ((1 5)) ((1 5)) 
                   ((1 5) (15 25)) ((25 25) (5 5)) ((5 5)))]
        [answers 
          (list
            (interval-union '(1 5) '(2 6))
            (interval-union '(1 5) '(2 4))
            (interval-union '(2 6) '(1 5))
            (interval-union '(1 5) '(5 5))
            (interval-union '(5 5) '(1 5))
            (interval-union '(1 5) '(15 25))
            (interval-union '(5 5) '(25 25))
            (interval-union '(5 5) '(5 5)))])
    (display-results correct answers 
      (lambda (x y) (andmap set-equals? x y)))))
            

; #4
(define (test-first-second-third)
  (let ([correct '(a (b c) c)]
        [answers 
          (list
            (first '(a b c d e)) 
            (second '(a (b c) d e)) 
	        (third '(a b c d e)) 
	    )])
    (display-results correct answers equal?)))
	
; #5
(define (test-make-vec-from-points)
  (let ([correct '((2 3 -2) (4 -9 -2))]
        [answers 
          (list
            (make-vec-from-points '(1 3 4) '(3 6 2))
            (make-vec-from-points '(-1 3 4) '(3 -6 2)))])
    (display-results correct answers equal?)))

; #6
(define (test-dot-product)
  (let ([correct '(25 0)]
        [answers 
          (list
            (dot-product '(1 -3 5) '(2 4 7))
            (dot-product '(1 5 3) '(3 3 -6)))])
    (display-results correct answers equal?)))
	
; #7
(define (test-vector-magnitude)
  (let ([correct '(13 0)]
        [answers 
          (list
            (vector-magnitude '(3 -4 12))
            (vector-magnitude '(0 0 0)))])
    (display-results correct answers equal?)))

; #8
(define (test-distance)
  (let ([correct '(13 29 0)]
        [answers 
          (list
            (distance '(4 7 8) '(7 11 -4) )
            (distance '(3 1 2) '(15 -15 23))
	    (distance '(4 7 8) '(4 7 8)))])
    (display-results correct answers equal?)))
	
; SOme tests for procedures that were once part of Assignment 1, in case you want extra practice	
	
(define (test-divisible-by-7?)
  (let ([correct '(#f #t #t #f)]
        [answers 
          (list
            (divisible-by-7? 12)
            (divisible-by-7? 42) 
            (divisible-by-7? 0) 
            (divisible-by-7? 19))])
    (display-results correct answers equal?)))


(define (test-ends-with-7?)
  (let ([correct '(#f #t)]
        [answers 
          (list
            (ends-with-7? 172) 
            (ends-with-7? 4412368939284856837))])
    (display-results correct answers equal?)))



(define (test-cross-product)
    (let ([correct '((-18 10 -3) (0 0 0))]
          [answers 
            (list 
              (cross-product '(1 3 4) '(3 6 2)) 
              (cross-product '(1 2 3) '(2 4 6))
            )])
    (display-results correct answers equal?)))

;;--------  Procedures used by the testing mechanism   ------------------

(define display-results
  (lambda (correct results test-procedure?)
     (display ": ")
     (pretty-print 
      (if (test-procedure? correct results)
          'All-correct
          `(correct: ,correct yours: ,results)))))

(define set-equals?  ; are these list-of-symbols equal when
  (lambda (s1 s2)    ; treated as sets?
    (if (or (not (list? s1)) (not (list? s2)))
        #f
        (not (not (and (is-a-subset? s1 s2) (is-a-subset? s2 s1)))))))

(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))


;; You can run the tests individually, or run them all
;; by loading this file (and your solution) and typing (r)

(define (run-all)
  (display 'interval-contains?) 
  (test-interval-contains?)
  (display 'interval-intersects?) 
  (test-interval-intersects?)
  (display 'test-interval-union) 
  (test-interval-union)
  (display 'first-second-third)
  (test-first-second-third)
  (display 'test-make-vec-from-points) 
  (test-make-vec-from-points)
  (display 'dot-product) 
  (test-dot-product)  
  (display 'magnitude) 
  (test-vector-magnitude)  
  (display 'distance) 
  (test-distance)  
  )

(define r run-all)

