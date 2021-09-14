; Hint for the stack problem:
; You should use define-syntax for some of the operations and define for others.

(define (test-counter-maker)
    (let ([correct '(
		     (count this! 0)
		     1
		     (1 . 4)
		     5
		     ((1 2 6 24 120 720) 6)
		     )]
          [answers 
            (list 
	     (let* ([counted-member (counter-maker member)]
		    [counted-cons (counter-maker cons)])
	       (counted-member
		'count
		(counted-cons
		 'I
		 (counted-cons
		  'can
		  (counted-cons
		   'count
		   (counted-cons 'this!
				 (counted-cons (counted-cons 'count) '())))))))
	     (let* ([counted-member (counter-maker member)]
		    [counted-cons (counter-maker cons)])
	       (counted-member
		'count
		(counted-cons
		 'I
		 (counted-cons
		  'can
		  (counted-cons 'count
				(counted-cons 'this! '())))))
	       (counted-member 'count))
	     (let* ([counted-member (counter-maker member)]
		    [counted-cons (counter-maker cons)])
	       (counted-member
		'count
		(counted-cons
		 'I
		 (counted-cons 'can
			       (counted-cons 'count
					     (counted-cons 'this! '())))))
	       (counted-member 'count) (counted-cons (counted-member 'count)
						     (counted-cons 'count)))
	     (let* ([counted-member (counter-maker member)]
		    [counted-cons (counter-maker cons)])
	       (counted-member
		'count
		(counted-cons
		 'I
		 (counted-cons
		  'can
		  (counted-cons 'count
				(counted-cons 'this! '())))))
	       (counted-member 'count)
	       (counted-cons (counted-member 'count)
			     (counted-cons 'count)) (counted-cons 'count))
	     (letrec ([fact (lambda (n)
			      (if (zero? n)
				  1
				  (* n (fact (- n 1)))))])
	       (let* ([counted-fact (counter-maker fact)]
		      [fact-list (map counted-fact '(1 2 3 4 5 6))])
		 (list fact-list (counted-fact 'count))))
	     )])
      (display-results correct answers equal?)))

(define (test-stack)
    (let ([correct '(
		     ((c b a) (d))
		     #t
		     (c d)
		     (c (b a))
		     ((b a) (c d))
		     )]
          [answers 
            (list 
	     (let ([s1 (new-stack)]
		   [s2 (new-stack)])
	       (push! 'a s1)
	       (push! 'b s1)
	       (push! 'c s1)
	       (push! 'd s2)
	       (list s1 s2))
	     (let ([s1 (new-stack)]
		   [s2 (new-stack)])
	       (push! 'a s1)
	       (push! 'b s1)
	       (push! 'c s1)
	       (push! 'd s2)
	       (and (list? s1) (not (empty? s1))))

	     (let ([s1 (new-stack)]
		   [s2 (new-stack)])
	       (push! 'a s1)
	       (push! 'b s1)
	       (push! 'c s1)
	       (push! 'd s2)
	       (list (top s1) (top s2)))
	     (let ([s1 (new-stack)]
		   [s2 (new-stack)])
	       (push! 'a s1)
	       (push! 'b s1)
	       (push! 'c s1)
	       (push! 'd s2)
	       (let ([popped (pop! s1)])
		 (list popped s1)))
	     (let ([s1 (new-stack)]
		   [s2 (new-stack)])
	       (push! 'a s1)
	       (push! 'b s1)
	       (push! 'c s1)
	       (push! 'd s2)
	       (push! (pop! s1) s2)
	       (list s1 s2))
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
  (display 'counter-maker) 
  (test-counter-maker)
  (display 'stack) 
  (test-stack)
)

(define r run-all)

