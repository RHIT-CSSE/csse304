;; Test code for CSSE 304 Assignment 13

(define (test-literals)
    (let ([correct '(
		     ()
		     #t
		     #f
		     ""
		     "test"
		     #(a b c)
		     #5(a)
		     )]
          [answers 
            (list 
	     (eval-one-exp ''())
	     (eval-one-exp #t)
	     (eval-one-exp #f)
	     (eval-one-exp "")
	     (eval-one-exp "test")
	     (eval-one-exp ''#(a b c))
	     (eval-one-exp ''#5(a))
	     )])
      (display-results correct answers equal?)))

(define (test-quote)
    (let ([correct '(
		     ()
		     a
		     (car (a b))
		     (lambda (x) (+ 1 x))
		     )]
          [answers 
            (list 
	     (eval-one-exp '(quote ()))
	     (eval-one-exp '(quote a))
	     (eval-one-exp '(quote (car (a b))))
	     (eval-one-exp '(quote (lambda (x) (+ 1 x))))
	     )])
      (display-results correct answers equal?)))

(define (test-if)
    (let ([correct '(
		     5
		     4
		     6
		     2
		     10
		     )]
          [answers 
            (list 
	     (eval-one-exp '(if #t 5 6))
	     (eval-one-exp '(if 2 (if #f 3 4) 6))
	     (eval-one-exp '(if #f 5 6))
	     (eval-one-exp '(if 1 2 3))
	     (let ([x (if #f 2 3)])
	       (+ x 7))
	     )])
      (display-results correct answers equal?)))


(define (test-primitive-procedures)
    (let ([correct '(
		     10
		     7
		     48
		     3
		     10
		     #t
		     #f
		     #t
		     (a . b)
		     b
		     (a b c)
		     #t
		     #t
		     #t
		     5
		     #(a b c)
		     #f
		     #t
		     (a b c)
		     #t
		     #t
		     (#t #f)
		     a
		     c
		     b
		     (#t #t #f)
		     )]
          [answers 
            (list 
	     (eval-one-exp '(+ (+ 1 2) 3 4))
	     (eval-one-exp '(- 10 1 (- 5 3)))
	     (eval-one-exp '(* 2 (* 3 4) 2))
	     (eval-one-exp '(/ 6 2))
	     (eval-one-exp '(sub1 (add1 10)))
	     (eval-one-exp '(not (zero? 3)))
	     (eval-one-exp '(= 3 4))
	     (eval-one-exp '(>= 4 3))
	     (eval-one-exp '(cons 'a 'b))
	     (eval-one-exp '(car (cdr '(a b c))))
	     (eval-one-exp '(list 'a 'b 'c))
	     (eval-one-exp '(null? '()))
	     (eval-one-exp '(eq? 'a 'a))
	     (eval-one-exp '(equal? 'a 'a))
	     (eval-one-exp '(length '(a b c d e)))
	     (eval-one-exp '(list->vector '(a b c)))
	     (eval-one-exp '(list? 'a))
	     (eval-one-exp '(pair? '(a b)))
	     (eval-one-exp '(vector->list '#(a b c)))
	     (eval-one-exp '(vector? '#(a b c)))
	     (eval-one-exp '(number? 5))
	     (list (eval-one-exp '(symbol? 'a)) (eval-one-exp '(symbol? 5)))
	     (eval-one-exp '(caar '((a b) c)))
	     (eval-one-exp '(cadr '((a b) c)))
	     (eval-one-exp '(cadar '((a b) c)))
	     (eval-one-exp '
	      (list (procedure? list)
		    (procedure? (lambda (x y) (list (+ x y))))
		    (procedure? 'list)))
	     )])
      (display-results correct answers equal?)))

(define (test-let)
    (let ([correct '(
		     8
		     14
		     24
		     (2 . 4)
		     )]
          [answers 
            (list 
	     (eval-one-exp ' 
	      (let ([a 3][b 5]) 
		(+ a b)))
(eval-one-exp ' 
 (let ([a 3]) 
   (let ([b 2] [c (+ a 3)] [a (+ a a)]) 
     (+ a b c))))
(eval-one-exp ' 
 (let ([a 3]) 
   (let ([a (let ([a (+ a a)]) 
	      (+ a a))]) 
     (+ a a))))
(eval-one-exp ' 
 (let ([a (list 3 4)]) 
   (set-car! a 2) 
   (set-cdr! a (cadr a)) 
   a))
)])
      (display-results correct answers equal?)))

(define (test-lambda)
    (let ([correct '(
		     6
		     12
		     154
		     720
		     (#t #t #f)
		     )]
          [answers 
	   (list 
	    (eval-one-exp '((lambda (x) (+ 1 x)) 
			    5))
	    (eval-one-exp '((lambda (x) (+ 1 x) 
				    (+ 2 (* 2 x))) 5))
	    (eval-one-exp ' 
	     ((lambda (a b) 
		(let ([a (+ a b)] [b (- a b)]) 
		  (let ([f (lambda (a) (+ a b))]) 
		    (f (+ 3 a b))))) 
	      56 17))
	    (eval-one-exp ' 
	     (((lambda (f) 
		 ((lambda (x) 
		    (f (lambda (y) 
			((x x) y)))) 
		  (lambda (x) 
		    (f (lambda (y) 
			 ((x x) y)))))) 
	       (lambda (g) 
		 (lambda (n) 
		   (if (zero? n) 1 (* n (g (- n 1))))))) 
	     6))
	   (eval-one-exp ' 
	    (let ([Y (lambda (f) 
		       ((lambda (x) 
			  (f (lambda (y) 
			       ((x x) y)))) 
			(lambda (x) 
			  (f (lambda (y) 
			       ((x x) y))))))]
		  [H (lambda (g) 
		       (lambda (x) 
			 (if (null? x) 
			     '() 
			     (cons (procedure? (car x)) (g (cdr x))))))])
		((Y H) (list list (lambda (x) x) 'list))))
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
  (display 'literals) 
  (test-literals)
  (display 'quote) 
  (test-quote)
  (display 'if) 
  (test-if)
  (display 'primitive-procedures) 
  (test-primitive-procedures)    
  (display 'let) 
  (test-let)
  (display 'lambda) 
  (test-lambda)
)

(define r run-all)

