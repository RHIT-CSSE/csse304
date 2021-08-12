;; Test code for CSSE 304 Assignment 16

(define (test-basics)
    (let ([correct '(
		     (1 1 2 6 24 120)
		     40320
		     120
		     (#t #f #f #t)
		     )]
          [answers 
            (list 
	     (eval-one-exp '
	      (letrec ([fact (lambda (x)
			       (if (zero? x) 
				   1
				   (* x (fact (- x 1)))))])
		(map fact '(0 1 2 3 4 5))))
	     (eval-one-exp '
	      (let f ([n 8] [acc 1])
		(if (= n 0)
		    acc
		    (f (sub1 n) (* acc n)))))
	     
	     (eval-one-exp '
	      (let ([n 5])
		(let f ([n n] [acc 1])
		  (if (= n 0)
		      acc
		      (f (sub1 n) (* acc n))))))
	     
	     (eval-one-exp '
	      (letrec ([even? (lambda (n)
				(if (zero? n) 
				    #t
				    (odd? (- n 1))))]
		       [odd? (lambda (m)
			       (if (zero? m)
				   #f
				   (even? (- m 1))))])
		(list (odd? 3) (even? 3) (odd? 4) (even? 4))))	     )])
      (display-results correct answers equal?)))

(define (test-answers-are-sets)
    (let ([correct '(
		     (k e b d a c)
		     ((3 a) (2 b)(3 b) (2 a) (1 a) (1 b))
		     )]
          [answers 
            (list 
	     (eval-one-exp '
	      (letrec ([union
			(lambda (s1 s2)
			  (cond [(null? s1) s2]
				[(member? (car s1) s2) (union (cdr s1) s2)]
				[else (cons (car s1) (union (cdr s1) s2))]))]
		       [member? (lambda (sym ls)
				  (cond [(null? ls) #f]
					[(eqv? (car ls) sym) #t]
					[else (member? sym (cdr ls))]))])
		(union '(a c e d k) '(e b a d c))))
	     (eval-one-exp '
	     (letrec ([product
		       (lambda (x y)
			 (if (null? y)
			     '()
			     (let loop ([x x] [accum '()])
			       (if (null? x)
				   accum
				   (loop (cdr x)
					 (append (map (lambda (s)
							(list (car x) s))
						      y)
						 accum))))))])
	       (product '(1 2 3) '(a b))))
	     )])
      (display-results correct answers sequal?-grading)))

(define (test-additional)
    (let ([correct '(
		     (8 6 5 4 3 2 1)
		     )]
      [answers 
       (list 
	(eval-one-exp ' 
	 (letrec ([sort (lambda (pred? l) 
			  (if (null? l) l 
			      (dosort pred? l (length l))))] 
		  [merge (lambda (pred? l1 l2) 
			   (cond [(null? l1) l2] 
				 [(null? l2) l1] 
				 [(pred? (car l2) (car l1)) 
				  (cons (car l2) 
					(merge pred? l1 (cdr l2)))] 
				 [else (cons (car l1) (merge pred? 
							     (cdr l1) l2))]))] 
		  [dosort (lambda (pred? ls n) 
			    (if (= n 1) 
				(list (car ls)) 
				(let ([mid (quotient n 2)]) 
				  (merge pred? (dosort pred? ls mid) 
					 (dosort pred? 
						 (list-tail ls mid) 
						 (- n mid))))))]) 
	   (sort > '(3 8 1 4 2 5 6))))
	)])
      (display-results correct answers equal?)))

;If you need to debug this, start with a simpler s-list.
(define (test-subst-leftmost)
  (let ([correct '(
		     (((a b (c () (d new (f g)) h)) i))
		     )]
	[answers 
	 (list
	 (eval-one-exp '
 (letrec (
     [apply-continuation  (lambda (k val)
                             (k val))]
     [subst-left-cps
       (lambda (new old slist changed unchanged)
          (let loop ([slist slist] 
                     [changed changed] 
                     [unchanged unchanged])
            (cond
              [(null? slist) (apply-continuation unchanged #f)]
              [(symbol? (car slist))
               (if (eq? (car slist) old)
                   (apply-continuation changed (cons new (cdr slist)))
                   (loop (cdr slist)
                         (lambda (changed-cdr)
                           (apply-continuation changed 
                                               (cons (car slist) changed-cdr)))
                         unchanged))]
               [else 
                 (loop (car slist)
                       (lambda (changed-car)
                          (apply-continuation changed 
                                              (cons changed-car (cdr slist))))
                       (lambda (t) 
                         (loop (cdr slist)
                               (lambda (changed-cdr)
                                  (apply-continuation changed 
                                                      (cons (car slist) changed-cdr)))
                         unchanged)))])))])
       (let ([s '((a b (c ()  (d e (f g)) h)) i)])
         (subst-left-cps 'new 'e s
                         (lambda (changed-s)
                            (subst-left-cps 'new 'q s 
                                            (lambda (wont-be-changed) 'whocares)
                                            (lambda (r) (list changed-s))))
                          (lambda (p) "It's an error to get here"))))))])
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
  (display 'basics) 
  (test-basics)
  (display 'answers-are-sets) 
  (test-answers-are-sets)
  (display 'additional) 
  (test-additional)
  (display 'subst-leftmost) 
  (test-subst-leftmost)
)

(define r run-all)

