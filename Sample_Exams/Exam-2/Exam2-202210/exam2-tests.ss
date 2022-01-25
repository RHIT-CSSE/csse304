
(define (test-remove-depth-cps)
  (let ([correct '(((a b c d e))
                   (a (b) c d ((e)))
                   (a (b c) (d (e)))
                   (a ((b) c) (d (e)))
                   (a ((b) c) (d ((e))))
                   )]
        [answers 
         (list (remove-depth-cps 2 '(a (b c) (d e)) list) ; note in this case I pass list as the continuation
               (remove-depth-cps  2 '(a ((b) c) (d ((e)))) (lambda (x) x))
               (remove-depth-cps  3 '(a ((b) c) (d ((e)))) (lambda (x) x))
               (remove-depth-cps  4 '(a ((b) c) (d ((e)))) (lambda (x) x))
               (remove-depth-cps  5 '(a ((b) c) (d ((e)))) (lambda (x) x))
               )])

    (display-results correct answers equal?)))


(define (test-swap)
    (let ([correct '(
		     (2 1)
                     (1 2)
		     (1 3 2))]
          [answers 
           (list
            (let ((x 1) (y 2)) (swap! x y) (list x y))
            (let ((x 1) (y 2)) (swap! x y) (swap! x y) (list x y))
            (let ((foo 1) (bar 2) (baz 3)) (swap! foo bar) (swap! bar baz) (swap! baz foo) (list foo bar baz))
	     )])
      (display-results correct answers equal?)))


(define (test-simplecase)
    (let ([correct '(
		     1
		     2
		     3
		     7
		     #t
		     )]
          [answers 
            (list 
	     (eval-one-exp ' 
	      (simplecase 'a (a 1) (b 2) (c 3)))
             (eval-one-exp ' 
	      (simplecase 'b (a 1) (b 2) (c 3)))
             (eval-one-exp ' 
	      (simplecase 'c (a 1) (b 2) (c 3)))
             (eval-one-exp ' 
	      (simplecase (if #t 'a 'b) (a (+ 3 4)) (b 2) (c 3)))
             (eval-one-exp ' 
	      (equal? (if #f 1) (simplecase 'z (a (+ 3 4)) (b 2) (c 3))))

	     )])
      (display-results correct answers equal?)))


(define (test-namespace)
    (let ([correct '(
		     1
		     2
		     201
		     30
		     21
                     3120
		     )]
          [answers 
            (list 
	     (eval-one-exp ' 
	      (use-namespace (make-namespace ((a 1) (b 2))) a))
             (eval-one-exp ' 
	      (use-namespace (make-namespace ((a (+ 1 0)) (b (+ 2 0)))) b))
	     (eval-one-exp ' 
	      (let ((ns1 (make-namespace ((a 1))))
                    (ns2 (make-namespace ((a 10) (b 20))))
                    (a 100)
                    (b 200))
                (use-namespace ns1 (+ a b))))
	     (eval-one-exp ' 
	      (let ((ns1 (make-namespace ((a 1))))
                    (ns2 (make-namespace ((a 10) (b 20))))
                    (a 100)
                    (b 200))
                (use-namespace ns2 (+ a b))))
	     (eval-one-exp ' 
	      (let ((ns1 (make-namespace ((a 1))))
                    (ns2 (make-namespace ((a 10) (b 20))))
                    (a 100)
                    (b 200))
                (use-namespace ns2 (use-namespace ns1 (+ a b)))))
	     (eval-one-exp ' 
	      (let ((ns1 (make-namespace ((a 1))))
                    (ns2 (make-namespace ((a 10) (b 20))))
                    (a 100)
                    (b 200))
                (+ (use-namespace ns2 (let ((a 3000)) (+ a b))) a)))
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
  (display 'test-remove-depth-cps)
  (test-remove-depth-cps)
  (display 'test-swap)
  (test-swap)
  (display 'test-simplecase)
  (test-simplecase)
  (display 'test-namespace)
  (test-namespace)
)

(define r run-all)

