;; Test code 


(define (test-for)
    (let ([correct '(
		     256
		     ((4 5 6))
		     (9)
		     0
		     (16)
		     (144 1000)
		     (625)
)]
          [answers 
            (list 
	     (eval-one-exp
	      '(let ([x (list 2)])
		 (for j := -1 to 1 do
		      (set-car! x (* (car x) (car x)))) (car x)))
	     (eval-one-exp
	      '(let ([LoL (list (list 1 2 3))])
		 (for i := 5 to 7 do
		      (set-car! LoL (map add1 (car LoL)))) LoL))
	     (eval-one-exp
	      '(let ([list-of-num (list 0)])
		 (for i := 1 to 3 do
		      (set-car! list-of-num
				(+ (car list-of-num)
				   (- (* 2 i) 1))))
		 list-of-num)) 
	    (eval-one-exp
	     '(let ([list-of-num (list 0)])
		(for i := 12 to 1 do
		     (set-car! list-of-num (+ (car list-of-num)
					      (- (* 2 i) 1))))
		list-of-num))
	    (eval-one-exp
	     '(let ([list-of-num (list 0)] [start 1])
		(for i := (+ start 3) downto 1 do
		     (set-car! list-of-num (+ (car list-of-num)
					      (- (* 2 i) 1))))
		list-of-num))
	    (eval-one-exp
	     '(let ([list-of-num (list 0)] [i 1000])
		(for i := 12 downto 1 do
		     (set-car! list-of-num
			       (+ (car list-of-num)
				  (- (* 2 i) 1))))
		(list (car list-of-num) i)))
(eval-one-exp
 '(let ([list-of-num (list 0)])
    (for i := (let ([list-of-num (list 0)])
		(for i := 5 downto 1 do
		     (set-car! list-of-num
			       (+ (car list-of-num)
				  (- (* 2 i) 1))))
		(car list-of-num))
	 downto 1 do
	 (set-car! list-of-num
		   (+ (car list-of-num)
		      (- (* 2 i) 1))))
    list-of-num))

)])
      (display-results correct answers equal?)))

(define (test-for)
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
  (display 'for) 
  (test-for)
)

(define r run-all)

