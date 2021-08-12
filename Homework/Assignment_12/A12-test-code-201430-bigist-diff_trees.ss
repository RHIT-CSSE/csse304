;; Test code for CSSE 304 Assignment 7

; Why did I use FLUID-LET instead of DEFINE (which is in the on-line 
; test cases) for BigNums?  In my off-line test code, I always make a 
; list of results, and all of those DEFINEs are illegal inside the call to list.
; The first thought might be to use LET instead of define.  But that has a 
; problem, too.  Binding with LET is lexical.  The code for SUCC, for 
; example, refers to BASE, which is not locally bound in the code for SUCC.
; Binding it lexically outside the CALL to SUCC doesn't help.  But
; FLUID-LET does dynamic (not lexical) binding, saying, "while the inner 
; code (call to a bignul procedure) is being EXECUTED, let BASE be 4 
; (or whatever number we want it to be)


(define BASE 8)


(define (test-bignums)
    (let ([correct '(
		     ()
		     (1)
		     (0 1)
		     (1)
		     ()
		     (0 1)
		     (1 0 4)
		     (7 7 3)
		     3216
		     (0 3 6 2)
		     (1 0 0 1)
		     (2)
		     ()
		     ()
		     (4 1)
		     (7 7 7)
		     (7 7 7 7)
		     (1)
		     (0 2 2)
		     (0 2 3 0 4)
		     (0 0 0 0 1 0 1 1 0 1)
		     720
		     )]
          [answers 
            (list 
	     (fluid-let ([BASE 2]) (zero))
	     (fluid-let ([BASE 2]) (succ (zero)))
	     (fluid-let ([BASE 2]) (succ (succ (zero))))
	     (fluid-let ([BASE 2]) (pred (succ (succ (zero)))))
	     (fluid-let ([BASE 2]) (pred (pred (succ (succ (zero))))))
	     (fluid-let ([BASE 8]) (succ '(7 0)))
	     (fluid-let ([BASE 8]) (int->bignum 257))
	     (fluid-let ([BASE 8]) (int->bignum 255))
	     (fluid-let ([BASE 8]) (bignum->int (int->bignum 3216)))
	     (fluid-let ([BASE 7]) (succ (succ(int->bignum 999))))
	     (fluid-let ([BASE 6]) (plus (int->bignum 200) (int->bignum 17)))
	     (fluid-let ([BASE 6]) (plus (int->bignum 1) (int->bignum 1)))
	     (fluid-let ([BASE 8]) (multiply (int->bignum 2) (int->bignum 0)))
	     (fluid-let ([BASE 8]) (multiply (int->bignum 0) (int->bignum 2)))
	     (fluid-let ([BASE 8]) (multiply (int->bignum 12) (int->bignum 1)))
	     (fluid-let ([BASE 8]) (multiply (int->bignum 7) (int->bignum 73)))
	     (fluid-let ([BASE 8]) (multiply (succ (int->bignum 64)) (pred (int->bignum 64))))
	     (fluid-let ([BASE 10]) (factorial '()))
	     (fluid-let ([BASE 3]) (factorial '(1 1)))
	     (fluid-let ([BASE 10]) (factorial '(8)))
	     (fluid-let ([BASE 2]) (factorial (int->bignum 6)))
	     (fluid-let ([BASE 2]) (bignum->int (factorial (int->bignum 6))))
	     )])
      (display-results correct answers equal?)))

(define (test-diff-trees)
    (let ([correct '(
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     #t
		     )]
          [answers 
            (list 
	     (and (dt? '(one)) (not (dt? '(diff (one) (one) (one)))))
	     (let* ([one '(one)] [zero '(diff (one) (one))]) (and (dt= (dt+ one zero) one) (not (dt= (dt+ one zero) zero))))
	     (let ([one '(one)]) (and (dt= (dt- (dt+ one one) one) one) (not (dt= (dt+ one one) one))))
	     (let ([num-list1 '(3 5 -2 -5 1 0)] [num-list2 '(2 8 -7 4 0 12)]) (equal? (map (lambda (x y) (dt->integer (dt- (integer->dt x) (integer->dt y)))) num-list1 num-list2) (map - num-list1 num-list2)))
	     (let ([thirteen (integer->dt 13)] [nineteen (integer->dt 19)] [sixteen (integer->dt 16)] [fifty (integer->dt 50)] [minus-eightteen (integer->dt -18)]) (and (dt= (dt+ thirteen nineteen) (dt+ sixteen sixteen)) (dt= (dt+ thirteen nineteen) (dt+ fifty minus-eightteen))))
	     (let ([thirteen (integer->dt 13)] [twenty-one (integer->dt 21)] [seventeen (integer->dt 17)] [fifty (integer->dt 50)] [minus-sixteen (integer->dt -16)]) (and (dt= (dt+ thirteen twenty-one) (dt+ seventeen seventeen)) (dt= (dt+ thirteen twenty-one) (dt+ fifty minus-sixteen))))
	     (let* ([one '(one)] [two (dt+ one one)] [three (dt+ one two)] [four (dt+ two two)] [seven (dt+ three four)]) (dt= (dt-negate seven) (integer->dt -7)))
	     )])
      (display-results correct answers equal?)))

(define (test-bintree-to-list)
    (let ([correct '(
		     (leaf-node 3)
		     (interior-node a (interior-node b (interior-node c (leaf-node 1) (interior-node d (leaf-node 2) (leaf-node 3))) (interior-node e (leaf-node 5) (leaf-node 6))) (interior-node f (interior-node g (interior-node h (interior-node i (leaf-node 7) (leaf-node 8)) (leaf-node 9)) (leaf-node 10)) (leaf-node 11)))
		     (interior-node a (interior-node b (interior-node c (interior-node d (interior-node e (interior-node f (interior-node g (interior-node h (interior-node i (interior-node j (interior-node k (interior-node l (interior-node m (interior-node n (interior-node o (interior-node p (interior-node q (interior-node r (interior-node s (interior-node t (interior-node u (interior-node v (interior-node w (interior-node x (interior-node y (interior-node z (leaf-node 1) (leaf-node 2)) (leaf-node 3)) (leaf-node 4)) (leaf-node 5)) (leaf-node 6)) (leaf-node 7)) (leaf-node 8)) (leaf-node 9)) (leaf-node 10)) (leaf-node 11)) (leaf-node 12)) (leaf-node 13)) (leaf-node 14)) (leaf-node 15)) (leaf-node 16)) (leaf-node 17)) (leaf-node 18)) (leaf-node 19)) (leaf-node 20)) (leaf-node 21)) (leaf-node 22)) (leaf-node 23)) (leaf-node 24)) (leaf-node 25)) (leaf-node 26)) (leaf-node 27))
		     )]
          [answers 
            (list 
	     (bintree-to-list (leaf-node 3))
	     (bintree-to-list (interior-node (quote a) (interior-node (quote b) (interior-node (quote c) (leaf-node 1) (interior-node (quote d)(leaf-node 2) (leaf-node 3))) (interior-node (quote e) (leaf-node 5) (leaf-node 6))) (interior-node (quote f) (interior-node (quote g) (interior-node (quote h) (interior-node (quote i) (leaf-node 7) (leaf-node 8)) (leaf-node 9)) (leaf-node 10)) (leaf-node 11))))
	     (bintree-to-list (interior-node (quote a) (interior-node (quote b) (interior-node (quote c) (interior-node (quote d) (interior-node (quote e) (interior-node (quote f) (interior-node (quote g) (interior-node (quote h) (interior-node (quote i) (interior-node (quote j) (interior-node (quote k) (interior-node (quote l) (interior-node (quote m) (interior-node (quote n) (interior-node (quote o) (interior-node (quote p) (interior-node (quote q) (interior-node (quote r) (interior-node (quote s) (interior-node (quote t) (interior-node (quote u) (interior-node (quote v) (interior-node (quote w) (interior-node (quote x) (interior-node (quote y) (interior-node (quote z) (leaf-node 1) (leaf-node 2)) (leaf-node 3)) (leaf-node 4)) (leaf-node 5)) (leaf-node 6)) (leaf-node 7)) (leaf-node 8)) (leaf-node 9)) (leaf-node 10)) (leaf-node 11)) (leaf-node 12)) (leaf-node 13)) (leaf-node 14)) (leaf-node 15)) (leaf-node 16)) (leaf-node 17)) (leaf-node 18)) (leaf-node 19)) (leaf-node 20)) (leaf-node 21)) (leaf-node 22)) (leaf-node 23)) (leaf-node 24)) (leaf-node 25)) (leaf-node 26)) (leaf-node 27)))
	     )])
      (display-results correct answers equal?)))

(define (test-max-interior)
    (let ([correct '(
		     q
		     e
		     a
		     b
		     f
		     a
		     b
		     )]
          [answers 
            (list 
	     (max-interior (interior-node (quote a) (interior-node (quote b) (leaf-node -21) (interior-node (quote d) (leaf-node 4) (interior-node (quote e) (leaf-node 5) (leaf-node 6)))) (interior-node (quote q) (leaf-node 4) (interior-node (quote r) (leaf-node -2) (leaf-node 70)))))
	     (max-interior (interior-node (quote a) (interior-node (quote b) (leaf-node -3) (leaf-node -4)) (interior-node (quote c) (leaf-node -1) (interior-node (quote d) (leaf-node -1) (interior-node (quote e) (leaf-node -1) (leaf-node -5))))))
	     (max-interior (interior-node (quote a) (leaf-node -100) (leaf-node -50)))
(max-interior (interior-node (quote a) (interior-node (quote b) (interior-node (quote e) (leaf-node -10) (leaf-node -100)) (leaf-node 100)) (interior-node (quote c) (leaf-node 100) (interior-node (quote f) (leaf-node -100) (leaf-node -11)))))
(max-interior (interior-node (quote a) (interior-node (quote b) (interior-node (quote e) (leaf-node -10) (leaf-node 100)) (leaf-node -100)) (interior-node (quote c) (leaf-node -100) (interior-node (quote f) (leaf-node 100) (leaf-node 10)))))
(max-interior (interior-node (quote a) (interior-node (quote b) (interior-node (quote c) (leaf-node 1) (interior-node (quote d) (leaf-node 2) (leaf-node 3))) (interior-node (quote e) (leaf-node 5) (leaf-node 6))) (interior-node (quote f) (interior-node (quote g) (interior-node (quote h) (interior-node (quote i) (leaf-node 7) (leaf-node 8)) (leaf-node 9)) (leaf-node 10)) (leaf-node 11))))
(max-interior (interior-node (quote a) (leaf-node -3) (interior-node (quote b) (leaf-node 2) (interior-node (quote c) (leaf-node -1234567890) (leaf-node (* -123099487598375943759874 98734598743598585024320))))))
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
  (display 'bignums) 
  (test-bignums)
  (display 'diff-trees) 
  (test-diff-trees)  
  (display 'bintree-to-list) 
  (test-bintree-to-list)  
  (display 'max-interior) 
  (test-max-interior)
)

(define r run-all)

