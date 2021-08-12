(define (test-sum-cps)
    (let ([correct '(
		     0
		     (1)
		     3
		     1
		     3
		     6
		     7
		     21
		     )]
          [answers 
            (list 
	     (begin (set! slist '())
		    (set! k (id-k))
		    (sum-cps))
	     (begin (set! slist '(1))
		    (set! k (list-k))
		    (sum-cps))
	     (begin (set! slist '(1 2))
		    (set! k (id-k))
		    (sum-cps))
	     (begin (set! slist '((1)))
		    (set! k (id-k))
		    (sum-cps))
	     (begin (set! slist '((1) 2))
		    (set! k (id-k))
		    (sum-cps))
	     (begin (set! slist '((1) () 2 (3)))
		    (set! k (id-k))
		    (sum-cps))
	     (begin (set! slist '(1 2 (((() 4 )))))
		    (set! k (id-k))
		    (sum-cps))
	     (begin (set! slist '((1) ((2 (3 ()) (((4 5))) () 6))))
		    (set! k (id-k))
		    (sum-cps))

	   
	     )])
      (display-results correct answers equal?)))

(define (test-flatten-cps)
    (let ([correct '(
		     ()
		     (a)
		     (a b)
		     ((a d e c g b t))
		     (d a e c g b t)
		     7
		     (a d e c b g t)
		     (t a d e c g b)
		     (a d c e g b t)
		     )]
          [answers 
            (list 
		(begin (set! slist '()) 
		       (set! k (id-k)) 
		       (flatten-cps))
		(begin (set! slist '(a)) 
		       (set! k (id-k)) 
		       (flatten-cps))
		(begin (set! slist '(a b)) 
		       (set! k (id-k)) 
		       (flatten-cps))
		(begin (set! slist '(a d e c g b t)) 
		       (set! k (list-k)) 
		       (flatten-cps))
		(begin (set! slist '(d a e c g b (t))) 
		       (set! k (id-k)) 
		       (flatten-cps))
		(begin (set! slist '(((d a () (e) c ) g b) t)) 
		       (set! k (length-k)) 
		       (flatten-cps))
		(begin (set! slist '(((a d () (((e))) c ) b g) t)) 
		       (set! k (id-k)) (flatten-cps))
		(begin (set! slist '(t ((a d () (((e))) c ) g ((())) b))) 
		       (set! k (id-k)) 
		       (flatten-cps))
		(begin (set! slist '(( () (a d () c (((e))) ) g ((())) b) t)) 
		       (set! k (id-k)) 
		       (flatten-cps))
	   
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
  (display 'sum-cps) 
  (test-sum-cps)
  (display 'flatten-cps) 
  (test-flatten-cps)
)

(define r run-all)

