;; Test code for CSSE 304 Assignment 10



(define (test-free-vars)
    (let ([correct '(
		     (x)
		     (x)
		     ()
		     (y)
		     (x)
		     (x y z)
		     (x y)
		     ()
		     (x y)
		     )]
          [answers 
            (list 
	     (free-vars (quote x))
	     (free-vars (quote (x x)))
	     (free-vars (quote (lambda (x) x)))
	     (free-vars (quote (lambda (x) y)))
	     (free-vars (quote (x (lambda (x) x))))
	     (free-vars (quote (x (lambda (x) (y z)))))
	     (free-vars (quote (x (lambda (x) y))))
	     (free-vars (quote ((lambda (y) (lambda (y) y)) 
				(lambda (x) (lambda (x) x)))))
	     (free-vars (quote ((lambda (x) y) (lambda (y) x))))
	     )])
      (display-results correct answers sequal?-grading)))

(define (test-bound-vars)
    (let ([correct '(
		     ()
		     (x)
		     ()
		     (x)
		     ()
		     (x)
		     (y x)
		     )]
          [answers 
            (list 
	     (bound-vars (quote (x x)))
	     (bound-vars (quote (lambda (x) x)))
	     (bound-vars (quote (lambda (y) x)))
	     (bound-vars (quote (x (lambda (x) x))))
	     (bound-vars (quote (x (lambda (x) y))))
	     (bound-vars (quote (z (lambda (x) (lambda (y) x)))))
	     (bound-vars (quote ((lambda (y) (lambda (y) y)) 
				 (lambda (x) (z (lambda (x) x))))))
	     )])
      (display-results correct answers sequal?-grading)))

(define (test-occurs-free?)
    (let ([correct '(
		     #f
		     #t
		     #t
		     #t
		     #f
		     #f
		     #t
		     #f
		     #t
		     #f
		     #f
		     #t
		     #t
		     #t
		     #f
		     #t
		     )]
          [answers 
            (list 
	     (occurs-free? (quote x) (quote (lambda (a b x) x)))
	     (occurs-free? (quote x) (quote (lambda () (x))))
	     (occurs-free? (quote x) (quote (x (lambda (y x z) x))))
	     (occurs-free? (quote x) (quote (lambda (a b) (if (x a b) a b))))
	     (occurs-free? (quote a) (quote (lambda (a b) (if (x a b) a b))))
	     (occurs-free? (quote x) (quote (let ((x n)) 
					      ((lambda (y) (+ y x)) z))))
	     (occurs-free? (quote x) (quote (let ((w a) (y x)) 
					      ((lambda (y) (+ y x)) z))))
	     (occurs-free? (quote x) (quote (let* ((x a) (y x)) (y))))
	     (occurs-free? (quote b) (quote (let* ((y a) (x b)) ((x y) z))))
	     (occurs-free? (quote set!) (quote (lambda (x) (set! x y))))
	     (occurs-free? (quote x) (quote (lambda () 
					      (let* ((x a) 
						     (y x)) 
						(if (y z) 
						    (lambda () x) 
						    (lambda () y))))))
	     (occurs-free? (quote x) (quote (lambda () 
					      (let ((x a) 
						    (y x)) 
						(if (y z) (lambda () x) 
						    (lambda () y))))))
	     (occurs-free? (quote y) (quote (let ((y ((lambda (x) (+ x y)) z)))
					      (+ y y))))
	     (occurs-free? (quote z) (quote (let ((y ((lambda (x) (+ x y)) z)))
					      (+ y y))))
	     (occurs-free? 'x '(set! x y))
	     (occurs-free? 'y '(set! x y))
	     )])
      (display-results correct answers equal?)))

