;; Test code 


(define (test-string-index)
    (let ([correct '(
		     2
		     0
		     4
		     -1
		     -1
		     )]
          [answers 
            (list 
	     (string-index #\h "ether")
	     (string-index #\e "ether")
	     (string-index #\r "ether")
	     (string-index #\m "ether")
	     (string-index #\m "")
	     )])
      (display-results correct answers equal?)))

(define (test-merge-2-sorted-lists)
    (let ([correct '(
		     (1 3)
		     (1 2 3 4 5 6 7 8)
		     (3 4 5 6)
		     (1 2 3 4 5 6)
		     (1 1 2 3 4 5 6 6)
		     )]
          [answers 
            (list 		   
	     (merge-2-sorted-lists '() '(1 3))
	     (merge-2-sorted-lists '(1 4 5 7 8) '(2 3 6))
	     (merge-2-sorted-lists '(5 6) '(3 4))
	     (merge-2-sorted-lists '(1 3 5) '(2 4 6))
	     (merge-2-sorted-lists '(1 2 4 6) '(1 3 5 6))
	     )])
      (display-results correct answers equal?)))

(define (test-slist-equal?)
    (let ([correct '(#f #t #f #t #f #t #f #t #t #f #t #f #t #f 
		     )]
          [answers 
            (list 
	     (slist-equal? '() '(a))
	     (slist-equal? '() '())
	     (slist-equal? '(a) '(b))
	     (slist-equal? '(a) '(a))
	     (slist-equal? '(a) '(() a))
	     (slist-equal? '((a b)) '((a b)))
	     (slist-equal? '((a a) a) '((a a)))
	     (slist-equal? '((a ((b) (c) ())) d) '((a ((b) (c) ())) d))
	     (slist-equal? '(() (()) (()((a)))) '(() (()) (()((a)))))
	     (slist-equal? '((a ((b) (c) ())) d) '((a ((b) (e) ())) d))
	     (slist-equal? '(a b c () d e) '(a b c () d e))
	     (slist-equal? '((a ((b) (c e) ())) d) '((a ((b) (c) ())) d))
	     (slist-equal? '(((()))) '(((()))))
	     (slist-equal? '((a ((b) (c) ())) d) '((a ((b) (c) ())) f)))])
      (display-results correct answers equal?)))

(define (test-make-queue)
  (let ([correct '(
		   1
		   (#t #f)
		   (1 2)
		   (1 2)
		   (3 1)
		   (0 1 2 3 4 9 8 7 6 5)
		   )]
          [answers 
            (list 
	     (let ([q1 (make-queue)] [q2 (make-queue)])
	       (q1 'enqueue 1)
	       (q1 'dequeue))
	     
	     (let ([q1 (make-queue)] [q2 (make-queue)])
	       (q1 'enqueue 1)
	       (q2 'enqueue 2)
	       (q1 'dequeue)
	       (list (q1 'empty?) (q2 'empty?)))
	     
	     (let ([q1 (make-queue)] [q2 (make-queue)])
	       (q1 'enqueue 1)
	       (q2 'enqueue 2)
	       (list (q1 'dequeue) (q2 'dequeue)))
	     
	     (let ([q1 (make-queue)] [q2 (make-queue)])
	       (q1 'enqueue 1)
	       (q2 'enqueue 2)
	       (q1 'enqueue (q2 'dequeue))
	       (let ([val (q1 'dequeue)])
		 (cons val (list (q1 'dequeue)))))
	     
	     (let ([q1 (make-queue)] [q2 (make-queue)])
	       (q1 'enqueue 1)
	       (q2 'enqueue 2)
	       (q1 'enqueue (q2 'dequeue))
	       (q2 'enqueue 3)
	       (list (q2 'dequeue) (q1 'dequeue)))
	     
	     (let ([q1 (make-queue)] [q2 (make-queue)])
	       (let loop ([a 4] [b 5])
		 (q1 'enqueue a)
		 (q2 'enqueue b)
		 (if (positive? a) (loop (sub1 a) (add1 b))))
	       (let loop2 ()
		 (if (not (q1 'empty?))
		     (begin (q2 'enqueue (q1 'dequeue))
			    (loop2))))
	       (let loop3 ([result '()])
		 (if (q2 'empty?)
		     result
		     (loop3 (cons (q2 'dequeue) result)))))
	     
	     )])
    (display-results correct answers equal?)))

(define (test-)
    (let ([correct '(
		     )]
          [answers 
            (list 
	     )])
      (display-results correct answers equal?)))

(define (test-)
    (let ([correct '(
		     )]
          [answers 
            (list 
	     )])
      (display-results correct answers equal?)))

(define (test-)
    (let ([correct '(
		     )]
          [answers 
            (list 
	     )])
      (display-results correct answers equal?)))

(define (test-)
    (let ([correct '(
		     )]
          [answers 
            (list 
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
  (display 'string-index) 
  (test-string-index)
  (display 'merge-2-sorted-lists) 
  (test-merge-2-sorted-lists)
  (display 'slist-equal?) 
  (test-slist-equal?) 
  (display 'make-queue) 
  (test-make-queue)
)

(define r run-all)

