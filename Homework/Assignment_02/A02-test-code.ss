

(define (test-choose)
    (let ([correct '(1 3 210)]
          [answers 
            (list 
              (choose 0 0) 
              (choose 3 2)
              (choose 10 6)
            )])
      (display-results correct answers equal?)))


(define (test-sum-of-squares)
  (let ([correct '(84 0)]
        [answers 
          (list
            (sum-of-squares '(1 3 5 7)) 
            (sum-of-squares '()))])
    (display-results correct answers equal?)))

(define (test-range)
  (let ([correct '(() (0 1 2 3 4) (5 6 7 8) (25 26 27 28 29) (31) ())]
        [answers 
         (list (range 0 0) 
               (range 0 5)       
               (range 5 9)
	       (range 25 30)
               (range 31 32)
               (range 7 4))])
    (display-results correct answers equal?)))


(define (test-set?)
  (let ([correct '(#t #t #t #t #t #f #t #f)]
        [answers 
          (list
            (and (set? '()) (not (set? '(1 1))))
	    (and (set? '(1 2 3) ) (not (set? '(1 2 1))))
	    (and (set? '(1 (2 3) (3 2) 5)) (not (set? '(1 3 1 2)))) 
	    (and (not (set? '(1 (2 3) (3 2) 5 (3 2))))  (set? '())) 
	    (set? '(r o s e - h u l m a n))
	    (set? '(c o m p u t e r s c i e n c e))
	    (set? '((i) (a m) (a) (s e t)))
	    (set? '((i) (a m) (n o t) (a) (s e t) (a m) (i)))
	    )])
    (display-results correct answers equal?)))

(define (test-union)
    (let ([correct '((a b c d e f g h j) (a b c d e) (a b c) ())]
          [answers 
            (list 
	     (union '(a b d e f h j) '(f c e g a))
	     (union '(a b c) '(d e))
	     (union '(a b c) '())
	     (union '() '())
            )])
    (display-results correct answers set-equals?)))


(define (test-cross-product)
    (let ([correct '((-18 10 -3) (0 0 0))]
          [answers 
            (list 
              (cross-product '(1 3 4) '(3 6 2)) 
              (cross-product '(1 2 3) '(2 4 6))
            )])
      (display-results correct answers equal?)))


(define (test-parallel?)
  (let ([correct '(#f #t #t #t #f)]
        [answers 
          (list
	   (parallel? '(1 3 4) '(3 6 2))
	   (parallel? '(1 2 3) '(2 4 6))
	   (parallel? '(1 2 0) '(2 4 0))
	   (parallel? '(0 0 1) '(0 0 3))
	   (parallel? '(0 1 0) '(0 0 1))
	    )])
    (display-results correct answers equal?)))

(define (test-collinear?)
  (let ([correct '(#t #f)]
        [answers 
          (list
	   (collinear? '(1 2 3) '(4 5 6) '(10 11 12))
	   (collinear? '(1 2 3) '(4 5 6) '(10 11 13))
          )])
    (display-results correct answers equal?)))




;;-----------------------------------------------

(define display-results
  (lambda (correct results test-procedure?)
     (display ": ")
     (pretty-print 
      (if (andmap test-procedure? correct results)
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
  (display 'test-choose) 
  (test-choose)
  (display 'sum-of-squares) 
  (test-sum-of-squares)    
  (display 'range) 
  (test-range)
  (display 'set?) 
  (test-set?)
  (display 'union) 
  (test-union)
  (display 'cross-product) 
  (test-cross-product)
  (display 'test-parallel?) 
  (test-parallel?)
  (display 'collinear?) 
  (test-collinear?)
)

(define r run-all)


