

(define (test-matrix-ref)
  (let ([correct '(2 3 5)]
        [answers 
          (list
	   (matrix-ref '((1 2 3 4 5) (4 3 2 1 5) (5 4 3 2 1))  2 3)
	   (matrix-ref '((1 2 3 4) (4 3 2 1))  1 1)
	   (matrix-ref '((1 2 3 4 5) (4 3 2 1 5) (5 4 3 2 1))  0 4)
          )])
    (display-results correct answers equal?)))

(define (test-matrix?)
  (let ([correct '(#f #f #f #f #f #t #f #f #t #t #f)]
        [answers 
	 (list
	  (matrix? 5)
	  (matrix? "matrix")
	  (matrix? matrix?)
	  (matrix? '(1 2 3))
	  (matrix? '((1 2 3) (5 a 4)))
	  (matrix? '((1.5 2 3)(4 5.7 6)))
	  (matrix? '#((1 2 3)(4 5 6)))
	  (matrix? '((1 2 3)(4 5 6)(7 8)))
	  (matrix? '((1)))
	  (matrix? '((1) (2) (3) (4)))
	  (matrix? '(()()()))
	 )])
    (display-results correct answers equal?)))

            
(define (test-matrix-transpose)
  (let ([correct '(((1 4) (2 5) (3 6)) ((1) (2) (3)) ((1 2 3)))]
        [answers 
          (list
	   (matrix-transpose '((1 2 3) (4 5 6)))
	   (matrix-transpose '((1 2 3)))
	   (matrix-transpose '((1) (2) (3)))
	  )])
    (display-results correct answers equal?)))


(define (test-filter-in)
  (let ([correct '(
		   (2 3 5)
		   (() () ())
		   (() (1 2))
		   ((1 2) (3 . 4))
		   ()
		   )]
        [answers 
          (list
	   (filter-in positive? '(-1 2 0 3 -6 5))
	   (filter-in null? '(() (1 2) (3 4) () ()))
	   (filter-in list? '(() (1 2) (3 . 4) #2(4 5)))
	   (filter-in pair? '(() (1 2) (3 . 4) #2(4 5)))
	   (filter-in positive? '())	  
	   )])
     (display-results correct answers equal?)))




(define (test-invert)
    (let ([correct '(
		     ((2 1) (4 3) (6 5))
		     ()
		     )]
          [answers 
            (list 
	     (invert '((1 2) (3 4) (5 6)))
	     (invert '())
	     )])
      (display-results correct answers equal?)))



(define (test-pascal-triangle)
  (let ([correct '(
		   ((1 4 6 4 1) (1 3 3 1) (1 2 1) (1 1) (1))
		   ((1 12 66 220 495 792 924 792 495 220 66 12 1)
		    (1 11 55 165 330 462 462 330 165 55 11 1)
		    (1 10 45 120 210 252 210 120 45 10 1)
		    (1 9 36 84 126 126 84 36 9 1)
		    (1 8 28 56 70 56 28 8 1)
		    (1 7 21 35 35 21 7 1)
		    (1 6 15 20 15 6 1)
		    (1 5 10 10 5 1)
		    (1 4 6 4 1)
		    (1 3 3 1)
		    (1 2 1)
		    (1 1)
		    (1))
		   ((1))
		   ()
		   )]
        [answers 
	 (list
	  (pascal-triangle 4)
	  (pascal-triangle 12)
	  (pascal-triangle 0)
	  (pascal-triangle -3)
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

(define sequal?-grading
  (lambda (l1 l2)
    (cond
     ((null? l1) (null? l2))
     ((null? l2) (null? l1))
     ((or (not (set?-grading l1))
          (not (set?-grading l2)))
      #f)
     ((member (car l1) l2) (sequal?-grading
                            (cdr l1)
                            (rember-grading
                             (car l1)
                             l2)))
     (else #f))))

(define set?-grading
  (lambda (s)
    (cond [(null? s) #t]
          [(not (list? s)) #f]
          [(member (car s) (cdr s)) #f]
          [else (set?-grading (cdr s))])))

(define rember-grading
  (lambda (a ls)
    (cond
     ((null? ls) ls)
     ((equal? a (car ls)) (cdr ls))
     (else (cons (car ls) (rember-grading a (cdr ls)))))))

(define set-equals? sequal?-grading)




;; You can run the tests individually, or run them all
;; by loading this file (and your solution) and typing (r)

(define (run-all)
  (display 'matrix-ref) 
  (test-matrix-ref)
  (display 'matrix?) 
  (test-matrix?)    
  (display 'matrix-transpose) 
  (test-matrix-transpose)
  (display 'filter-in) 
  (test-filter-in)  
  (display 'invert ) 
  (test-invert )
  (display 'pascal-triangle) 
  (test-pascal-triangle)    
)

(define r run-all)