(define (test-occurs-bound?)
    (let ([correct '(
		     #t
		     #f
		     #t
		     #f
		     #t
		     #f
		     #t
		     #f
		     #f
		     #t
		     #t
		     #f
		     #t
		     #f
		     #t
		     #f
		     #t
		     #f
		     #t
		     #t
		     )]
          [answers 
            (list 
	     (occurs-bound? (quote x) (quote (lambda (a b x) x)))
	     (occurs-bound? (quote y) (quote (lambda (x a b) y)))
	     (occurs-bound? (quote x) (quote (x (lambda (y x z) x))))
	     (occurs-bound? (quote x) (quote (lambda (a b) 
					       (if (x a b) a b))))
	     (occurs-bound? (quote x) (quote (let ((x n)) 
					       ((lambda (y) (+ y x)) z))))
	     (occurs-bound? (quote x) (quote (let ((w a) (y x)) 
					       ((lambda (y) (+ y x)) z))))
	     (occurs-bound? (quote x) (quote (let* ((x a) (y x)) (y))))
	     (occurs-bound? (quote b) (quote (let* ((y a) (x b)) ((x y) z))))
	     (occurs-bound? (quote a) (quote (let* ((a x) (b c) (c b)) c)))
	     (occurs-bound? (quote b) (quote (let* ((a x) (b c) (c b)) c)))
	     (occurs-bound? (quote c) (quote (let* ((a x) (b c) (c b)) c)))
	     (occurs-bound? (quote set!) (quote (lambda (x) (set! x y))))
	     (occurs-bound? (quote x) (quote (lambda (x) (x))))
	     (occurs-bound? (quote x) (quote (lambda () x)))
	     (occurs-bound? (quote x) (quote (lambda () 
					       (let* ((x a) 
						      (y x)) 
						 (if (y z) 
						     (lambda () x) 
						     (lambda () y))))))
	     (occurs-bound? (quote z) (quote (lambda () 
					       (let* ((x a) 
						      (y x)) 
						 (if (y z) 
						     (lambda () x) 
						     (lambda () y))))))
	     (occurs-bound? (quote y) (quote (let ((y ((lambda (x) (+ x y)) 
						       z))) 
					       (+ y y))))
	     (occurs-bound? (quote z) (quote (let ((y ((lambda (x) (+ x y)) 
						       z))) 
					       (+ y y))))
	     (and (occurs-bound? 'x '(lambda (x) (set! y x)))
		  (not (occurs-bound? 'y '(lambda (x) (set! y x)))))
	     (and (occurs-bound? 'x '(if y x (lambda (x) (lambda (y) x))))
		  (not (occurs-bound? 'y '(if y x (lambda (x) (lambda (y) x))))))
	     )])
      (display-results correct answers equal?)))

(define (test-lexical-address)
    (let ([correct '(
		     (: free x)
		     ((: free x) (: free y))
		     (lambda (x y) ((: free cons) (: 0 0) (: 0 1)))
		     (lambda (x y z) (if (: 0 1) (: 0 0) (: 0 2)))
		     (lambda (x y) 
		       (lambda () 
			 ((lambda (z) 
			    (lambda (x w) 
			      (lambda () 
				((: 1 0) (: 4 1) (: 2 0) (: 1 1))))) 
			  ((: 1 0) (: 1 1) (: free z) (: free w)))))
		     (lambda (a b c) 
		       (if ((: free eq?)(: 0 1) (: 0 2)) 
			   ((lambda (c) 
			      ((: free cons) (: 1 0) (: 0 0))) 
			    (: 0 0)) 
			   (: 0 1)))
		     ((lambda (x y) 
			(((lambda (z) 
			    (lambda (w y) 
			      ((: free +) (: 2 0) (: 1 0) (: 0 0) (: 0 1)))) 
			  ((: free list) (: free w) (: 0 0) (: 0 1) (: free z))) 
			 ((: free +) (: 0 0) (: 0 1) (: free z)))) 
		      ((: free y) (: free z)))
		     (if ((lambda (x) 
			    ((: free y) (: 0 0))) 
			  (lambda (y) 
			    ((: 0 0) (: free x)))) 
			 (lambda (z) 
			   (if (: free x) 
			       (: free y) 
			       ((: free cons) (: 0 0) (: 0 0)))) 
			 ((: free x) (: free y)))
		     ((: free +)
		      (: free a)
		      (let ([a (: free b)] [b (: free a)]) ((: 0 0) (: 0 1))))
		     (lambda (a b)
		       ((: free +)
			(: 0 0)
			(: 0 1)
			(let ([x ((: free +) (: 0 0) (: free c))]
			      [y ((: free -) (: 0 0) (: 0 1))])
			  (let ([x (: 0 0)]
				[z ((: free +) (: 0 1) (: 1 0))]
				[w ((: 1 1) (: 0 0))])
			    ((lambda (t)
			       ((: 3 0) (lambda (a) 
					  ((: 2 0) (: 3 1) (: 0 0) (: 4 1)))))
			     ((: free t) (: 0 2)))))))
		     ((lambda (a b) (set! a (: 0 1)))
		      (let ([c (: free a)]) (set! d (: 0 0))))
		     )]
          [answers 
            (list 
	     (lexical-address (quote x))
	     (lexical-address (quote (x y)))
	     (lexical-address (quote (lambda (x y) (cons x y))))
	     (lexical-address (quote (lambda (x y z) (if y x z))))
	     (lexical-address 
	      (quote (lambda (x y) 
		       (lambda () 
			 ((lambda (z) 
			    (lambda (x w) 
			      (lambda () (x y z w)))) 
			  (x y z w))))))
	     (lexical-address 
	      (quote (lambda (a b c) 
		       (if (eq? b c) 
			   ((lambda (c) (cons a c)) a) 
			   b))))
	     (lexical-address 
	      '((lambda (x y) 
		  (((lambda (z) 
		      (lambda (w y) 
			(+ x z w y))) 
		    (list w x y z)) 
		   (+ x y z))) 
		(y z)))
	     (lexical-address 
	      (quote (if ((lambda (x) (y x)) 
			  (lambda (y) (y x))) 
			 (lambda (z) 
			   (if x y (cons z z))) 
			 (x y))))
	     (lexical-address
	      '(+ a (let ([a b] [b a])
		      (a b))))
	     (lexical-address
	      '(lambda (a b) (+ a b (let ([x (+ a c)] [y (- a b)])
				      (let ([x x] [z (+ y a)] [w (b x)])
					((lambda (t) 
					   (a (lambda (a) (x y a b)))) 
					 (t w)))))))
	     (lexical-address
	      '((lambda (a b) (set! a b))
		(let ([c a]) (set! d c))))
	     )])
      (display-results correct answers equal?)))

