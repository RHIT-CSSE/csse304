;; Starting code for Problem 2:

(define pascal-triangle
  (lambda (n)
    (cond [(< n 0) '()]
          [(= n 0) '((1))]
          [else (let ([triangle-n-1 (pascal-triangle (- n 1))]) 
                  (cons (new-row triangle-n-1) triangle-n-1))])))

;; create the kth row for a pascal triangle that already has k-1 rows.
(define new-row
  (lambda (triangle-list) ; triangle-list contains rows of triangle up to n-1
     (cons 1 (row-helper (car triangle-list)))))
      
;; Uses the formula that (for all but the first and last numbers of the row)
;; each number is the sum of the two numbers "above" it in the triangle.
(define row-helper
  (lambda (prev-row)
    (if (null? (cdr prev-row)) ;; I could write (if (< (length prev-row) 2),
        '(1)                   ;; but that greatly increases the running time.
        (cons (+ (car prev-row) (cadr prev-row))
              (row-helper (cdr prev-row))))))


;; Test code 

(define (test-transitive-closure)
    (let ([correct '(
		     ()
		     ((a b) (a a))
		     ((a a) (b c) (a b) (a c))
		     ((a b) (b c) (d a) (a c) (d c) (d b))
		     ((a c) (b a) (a b) (d a) (d c) (c a) (c c)
		      (b c) (b b) (a a) (c b) (d b))
		     ((a b) (b c) (a c))
		     ((e d) (a c) (b a) (a b) (d a) (d c) (c a)
		      (c c) (e c) (e b) (b c) (b b) (a a) (e a) (c b) (d b))
		     ((a b) (a a) (b b) (b a))
		     ((a b) (b a) (a a) (b b))
		     )]
          [answers 
           (list
	    (transitive-closure '())
	    (transitive-closure '((a a) (a b)))
	    (transitive-closure '((a a) (a b) (b c)))
	    (transitive-closure '((a b) (b c) (d a)))
	    (transitive-closure '((a b) (b c) (d a) (c a)))
	    (transitive-closure '((a b) (b c) (a c)))
	    (transitive-closure '((a b) (b c) (d a) (c a) (e d)))
	    (transitive-closure '((a a) (a b) (b a)))
	    (transitive-closure '((a b) (b a)))
	    )])
      (display-results correct answers sequal?-grading)))

(define (test-pascal-triangle-cps)
    (let ([correct '(
		     ((1 4 6 4 1) (1 3 3 1) (1 2 1) (1 1) (1))
		     ((1 3 3 1) (1 2 1) (1 1) (1))
		     (1 10 45 120 210 252 210 120 45 10 1)
		     (1 12 66 220 495 792 924 792 495 220 66 12 1)
		     )]
          [answers 
           (list
	    (pascal-triangle-cps 4 (init-k))
	    (pascal-triangle-cps 3 (init-k))
	    (pascal-triangle-cps 10 (car-k))
	    (pascal-triangle-cps 12 (car-k))
	     )])
      (display-results correct answers equal?)))

(define (test-pt-imp) ; extra-credit
    (let ([correct '(
		     ((1 6 15 20 15 6 1) (1 5 10 10 5 1)
		      (1 4 6 4 1) (1 3 3 1) (1 2 1) (1 1) (1))
		     ((1 5 10 10 5 1) (1 4 6 4 1) (1 3 3 1) (1 2 1) (1 1) (1))
		     (1 9 36 84 126 126 84 36 9 1)
		     (1 16 120 560 1820 4368 8008 11440 12870
			11440 8008 4368 1820 560 120 16 1)
		     )]
          [answers 
            (list 
	     (begin (set! k (init-k)) (set! n 6) (pt-imp))
	     (begin (set! k (init-k)) (set! n 5) (pt-imp)) 
	     (begin (set! k (car-k)) (set! n 9) (pt-imp))
	     (begin (set! k (car-k)) (set! n 16) (pt-imp))

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
  (display 'transitive-closure) 
  (test-transitive-closure) 
  (display 'pascal-triangle-cps) 
  (test-pascal-triangle-cps)
  (display 'pt-imp) 
  (test-pt-imp)
)

(define r run-all)

