
(define (test-intersection)
  (let ([correct '((i h) () () ())]
        [answers 
          (list
	   (intersection '(a b d e f h i j) '(h q r i z))
	   (intersection '(g h i) '(j k l))
	   (intersection '(a p t) '())
	   (intersection '() '(g e t))
	  )])
    (display-results correct answers set-equals?)))

(define (test-subset?)
  (let ([correct ' (#t #f #f #t #t #t #t)]
        [answers 
          (list
	    (subset? '(c b) '(a d b e c))
	    (subset? '(c b) '(a d b e))
	    (subset? '(c b) '())
	    (subset? '(c b) '(b c))
	    (subset? '(1 3 4) '(1 2 3 4 5))
	    (subset? '() '())
	    (subset? '() '(x y))
	  )])
    (display-results correct answers equal?)))

(define (test-relation?)
  (let ([correct '(#f #t #t #t #f #f #f #f )]
        [answers 
          (list
	   (relation? 5) 
	   (relation? '())
	   (relation? '((a b) (b c))) 
	   (relation? '((a b) (b a) (a a) (b b))) 
	   (relation? '((a b) (b c d))) 
	   (relation? '((a b) (c d) (a b))) 
	   (relation? '((a b) (c d) "5")) 
	   (relation? '((a b) . (b c))) 
	  )])
    (display-results correct answers equal?)))

(define (test-domain)
  (let ([correct '((2 3 1) ())]
        [answers 
          (list
	    (domain '((1 2) (3 4) (1 3) (2 7) (1 6)))
	    (domain '())
	  )])
    (display-results correct answers set-equals?)))

(define (test-reflexive?)
  (let ([correct '(#t #t #t #t #t)]
        [answers 
          (list
	   (reflexive? '((a a) (b b) (c d) (b c) (c c) (e e) (c a) (d d)))
           (not (reflexive? '((a a) (b b) (c d) (b c) (e e) (c a) (d d))))
           (not (reflexive? '((a a) (c d) (b c) (c c) (e e) (c a) (d d))))
	   (reflexive? '())
	   (not (reflexive? '((c c) (b b) (c d) (b c) (e e) (c a) (d d))))
	   )])
    (display-results correct answers eq?)))




(define (test-multi-set?)
  (let ([correct '(#t #t #t #t #t #t #t #t #t #t)]
        [answers 
          (list
	   (and (multi-set? '())
		(not (multi-set? '(a b))))
	   (and (multi-set? '((a 2)))
		(not (multi-set? '((a -1)))))
	   (and (multi-set? '((a 2)(b 3)))
		(not (multi-set? '((a 2) (a 3)))))
	   (and (not (multi-set? '(a b))) 
		(not (multi-set? '((a 3) b))))
	   (and (not (multi-set? '((a 2) (2 3))))
		(multi-set? '((a 2)))
		(not (multi-set? '(#(a 3)))))
	   (and (multi-set? '())
		(not (multi-set? '((a 3) b))))
	   (and (multi-set? '())
		(not (multi-set? '((a 3.7)))))
	   (and (multi-set? '())
		(not (multi-set? 5))
		(not (multi-set? '((a 2) (b 3) (a 1)))))
	   (and (multi-set? '())
		(not (multi-set? (list (cons 'a 2))))
		(not (multi-set? '((a 2) (a 3)))))
	   (and (multi-set? '((a 3)))
		(not (multi-set? '((a b) (c d)))))
	   )])
    (display-results correct answers equal?)))

(define (test-ms-size)
  (let ([correct '(0 2 5)]
        [answers 
          (list
	   (ms-size '())
	   (ms-size '((a 2)))
	   (ms-size '((a 2)(b 3)))
	   )])
    (display-results correct answers equal?)))

(define (test-last)
  (let ([correct '( 4 c (()()))]
        [answers 
          (list
	   (last '(1 5 2 4))
	   (last '(c)) 
	   (last '(() (()) (()())))
	  )])
    (display-results correct answers equal?)))

(define (test-all-but-last)
  (let ([correct '((1 5 2) () (() (())))]
        [answers 
          (list
	   (all-but-last '(1 5 2 4))
	   (all-but-last '(c)) 
	   (all-but-last '(() (()) (()())))	   
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
    (if (or (not (is-a-set? s1)) (not (is-a-set? s2)))
        #f
        (not (not (and (is-a-subset? s1 s2) (is-a-subset? s2 s1)))))))

(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))

(define is-a-set?
  (lambda (s)
    (cond [(null? s) #t]
          [(not (list? s)) #f]
          [(member (car s) (cdr s)) #f]
          [else (is-a-set? (cdr s))])))



;; You can run the tests individually, or run them all
;; by loading this file (and your solution) and typing (r)

(define (run-all)
  (display 'intersection) 
  (test-intersection)
  (display 'subset?) 
  (test-subset?)  
  (display 'relation?) 
  (test-relation?)  
  (display 'domain) 
  (test-domain)  
  (display 'reflexive?) 
  (test-reflexive?)
  (display 'multi-set?) 
  (test-multi-set?)
  (display 'ms-size)
  (test-ms-size)
  (display 'last) 
  (test-last)  
  (display 'all-but-last) 
  (test-all-but-last) 
)

(define r run-all)

