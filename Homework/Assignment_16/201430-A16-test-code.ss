;; Test code for CSSE 304 Assignment 16

(define (test-primitive-procedures)
    (let ([correct '((#t #t)
		     (#t #t #t)
		     (#t #t #t #f)
		     (#t #t #f #t #t #f)
		     (3 4 5)
		     (#t 5)
		     5
		     (a b c)
		     (#t #t #f)
		     )]
          [answers 
            (list 
	     (eval-one-exp '
	      (list (procedure? +) 
		    (not (procedure? (+ 3 4)))))
	     (eval-one-exp ' 
	      (list (procedure? procedure?) 
		    (procedure? (lambda(x) x)) 
		    (not (procedure? '(lambda (x) x)))))
	     (eval-one-exp ' 
	      (list (procedure? list) 
		    (procedure? map) 
		    (procedure? apply) 
		    (procedure? #t)))
	     (eval-one-exp ' 
	      (map procedure? 
		   (list map car 3 (lambda(x) x) (lambda x x) ((lambda () 2)))))
	     (eval-one-exp '(apply list (list 3 4 5)))
	     (eval-one-exp ' (list (vector? (vector 3)) 
				   (vector-ref (vector 2 4 5) 
					       (vector-ref (vector 2 4 5) 0))))
	     (eval-one-exp '(length '(a b c d e)))
	     (eval-one-exp '(vector->list '#(a b c)))
	     (eval-one-exp ' (list (procedure? list) 
				   (procedure? (lambda (x y) 
						 (list (+ x y)))) 
				   (procedure? 'list)))

	     )])
      (display-results correct answers equal?)))

(define (test-lambda-regression-tests)
    (let ([correct '(
		     6
		     12
		     154
		     720
		     (#t #t #f)
		     )]
          [answers 
            (list 
	     (eval-one-exp '((lambda (x) (+ 1 x)) 5))
	     (eval-one-exp '((lambda (x) (+ 1 x) (+ 2 (* 2 x))) 5))
	     (eval-one-exp ' 
	      ((lambda (a b) 
		 (let ([a (+ a b)] 
		       [b (- a b)]) 
		   (let ([f (lambda (a) (+ a b))]) 
		     (f (+ 3 a b))))) 
	       56 
	       17))
	     (eval-one-exp ' 
	      (((lambda (f) 
		  ((lambda (x) 
		     (f (lambda (y) ((x x) y)))) 
		   (lambda (x) 
		     (f (lambda (y) ((x x) y)))))) 
		(lambda (g) 
		  (lambda (n) 
		    (if (zero? n) 1 (* n (g (- n 1))))))) 6))
	     (eval-one-exp ' 
	      (let ([Y (lambda (f) 
			 ((lambda (x) (f (lambda (y) ((x x) y)))) 
			  (lambda (x) (f (lambda (y) ((x x) y))))))] 
		    [H (lambda (g) (lambda (x) 
				     (if (null? x) '() 
					 (cons (procedure? (car x)) 
					       (g (cdr x))))))]) 
		((Y H) (list list (lambda (x) x) 'list))))
	     )])
      (display-results correct answers equal?)))

(define (test-lambda-with-variable-args)
    (let ([correct '(
		     (b c)
		     (9 2 1)
		     two
		     )]
          [answers 
            (list 
	     (eval-one-exp '((lambda x (car x) (cdr x)) 'a 'b 'c))
	     (eval-one-exp '((lambda (x y . z) 
			       (cons (+ x y) (cdr z))) 
			     5 4 3 2 1))
	     (eval-one-exp ' ((lambda (x y . z) 
				(if (> x y) 
				    (car z) 
				    (cdr z)) 
				(cadr z)) 5 4 'three 'two 'one))
	     )])
      (display-results correct answers equal?)))

(define (test-syntactic-expansion)
    (let ([correct '(
		     7
		     6
		     8
		     8
		     6
		     3
		     #f
		     #f
		     odd
		     even
		     out-of-range
		     (6)
		     (131072)
		     (3)
		     )]
          [answers 
            (list 
	     (eval-one-exp '(cond [(< 4 3) 8] [(< 2 3) 7] [else 8]))
	     (eval-one-exp '(cond [(< 4 3) 8] [(> 2 3) 7] [else 6]))
	     (eval-one-exp '(cond [(> 4 3) 8] [(< 2 3) 7] [else 6]))
	     (eval-one-exp '(cond [else 8]))
	     (eval-one-exp '(let ([a (vector 3)]) 
			      (cond [(= (vector-ref a 0) 4) 5] 
				    [(begin (vector-set! a 0 
					      (+ 1 (vector-ref a 0))) 
					    (= (vector-ref a 0) 4)) 6] 
				    [else 10])))
	     (eval-one-exp '(or #f #f 3 #f))
	     (eval-one-exp '(or #f #f #f))
	     (eval-one-exp '(or))
	     (eval-one-exp '(let ([x 4] [y 5]) 
			      (case (+ x y) 
				[(1 3 5 7 9) 'odd] 
				[(0 2 4 6 8) 'even] 
				[else 'out-of-range])))
	     (eval-one-exp '(let ([x 4] [y 2]) 
			      (case (+ x y) 
				[(1 3 5 7 9) 'odd] 
				[(0 2 4 6 8) 'even] 
				[else 'out-of-range])))
	     (eval-one-exp '(let ([x 4] [y 6]) 
			      (case (+ x y) 
				[(1 3 5 7 9) 'odd] 
				[(0 2 4 6 8) 'even] 
				[else 'out-of-range])))
	     (eval-one-exp ' (let ((a (list 5))) 
			       (if #t (begin (set-car! a 3) 
					     (set-car! a (+ 3 (car a))) a))))
	     (eval-one-exp '(let ([a (list 3)]) 
			      (while (< (car a) 100000) 
				     (set-car! a (* (car a) (car a))) 
				     (set-car! a (quotient (car a) 2))) 
			      a))
	     (eval-one-exp '(let ([a (list 3)]) 
			      (while (< (car a) 3) 
				     (set-car! a (* (car a) (car a))) 
				     (set-car! a (quotient (car a) 2))) 
			      a))
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
  (display 'primitive-procedures) 
  (test-primitive-procedures)
  (display 'lambda-regression-tests) 
  (test-lambda-regression-tests)
  (display 'lambda-with-variable-args) 
  (test-lambda-with-variable-args)
  (display 'syntactic-expansion) 
  (test-syntactic-expansion)    

)

(define r run-all)

