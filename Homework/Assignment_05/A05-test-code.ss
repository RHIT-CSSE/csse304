;; Test code for CSSE 304 Assignment 5

(define (test-minimize-interval-list)
    (let ([correct '(
		     ((1 3)) 
		     ((1 2) (3 4)) 
		     ((1 4) (8 11)) 
		     ((1 11)) 
		     ((1 2) (4 7)) 
		     ((1 10)) 
		     ((1 5) (6 8))
		     ((1 3)) 
		     ((1 5)) 
		     ((1 2) (4 5) (7 10)) 
		     ((1 2) (4 10)) 
		     ((1 4))
		     )]
          [answers 
            (list   	     (minimize-interval-list '((1 3) (2 3)))
	     (minimize-interval-list '((1 2) (3 4)))
	     (minimize-interval-list '((1 3) (8 10) (2 4) (9 11)))
	     (minimize-interval-list '((2 5) (1 7) (6 10) (10 11)))
	     (minimize-interval-list '((1 2) (4 7) (1 2)))
             ; from PLC server
	     (minimize-interval-list (quote ((1 4) (2 10) (3 5) (3 4) (3 7))))
	     (minimize-interval-list (quote ((1 4) (2 5) (6 8))))
	     (minimize-interval-list (quote ((1 2) (2 3))))
	     (minimize-interval-list (quote ((1 2) (1 3) (1 4) (2 5) (1 3) (1 4) (1 2) (1 3))))
	     (minimize-interval-list (quote ((1 2) (4 5) (7 10))))
	     (minimize-interval-list (quote ((1 2) (4 5) (5 6) (6 7) (7 8) (8 9) (9 10))))
	     (minimize-interval-list (quote ((1 4))))

	     )])
      (display-results correct answers set-equals?)))


(define (test-exists?)
  (let ([correct '(#t #f)]
        [answers 
          (list  
	   (exists? number? '(a b 3 c d))
           (exists? number? '(a b c d e)) 
	   )])
    (display-results correct answers eq?)))



	  


(define (test-product)
  (let ([correct '(() () () ((x a) (x b) (x c) (y a) (y b) (y c)) )]
        [answers 
          (list
	   (product (quote ()) (quote ()))
	   (product (quote (x y z)) (quote ()))
	   (product (quote ()) (quote (a b c)))
	   (product (quote (x y)) (quote (a b c)))	  
	   )])
    (display-results correct answers set-equals?)))

(define (test-replace)
  (let ([correct '( () (1 7 2 7 4) (7 7 7 7 7)(1 3 2 6 4))]
        [answers 
          (list
	   (replace 5 7 '())
	   (replace 5 7 '(1 5 2 5 4))
	   (replace 5 7 '(7 5 7 5 7))
	   (replace 5 7 '(1 3 2 6 4))
	  )])
    (display-results correct answers equal?)))



(define (test-remove-last)
  (let ([correct '((a b c d)(a c d) (a c d) (a b c b d b e f) (b a b c d))]
        [answers 
          (list
	   (remove-last 'b '(a b c b d))
	   (remove-last 'b '(a c d))
	   (remove-last 'b '(a c b d))
	   (remove-last 'b '(a b c b d b e b f)) 
	   (remove-last 'b '(b a b c b d))
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
  (display 'minimize-interval-list) 
  (test-minimize-interval-list)
  (display 'exists?) 
  (test-exists?)
  (display 'product) 
  (test-product)
  (display 'replace) 
  (test-replace)
  (display 'remove-last) 
  (test-remove-last)
)

(define r run-all)

