;; Test code for CSSE 304 Assignment 18.  Last updated 5/13/2015

; I am not sure whether the following test case form the 
; PLC server will fit the framework of the usual kinds of 
; offline tests.  So I am just including it here.
; You can copy the part after the quote and paste it into Scheme.

'(begin
  (reset-global-env)  ; answer: (3 1 2 1 1)
  (eval-one-exp '
   (define out (list)))
  (eval-one-exp '
   (define strange2
   (lambda (x)
     (set! out (cons 1 out))
     (call/cc x)
     (set! out (cons 2 out))
     (call/cc x)
     (set! out (cons 3 out)))))
  (eval-one-exp '
   (strange2 (call/cc (lambda (k) k))))
  (eval-one-exp 'out))


(define (test-legacy)
    (let ([correct '(
		    19
		    13
		    773
		    (8 1 2 3 4 5 6 7)
		    (30 (29 27 24 20 15 9 2 3) 0)
		    3
		    (5 7)
		    (((a b (c () (d new (f g)) h)) i))
		    5
		    )]
          [answers 
            (list 
	     (eval-one-exp ' 
	      (let ([x 5] [y 3]) 
		(let ([z (begin (set! x (+ x y)) x)]) 
		  (+ z (+ x y)))))
	     (begin (reset-global-env)
		    (eval-one-exp ' 
		     (begin (define cde 5) 
			    (define def (+ cde 2)) 
			    (+ def (add1 cde)))))
	     (begin (reset-global-env) 
		    (eval-one-exp ' 
		     (letrec ([f (lambda (n) (if (zero? n) 0 (+ 4 (g (sub1 n)))))] 
			      [g (lambda (n) (if (zero? n) 0 (+ 3 (f (sub1 n)))))]) 
		       (g (f (g (f 5)))))))
	     (begin (reset-global-env) 
		    (eval-one-exp '
		     (define rotate-linear 
		       (letrec ([reverse (lambda (lyst revlist) 
					   (if (null? lyst) 
					       revlist 
					       (reverse (cdr lyst) 
							(cons (car lyst) revlist))))]) 
			 (lambda (los) 
			   (let loop ([los los] [sofar '()]) 
			     (cond [(null? los) los] 
				   [(null? (cdr los)) (cons (car los) (reverse sofar '()))] 
				   [else (loop (cdr los) (cons (car los) sofar))])))))) 
		    (eval-one-exp '(rotate-linear '(1 2 3 4 5 6 7 8))))
	     (begin (reset-global-env) 
		    (eval-one-exp ' 
		     (let ([r 2] [ls '(3)] [count 7]) 
		       (let loop () 
			 (if (> count 0) 
			     (begin (set! ls (cons r ls)) 
				    (set! r (+ r count)) 
				    (set! count (- count 1)) 
				    (loop))
			     )) 
		       (list r ls count))))
	     (eval-one-exp '(apply apply (list + '(1 2))))
	     (eval-one-exp '(apply map (list (lambda (x) (+ x 3)) '(2 4))))
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
				  (lambda (p) "It's an error to get here")))))
	     (eval-one-exp ' ((lambda () 3 4 5)))
)])
      (display-results correct answers equal?)))

