;; Test code for CSSE 304 Assignment 6

(define (test-curry2)
    (let ([correct '(
		     6
		     (17 . 29)
		     )]
          [answers 
            (list 
	     (((curry2 -) 8) 2)
	     (let([conscurry (curry2 cons)]) ((conscurry 17) 29))	     
	     )])
      (display-results correct answers equal?)))



(define (test-curried-compose)
  (let ([correct '(arg 1)]
        [answers 
          (list  
	   (((curried-compose car) list) 'arg)
	   (((curried-compose car) car)  '((1 7) (2 9)))
	   )])
    (display-results correct answers equal?)))



(define (test-compose)
  (let ([correct '(1 2)]
        [answers 
          (list
	   ((compose car car) '((1 7) (2 9)))
	   ((compose car car cdr) '((1 7) (2 9)))
          )])
    (display-results correct answers equal?)))



(define (test-make-list-c)
  (let ([correct '(
		  (7 7 7 7)
		  (() () () () ())
		  ()
		   )]
        [answers 
	 (list
	   ((make-list-c 4) 7)
	   ((make-list-c 5) '())
	   ((make-list-c 0) 10)
	 )])
    (display-results correct answers equal?)))

(define (test-reverse-it)
    (let ([correct '(
		     ()
		     (1)
		     (5 4 3 2 1)
		     )]
          [answers 
            (list 
	     (reverse-it '())
	     (reverse-it '(1))
	     (reverse-it '(1 2 3 4 5))
	     )])
      (display-results correct answers equal?)))



(define (test-map-by-position )
    (let ([correct '(
		     (2 2 2 2 2)
		     )]
          [answers 
            (list 
	     (map-by-position (list cadr - length add1 (lambda(x)(- x 3))) 
			      '((1 2) -2 (3 4) 1 5))
	     )])
      (display-results correct answers equal?)))



(define (test-BST)
    (let ([correct '(
		     #t
		     ()
		     (1)
		     (1 2)
		     (1 2 3)
		     (1 3 4 5 6 7 8 9)
		     (1 3 4 5 6 7 8 9)
		     8
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     (2 (1 2 3))
		     (3 (1 3 4 5 6 7 8 9))
		     (6 (3 10 14 15 16 17 18 19))
		     )]
          [answers 
            (list 
	     (empty-BST? (empty-BST))
	     (BST-inorder (empty-BST))
	     (BST-inorder (BST-insert 1 (empty-BST)))
	     (BST-inorder (BST-insert 1 (BST-insert 2 (empty-BST))))
	     (BST-inorder (BST-insert 2 (BST-insert 1 (BST-insert 3 (empty-BST)))))
	     (BST-inorder (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 8)))
	     (BST-inorder (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 6 8)))
	     (BST-element (BST-left (BST-right (BST-right 
		 (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 8))))))
	     (and (not (BST-contains? (empty-BST) 1)) 
		  (BST-contains? (BST-insert 1 (empty-BST)) 1))
	     (and (not (BST-contains? (empty-BST) 1)) 
		  (BST-contains? (BST-insert-nodes (empty-BST) 
						   '(4 7 3 9 6 1 5 8)) 
				 8))
	     (and (not (BST-contains? (BST-insert-nodes (empty-BST) 
							'(4 7 3 9 6 1 5 8)) 
				      10)) 
		  (BST-contains? (BST-insert 1 (empty-BST)) 1))
	     (and (not (BST-contains? (empty-BST) 1)) 
		  (BST-contains? (BST-insert-nodes (empty-BST) 
						   '(4 7 3 9 6 1 5 8)) 
				 1))
	     (and (not (BST-contains? (BST-insert-nodes (empty-BST) 
							'(4 7 3 9 6 1 5 8)) 
				      2)) 
		  (BST-contains? (BST-insert 1 (empty-BST)) 1))
	     (and (not (BST-contains? (empty-BST) 1)) 
		  (BST-contains? (BST-insert-nodes (empty-BST) 
						   '(4 7 3 9 6 1 5 8)) 
				 4))
	     (and (not (BST-contains? (BST-insert-nodes (empty-BST) 
							'(4 7 3 9 6 1 5 8)) 
				      0)) 
		  (BST-contains? (BST-insert 1 (empty-BST)) 1))
	     (and (not (BST? #t)) (BST? '()))
	     (and (not (BST? '(1))) (BST? '()))
	     (and (not (BST? '(1 2 3))) (BST? '()))
	     (and (not (BST? '(1 ()))) (BST? '()))
	     (and (BST? '(1 () ())) (BST? '()))
	     (and (not (BST? '(a () ()))) (BST? '()))
	     (and (not (BST? '(1 (2 () ()) ()))) (BST? '()))
	     (and (not (BST? #t)) (BST? '(1 () (3 (2 () ()) ()))))
	     (and (not (BST? '(4 () (6 (3 () ()) ())))) (BST? '()))
	     (let ([t (BST-insert 2 (BST-insert 1 (BST-insert 3 (empty-BST))))])
	       (list (BST-height t) (BST-inorder t)))
	     (let ([t (BST-insert-nodes (empty-BST) '(4 7 3 9 6 1 5 8))])
	       (list (BST-height t) (BST-inorder t)))
	     (let ([t (BST-insert-nodes (empty-BST) '(10 3 19 18 14 17 16 15))])
	       (list (BST-height t) (BST-inorder t)))
	     )])
      (display-results correct answers equal?)))




(define (test-let->application)
  (let ([correct '(
		   ((lambda (a b) (let ((c b)) (+ a b c))) 4 5)
		   ((lambda () (+ 2 3)))
		   ((lambda (a b c) 
		      (let ((d 3)) 
			(+ a b c d))) 
		    2 1 5)
		   )]
        [answers 
          (list
	   (let->application (quote (let ((a 4) (b 5)) (let ((c b)) (+ a b c)))))	
	   (let->application '(let () (+ 2 3)))
	   (let->application
	    '(let ([a 2] [b 1] [c 5])
	       (let ([d 3])
		 (+ a b c d))))
	   )])
    (display-results correct answers equal?)))

(define (test-let*->let  )
  (let ([correct '(
		   (let ((x 0)) x)
		   (let ((x 50)) 
		     (let ((y (+ x 50))) 
		       (let ((z (+ y 50))) 
			 z)))
		   (let ((x (let ((y 1)) y))) 
		     (let ((z x)) 
		       x))
		   )]
        [answers 
          (list
	   (let*->let (quote (let* ((x 0)) x)))
	   (let*->let 
	    (quote (let* ((x 50) 
			  (y (+ x 50)) 
			  (z (+ y 50)))  
		     z)))
	   (let*->let 
	    (quote 
	     (let* ((x (let ((y 1)) y)) 
		    (z x)) 
	       x)))
	  )])
    (display-results correct answers equal?)))


(define (test-qsort)
    (let ([correct '(
		     ()
		     (9 7 5 4 2)
		     (6 5 4 3 2 1)
		     (6 5 5 4 3 2 1 1)
		     ("rose-hulman" "great" "day" "at" "a")
		     )]
          [answers 
            (list 
	     (qsort <= (quote ()))
	     (qsort >= (quote (7 2 5 9 4)))
	     (qsort >= (quote (6 3 2 4 1 5)))
	     (qsort >= (quote (1 6 5 4 3 2 1 5)))
	     (qsort string>=? (quote ("a" "great" "day" "at" "rose-hulman")))
	     )])
      (display-results correct answers equal?)))



(define (test-sort-list-of-symbols)
  (let ([correct '(
		   (ab b b c d f g m r)
		   (b)
		   ()
		   )]
        [answers 
          (list
	   (sort-list-of-symbols '(b c d g ab f b r m))
	   (sort-list-of-symbols '(b))
	   (sort-list-of-symbols '())
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
  (display 'curry2) 
  (test-curry2)
  (display 'curried-compose) 
  (test-curried-compose)
  (display 'compose) 
  (test-compose)
  (display 'make-list-c) 
  (test-make-list-c)
  (display 'reverse-it ) 
  (test-reverse-it)
  (display 'map-by-position) 
  (test-map-by-position )
  (display 'BST) 
  (test-BST)  
  (display 'let->application) 
  (test-let->application)
  (display 'let*->let  ) 
  (test-let*->let)
  (display 'qsort) 
  (test-qsort)    
  (display 'sort-list-of-symbols) 
  (test-sort-list-of-symbols)

)

(define r run-all)

