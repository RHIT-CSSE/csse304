;; Test code for exam 1 202020


(define (test-prefix-sums)
  (let ([correct '(
		   (4)
		   (1 4 9 11)
		   (1 3 6 10 15 21)
		   (3 5 5 0 6)
		   )]
        [answers 
         (list 
	  (prefix-sums '(4))
	  (prefix-sums '(1 3 5 2))
	  (prefix-sums '(1 2 3 4 5 6))
	  (prefix-sums '(3 2 0 -5 6))
	  )])
      (display-results correct answers equal?)))

(define (test-suffix-sums)
    (let ([correct '(
		     (4)
		     (11 10 7 2)
		     (21 20 18 15 11 6)
		     (6 3 1 1 6)
		     )]
          [answers 
            (list 
	     (suffix-sums '(4))
	     (suffix-sums '(1 3 5 2))
	     (suffix-sums '(1 2 3 4 5 6))
	     (suffix-sums '(3 2 0 -5 6))
	     )])
      (display-results correct answers equal?)))
(define (test-evens-odds)
    (let ([correct '(
		     (() ())
		     ((b) ())
		     ((c) (d))
		     ((a c e g) (b d f))
		     ((b d f) (c e g))
		     )]
          [answers 
            (list 	   
	     (evens-odds '())
	     (evens-odds '(b))
	     (evens-odds '(c d))
	     (evens-odds '(a b c d e f g))
	     (evens-odds '(b c d e f g))
	     )])
      (display-results correct answers equal?)))

(define (test-notate-depth-and-flatten)
    (let ([correct '(
		     ()
		     ((a 1) (b 3))
		     ((a 2) (b 3) (c 3) (d 4) (e 1))
		     )]
          [answers 
            (list 
	     (notate-depth-and-flatten '())
	     (notate-depth-and-flatten '(a ((b))))
	     (notate-depth-and-flatten '((a () (b c (() d))) e))
	     )])
      (display-results correct answers equal?)))


(define (test-free-occurrence-count)
    (let ([correct '(
		     3
		     1
		     4
		     0
		     5
		     )]
          [answers 
            (list 
	     (free-occurrence-count '(x (x y)))
	     (free-occurrence-count
	      '(lambda (x) (lambda (x) (x y))))
	     (free-occurrence-count
	      '(lambda (x)
		 (lambda (w) (x ((x z) (y ((x y) (y w))))))))
	     (free-occurrence-count
	      '(lambda (x) (lambda (y) (x (x (y y))))))
	     (free-occurrence-count '((lambda (x) (y (lambda (y) (x y))))
				      (lambda (y) ((x x) (lambda (x)
							   ((z z) (y (x x))))))))
	     )])
      (display-results correct answers equal?)))

(define (test-curry)
    (let ([correct '(
		     13
		     (4 5 6)
		     1
		     56
		     78
		     )]
          [answers 
            (list 
	     (let ([+-c (curry 3 +)])
	       (((+-c 2) 4) 7))
	     (let ([cons-c (curry 2 cons)])
	       ((cons-c 4) '(5 6)))
	     (let ([car-c (curry 1 car)])
	       (car-c '(1 2 3)))
	     (let ([+-c (curry 7 +)])
	       (((((((+-c 2) 4) 6) 8) 10) 12) 14))
	     (let ([+-c (curry 12 +)])
	       ((((((((((((+-c 1) 2) 3) 4) 5) 6) 7) 8) 9) 10) 11) 12))
	     )])
      (display-results correct answers equal?)))




;-----------------------------------------------

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

(define find-edges  ; e know that this node is in the graph before we do the call
  (lambda (graph node)
    (let loop ([graph graph])
      (if (eq? (caar graph) node)
	  (cadar graph)
	  (loop (cdr graph))))))

;; Problem 8  graph?
(define set?  ;; Is this list a set?  If not, it is not a graph.
  (lambda (list)
    (if (null? list) ;; it's an empty set.
	#t
	(if (member (car list) (cdr list))
	    #f
	    (set? (cdr list))))))


(define graph?
  (lambda (obj)
    (and (list? obj)
	 (let ([syms (map car obj)])
	   (and (set? syms)
		(andmap symbol? syms)
		(andmap (lambda (x)
			  (andmap (lambda (y) (member y (remove (car x) syms)))
				  (cadr x)))
			obj))))))
    
(define graph-equal?
  (lambda (a b)
    (and
     (graph? a) 
     (graph? b)
     (let ([a-nodes (map car a)]
	   [b-nodes (map car b)])
       (and 
	(set-equals? a-nodes b-nodes)
	    ; Now  See if the edges from each node are equivalent in the two graphs.
	(let loop ([a-nodes a-nodes])
	  (if (null? a-nodes)
	      #t
	      (let ([a-edges (find-edges a (car a-nodes))]
		    [b-edges (find-edges b (car a-nodes))])
		(and (set-equals? a-edges b-edges)
		     (loop (cdr a-nodes)))))))))))

(define (test-graph-equal)
  (list
   (graph-equal? '((a (b)) (b (a))) '((b (a)) (a (b))))
   (graph-equal? '((a (b c d)) (b (a c d)) (c (a b d)) (d (a b c)))
		 '((b (a c d)) (c (a b d)) (a (b d c)) (d (b a c))))
   (graph-equal? '((a ())) '((a ())))
   (graph-equal? '((a (b c)) (b (a c)) (c (a b))) '((a (b c)) (b (a c)) (c (a b))))
   (graph-equal? '() '())
   ))



(define g test-graph-equal)
	   
	  
     



;You can run the tests individually, or run them all
;#by loading this file (and your solution) and typing (r)

(define (run-all)
  (display 'prefix-sums) 
  (test-prefix-sums)
  (display 'suffix-sums) 
  (test-suffix-sums)
  (display 'evens-odds) 
  (test-evens-odds)
  (display 'notate-depth-and-flatten) 
  (test-notate-depth-and-flatten)    
  (display 'free-occurrence-count) 
  (test-free-occurrence-count)
  (display 'curry) 
  (test-curry)  
)

(define r run-all)

