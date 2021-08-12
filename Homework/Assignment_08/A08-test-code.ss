;; Test code for CSSE 304 Assignment 8

(define (test-make-slist-leaf-iterator)
    (let ([correct '(
		     #f
		     #f
		     a
		     e
		     z
		     (c n b x a z)
		     #f
		     )]
          [answers 
            (list 
	     (let ((iter (make-slist-leaf-iterator 
			  (quote ((a b ())))))) 
	       (begin (iter 'next) (iter 'next)) (iter 'next))
	     (let ((iter (make-slist-leaf-iterator 
			  (quote ((())))))) 
	       (iter 'next))
	     (let ((iter (make-slist-leaf-iterator 
			  (quote ((() a (b c d ()) () e f g)))))) 
	       (iter 'next))
	     (let ((iter (make-slist-leaf-iterator 
			  (quote ((() a (b () c (d ())) () e f g)))))) 
	       (begin (iter 'next) (iter 'next) (iter 'next) (iter 'next)) (iter 'next))
	     (let ((iter (make-slist-leaf-iterator 
			  (quote ((() (() ()) (a) (z (x) d ()) () e f g)))))) 
	       (begin (iter 'next)) (iter 'next))
	     (let ((iter1 (make-slist-leaf-iterator 
			   (quote (a (b (c) (d)) (((e))))))) 
		   (iter2 (make-slist-leaf-iterator 
			   (quote (z (x n (v) ((m)))))))) 
	       (let loop ((count 2) 
			  (accum (quote ()))) 
		 (if (>= count 0) 
		     (loop (- count 1) 
			   (cons (iter1 'next) (cons (iter2 'next) accum))) 
		     accum)))
	     (let ((iter (make-slist-leaf-iterator 
			  (quote ((() (z) (a (x) d ()) () e f g)))))) 
	       (begin (iter 'next) (iter 'next) (iter 'next) (iter 'next) 
		      (iter 'next) (iter 'next) (iter 'next) (iter 'next) (iter 'next)) (iter 'next))
	     )])
      (display-results correct answers equal?)))





(define (test-subst-leftmost)
    (let ([correct '(
		     ()
		     (k b)
		     (a k a b)
		     (a ((k b)) a b)
		     ((c d a (e () f k (c b)) (a b)) (b))
		     (c (b e) a d)
		     ((b b) (c e))
		     (c (g e) k d)
		     )]
          [answers 
            (list 
	     (subst-leftmost 'k 'b '() eq?)
	     (subst-leftmost 'k 'b '(b b) eq?)
	     (subst-leftmost 'k 'b '(a b a b) eq?)
	     (subst-leftmost 'k 'b '(a ((b b)) a b) eq?)
	     (subst-leftmost 'k 'b '((c d a (e () f b (c b)) (a b)) (b)) eq?)
	     (subst-leftmost 'b 'a '(c (A e) a d) 
			     (lambda (x y) 
			       (string-ci=? 
				(symbol->string x) 
				(symbol->string y))))
	     (subst-leftmost 'c 'a '((b b) (a e)) eq?)
	     (subst-leftmost 'k 'a '(c (g e) a d) eq?)
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
  (display 'make-slist-leaf-iterator) 
  (test-make-slist-leaf-iterator)
  (display 'subst-leftmost)
  (test-subst-leftmost)  
)

(define r run-all)

