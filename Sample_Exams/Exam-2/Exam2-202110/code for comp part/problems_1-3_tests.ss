;; Test code 


(define (test-map-in-order)
    (let ([correct '(
		     (3 4 5 6 7 8 9 10 11 12 13)
		     (1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9)
		     )]
          [answers 
           (list
	    (let ([a 2])
	      (map-in-order (lambda (x) (set! a (add1 a)) a)
				 '(a b c d e f g h i j k)))
	    (let ([a 2]) 
	      (map-in-order (lambda (x) (set! a (sub1 a)) a)
			    '(a b c d e f g h i j k)))
	     )])
      (display-results correct answers equal?)))

(define (test-my-do)
    (let ([correct '(
		     10
		     5
		     (33 23)
		     (91 52)
		     )]
          [answers 
            (list 
	     (let ([x 5])
	       (my-do ((set! x (+ 1 x))) while (not (zero? (modulo x 5)))) x)
	     (let ([x 4])
	       (my-do ((set! x (+ 1 x))) while (not (zero? (modulo x 5)))) x)
	     (let ([x 4] [y 5])
	       (my-do ((set! y 6) (set! x (+ x y))
		       (my-do ((let ([x (+ 1 x)])
				 (set! x (+ x y))
				 (set! y (+ x y)))
			       (set! x (+ y x)))
			      while (< y 10)))
		      while (< (+ y x) 15))
	       (list x y))
	     (let ([x 4] [y 5])
	       (my-do ((set! y 6)
		       (set! x (+ x y))
		       (my-do ((let ([x (+ 1 x)])
				 (set! x (+ x y))
				 (set! y (+ x y)))
			       (set! x (+ y x)))
			      while (< y 20)))
		      while (< (+ y x) 60))
	       (list x y))
	     )])
      (display-results correct answers equal?)))

(define (test-make-queue)
    (let ([correct '(
		     #t
		     3
		     #t
		     #t
		     (3 4 #t)
		     )]
          [answers 
            (list 
	     (let ([q1 (make-queue)] [q2 (make-queue)])
	       (q1 'enqueue! 3)
	       (and (q2 'empty?) (not (q1 'empty?))))
	     (let ([q1 (make-queue)] [q2 (make-queue)])
	       (q1 'enqueue! 3)
	       (q1 'enqueue! 4)
	       (q1 'dequeue!))
	     (let ([q1 (make-queue)] [q2 (make-queue)])
	       (q1 'enqueue! 3)
	       (q1 'enqueue! 4)
	       (q2 'enqueue! (q1 'dequeue!))
	       (and (not (q1 'empty?)) (not (q1 'empty?))))
	     (let ([q1 (make-queue)] [q2 (make-queue)])
	       (q1 'enqueue! 3)
	       (q1 'enqueue! 4)
	       (q2 'enqueue! (q1 'dequeue!))
	       (q2 'enqueue! (q1 'dequeue!))
	       (and (q1 'empty?) (not (q2 'empty?))))
	     (let ([q1 (make-queue)] [q2 (make-queue)])
	       (q1 'enqueue! 3)
	       (q1 'enqueue! 4)
	       (q2 'enqueue! (q1 'dequeue!))
	       (q2 'enqueue! (q1 'dequeue!))
	       (let* ([x (q2 'dequeue!)]
		      [y (q2 'dequeue!)])
		 (list x y (q2 'empty?))))	   
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
  (display 'map-in-order) 
  (test-map-in-order)
  (display 'my-do) 
  (test-my-do)
  (display 'make-queue) 
  (test-make-queue)
  
)

(define r run-all)

