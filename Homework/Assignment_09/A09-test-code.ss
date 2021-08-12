;; Test code for CSSE 304 Assignment 9

(define (test-sn-list-sum)
    (let ([correct '(
		     0
		     5
		     40
		     55
		     )]
          [answers 
            (list 
	     (sn-list-sum (quote ()))
	     (sn-list-sum (quote ((((5))))))
	     (sn-list-sum (quote (10 ((10) 10 10))))
	     (sn-list-sum (quote (1 (2 (3 4 ((5 6) 7) 8) 9) 10)))
	     )])
      (display-results correct answers equal?)))

(define (test-sn-list-map)
    (let ([correct '(
		     (2 3 (4 (5)))
		     ((a x) ((b x) (c x)) (d x))
		     (10)
		     )]
          [answers 
            (list 
	     (sn-list-map (lambda (x) (+ x 1)) (quote (1 2 (3 (4)))))
	     (sn-list-map (lambda (x) x) (quote ((a x) ((b x) (c x)) (d x))))
	     (sn-list-map (lambda (x) (+ x 10)) (quote (0)))
	     )])
      (display-results correct answers equal?)))

(define (test-sn-list-paren-count )
    (let ([correct '(
		     8
		     10
		     6
		     2
		     6
		     )]
          [answers 
            (list 
	     (sn-list-paren-count (quote ((()) ())))
	     (sn-list-paren-count (quote ((1) (2) ((3)))))
	     (sn-list-paren-count (quote (((1 2)) 1 2)))
	     (sn-list-paren-count (quote ()))
	     (sn-list-paren-count (quote (((1)))))
	     )])
      (display-results correct answers equal?)))


(define (test-sn-list-reverse)
    (let ([correct '(
		     ()
		     (1)
		     (a b)
		     (((a b)))
		     (((f e) d) () (c b) a)
		     (((5) 4) 3 (2 1))
		     )]
          [answers 
            (list 
	     (sn-list-reverse (quote ()))
	     (sn-list-reverse (quote (1)))
	     (sn-list-reverse (quote (b a)))
	     (sn-list-reverse (quote (((b a)))))
	     (sn-list-reverse (quote (a (b c) () (d (e f)))))
	     (sn-list-reverse '((1 2) 3 (4 (5))))
	     )])
      (display-results correct answers equal?)))


(define (test-sn-list-occur)
    (let ([correct '(
		     0
		     1
		     5
		     3
		     1
		     )]
          [answers 
            (list 
	     (sn-list-occur (quote a) (quote (1 2 3 4 (5 (6 (7))))))
	     (sn-list-occur (quote x) (quote (a b c (d (e (f g (x) h i))) j)))
	     (sn-list-occur (quote z) (quote (z (a (b z) z) z z)))
	     (sn-list-occur (quote a) (quote (a (((((a))) a)))))
	     (sn-list-occur (quote f) (quote (f)))
	     )])
      (display-results correct answers equal?)))

(define (test-sn-list-depth)
    (let ([correct '(
		     1
		     1
		     4
		     5
		     2
		     2
		     4
		     )]
          [answers 
            (list 
	     (sn-list-depth (quote ()))
	     (sn-list-depth (quote (x)))
	     (sn-list-depth (quote (a (b (c (d)) e))))
	     (sn-list-depth (quote (((((1) 2) () 3) 4) 5)))
	     (sn-list-depth (quote (a (b c) d)))
	     (sn-list-depth '(()))
	     (sn-list-depth '(((3) (( )) 2) (2 3) 1))
	     )])
      (display-results correct answers equal?)))

(define (test-bt-sum)
    (let ([correct '(
		     28
		     9
		     )]
         [answers 
            (list 
	     (bt-sum (quote (a (b 3 (c 2 1)) (d (e (f 4 5) 6) 7))))
	     (bt-sum 9)
	     )])
      (display-results correct answers equal?)))

(define (test-bt-inorder)
    (let ([correct '(
		     (b c a f e d)
		     ()
		     (e f d a b c)
		     )]
          [answers 
            (list 
	     (bt-inorder (quote (a (b 3 (c 2 1)) (d (e (f 4 5) 6) 7))))
	     (bt-inorder 9)
	     (bt-inorder (quote (a (d (e 6 (f 4 5)) 7) (b 3 (c 2 1)))))
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
  (display 'sn-list-sum) 
  (test-sn-list-sum)
  (display 'sn-list-map) 
  (test-sn-list-map)
  (display 'sn-list-paren-count ) 
  (test-sn-list-paren-count )
  (display 'sn-list-reverse) 
  (test-sn-list-reverse)    
  (display 'sn-list-occur) 
  (test-sn-list-occur)
  (display 'sn-list-depth) 
  (test-sn-list-depth)  
  (display 'bt-sum) 
  (test-bt-sum)  
  (display 'bt-inorder) 
  (test-bt-inorder)


)

(define r run-all)