(define (test-simple-call/cc)
    (let ([correct '(
		     12
		     13
		     9
		     (#t)
		     9
		     (1 2 3)
		     (18 6)
		     )]
          [answers 
            (list 
	     (eval-one-exp ' (+ 5 (call/cc (lambda (k) (+ 6 (k 7))))))
	     (eval-one-exp ' (+ 3 (call/cc (lambda (k) (* 2 5)))))
	     (eval-one-exp ' (+ 5 (call/cc (lambda (k) (or #f #f (+ 7 (k 4)) #f)))))
	     (eval-one-exp '(list (call/cc procedure?)))
	     (eval-one-exp ' (+ 2 (call/cc (lambda (k) (+ 3 (let* ([x 5] [y (k 7)]) (+ 10 (k 5))))))) )
	     (eval-one-exp ' ((car (call/cc list)) (list cdr 1 2 3)) )
	     (eval-one-exp
	      '(let ([a 5] [b 6])
		 (set! a (+ 7 (call/cc (lambda (k)
					 (set! b (k 11))))))
		 (list a b)))
	     )])
      (display-results correct answers equal?)))

(define (test-complex-call/cc)
    (let ([correct '(
		     9
		     1000
		     (6 7 8 9 100 11 12 13)
		     ((6 7 8 9 987654321 11 12 13))
		     (4)
		     9
		     25
		     (3 2 5 2 5)
		     7
		     )]
          [answers 
            (list 
	     (begin 
	       (reset-global-env) 
	       (eval-one-exp ' 
		(define xxx #f)) 
	       (eval-one-exp ' (+ 5 (call/cc (lambda (k) 
					       (set! xxx k) 2)))) 
	       (eval-one-exp ' (* 7 (xxx 4))))   
	     (begin (eval-one-exp '
		     (define break-out-of-map #f)) 
		    (eval-one-exp ' 
		     (set! break-out-of-map
		       (call/cc (lambda (k) 
				  (lambda (x)
				    (if (= x 7) (k 1000) (+ x 4))))))) 
		    (eval-one-exp '(map break-out-of-map
					'(1 3 5 7 9 11))) 
		    (eval-one-exp 'break-out-of-map))
	     (begin (eval-one-exp ' (define jump-into-map #f)) 
		    (eval-one-exp '
		     (define do-the-map 
		       (lambda (x) 
			 (map (lambda (v) 
				(if (= v 7) 
				    (call/cc
				     (lambda (k)
				       (set! jump-into-map k) 100)) 
				    (+ 3 v))) 
			      x)))) 
		    (eval-one-exp ' (do-the-map '(3 4 5 6 7 8 9 10))))
	     (begin (eval-one-exp ' 
		     (define jump-into-map #f)) 
		    (eval-one-exp '
		     (define do-the-map 
		       (lambda (x) 
			 (map (lambda (v)
				(if (= v 7) 
				    (call/cc (lambda (k)
					       (set! jump-into-map k) 100)) 
				    (+ 3 v))) x)))) 
		    (eval-one-exp ' (list (do-the-map '(3 4 5 6 7 8 9 10)))) 
		    (eval-one-exp ' (jump-into-map 987654321)))
             (eval-one-exp 
	      '(let ([y 
		      (call/cc 
		       (call/cc 
			(call/cc call/cc)))]) 
		 (y list) 
		 (y 4)))
	     (eval-one-exp '
	      (+ 4 (apply call/cc (list (lambda (k) (* 2 (k 5)))))))
	     (eval-one-exp '
	       (letrec ([a (lambda (x) 
			     (+ 12
				(call/cc
				 (lambda (k)
				   (if (k x)   
				       7
				       (a (- x 3)))))))])
		 (+ 6 (a 7))))
	      (eval-one-exp '
	       (map (call/cc (lambda (k)
			       (lambda (v)
				 (if (= v 1)
				     (k add1)
				     (+ 4 v)))))
		    '( 2 1 4 1 4)))
	      (eval-one-exp '
		(begin
		  (define a 4)
		  (define f (lambda ()
			      (call/cc (lambda (k)
					 (set! a (+ 1 a))
					 (set! a (+ 2 a))
					 (k a)
					 (set! a (+ 5 a))
					 a))))
		  (f)))
	      )])
      (display-results correct answers equal?)))


(define (test-exit-list)
    (let ([correct '(
		     (6 7)
		     (5)
		     (3)
		     12
		     (12)
		     )]
          [answers 
            (list 
	     (eval-one-exp ' (+ 4 (exit-list 5 (exit-list 6 7))) )
	     (eval-one-exp ' (+ 3 (- 2 (exit-list 5))))
	     (eval-one-exp ' (- 7 (if (exit-list 3) 4 5)))
	     (eval-one-exp
	      '(call/cc (lambda (k)
			  (+ 100 (exit-list (+ 3 (k 12)))))))
	     (eval-one-exp
	      '(call/cc (lambda (k)
			  (+ 100 (k (+ 3 (exit-list 12)))))))
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
  (display 'legacy) 
  (test-legacy)
  (display 'simple-call/cc) 
  (test-simple-call/cc)
  (display 'complex-call/cc) 
  (test-complex-call/cc)
  (display 'exit-list)
  (test-exit-list) 
)

(define r run-all)