(define (test-un-lexical-address)
    (let ([correct '(
		     (x y)
		     (if ((lambda (x) (y x)) 
			  (lambda (y) 
			    (y x))) 
			 (lambda (z) 
			   (if x y (cons z z))) 
			 (x y))
		     (lambda (x y) 
		       (lambda () 
			 ((lambda (z) 
			    (lambda (x w) 
			      (lambda () 
				(x y z w)))) 
			  (x y z w))))
		     (+ a (let ([a b] [b a])
			    (a b)))
		     (lambda (a b) (+ a b (let ([x (+ a c)] [y (- a b)])
				      (let ([x x] [z (+ y a)] [w (b x)])
					((lambda (t) 
					   (a (lambda (a) (x y a b)))) 
					 (t w))))))
		     ((lambda (a b) (set! a b))
		      (let ([c a]) (set! d c)))
		     )]
          [answers 
            (list 
	     (un-lexical-address (lexical-address (quote (x y))))
	     (un-lexical-address 
	      (lexical-address 
	       (quote (if ((lambda (x) (y x)) 
			   (lambda (y) (y x))) 
			  (lambda (z) 
			    (if x y (cons z z))) 
			  (x y)))))
	     (un-lexical-address 
	      (lexical-address 
	       (quote (lambda (x y) 
			(lambda () 
			  ((lambda (z) 
			     (lambda (x w) 
			       (lambda () 
				 (x y z w)))) 
			   (x y z w)))))))
	     (un-lexical-address 
	      (lexical-address 
	       (quote
		(+ a (let ([a b] [b a])
		      (a b))))))
             (un-lexical-address 
	      (lexical-address 
	       (quote
		(lambda (a b) (+ a b (let ([x (+ a c)] [y (- a b)])
				       (let ([x x] [z (+ y a)] [w (b x)])
					 ((lambda (t) 
					    (a (lambda (a) (x y a b)))) 
					  (t w)))))))))
	     (un-lexical-address 
	      (lexical-address 
	       (quote
		((lambda (a b) (set! a b))
		(let ([c a]) (set! d c))))))
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
  (display 'free-vars) 
  (test-free-vars)
  (display 'bound-vars) 
  (test-bound-vars)  
  (display 'occurs-free?) 
  (test-occurs-free?)  
  (display 'occurs-bound?) 
  (test-occurs-bound?)
  (display 'lexical-address) 
  (test-lexical-address)
  (display 'un-lexical-address) 
  (test-un-lexical-address)
)

(define r run-all)

