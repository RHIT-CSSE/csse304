;; Test code for CSSE 304 problems removed from Assignment 15



(define (test-intersection-cps)
    (let ([correct '(
		     (b c e)
		     ((b c e))
		     3
		     )]
          [answers 
            (list 
	     (intersection-cps (quote (a b c d e)) (quote (f e t b c)) (lambda (x) x))
	     (intersection-cps (quote (a b c d e)) (quote (f e t b c)) list)
	     (intersection-cps (quote (a b c)) (quote (d e f)) (lambda (x) (if (null? x) 3 4)))
	     )])
      (display-results correct answers equal?)))


(define (test-matrix?-cps)
    (let ([correct '(
		     #t
		     #t
		     #t
		     #t
		     #f
		     #t
		     #f
		     #t
		     #t
		     #t
		     #t
		     (#f #t)
		     )]
          [answers 
            (list 
	     (matrix?-cps (quote (())) not)
	     (matrix?-cps (quote ()) not)
	     (matrix?-cps (quote ((a b) (1 2 3))) not)
	     (matrix?-cps (quote ((a b 3 4) (1 2 3))) not)
	     (matrix?-cps (quote ((a b) (1 2) (1 2))) not)
	     (matrix?-cps (quote ((a b) (1 2) (1 2))) (lambda (x) x))
	     (matrix?-cps (quote ((a b) (1 2 v) (1 2))) (lambda (x) x))
	     (matrix?-cps (quote ((a b) (1 2))) (lambda (x) x))
	     (matrix?-cps (quote ((a))) (lambda (x) x))
	     (matrix?-cps (quote ((a b 5) (1 2 3) (1 3 v))) (lambda (x) x))
	     (matrix?-cps (quote ((a b 3 3) (1 2 q q) (6 5 4 3) (1 0 1 0))) (lambda (x) x))
	     (matrix?-cps (quote ((a b 3 3) (1 2 q q) (6 5 4) (1 0 1 0))) 
			  (lambda (x) (matrix?-cps (quote ((3))) 
						   (lambda (y) 
						     (list x y)))))
	     )])
      (display-results correct answers equal?)))

(define (test-andmap-cps)
    (let ([correct '(
		     (#t)
		     (#f)
		     (#t)
		     #t
		     (#f 4)
		     )]
          [answers 
            (list 
	     (andmap-cps (make-cps number?) (quote (2 3 4 5)) list)
	     (andmap-cps (make-cps number?) (quote (2 3 a 5)) list)
	     (andmap-cps (lambda (L k) (member?-cps (quote a) L k)) (quote ((b a) (c b a))) list)
	     (andmap-cps (lambda (L k) (member?-cps (quote a) L k)) (quote ((b a) (c b))) not)
	     (let ([t 0]) 
	       (andmap-cps (lambda (x k) 
			     (set! t (+ 1 t)) (k x)) 
			   (quote (#t #t #t #f #t)) 
			   (lambda (v) (list v t))))
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
  (display 'member?-cps) 
  (test-member?-cps )
  (display 'set?-cps) 
  (test-set?-cps)
  (display 'intersection-cps) 
  (test-intersection-cps)
  (display 'make-cps) 
  (test-make-cps)    
  (display 'andmap-cps) 
  (test-andmap-cps)  
   display 'matrix?-cps) 
  (test-matrix?-cps)
 (display 'memoized-fib) 
  (test-memoized-fib)  
  (display 'memoized-comb) 
  (test-memoized-comb)
  (display 'subst-leftmost) 
  (test-subst-leftmost)  
)

(define r run-all)

