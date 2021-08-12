;; Test code for CSSE 304 Assignment 11


(define (test-my-let)
    (let ([correct '(
		     1
		     55
		     123
		     3
		     )]
          [answers 
            (list 
	     (my-let ((a 1)) a)

	     (my-let loop 
		     ((L (quote (1 2 3 4 5 6 7 8 9 10))) 
		      (A 0)) 
		     (if (null? L) 
			 A 
			 (loop (cdr L) 
			       (+ (car L) A))))
	     (my-let ((a 5)) 
		     (+ 3 
			(my-let fact ((n a)) 
				(if (zero? n) 
				    1 
				    (* n (fact (- n 1)))))))
	     (my-let ((a (lambda () 3))) 
		     (my-let ((a (lambda () 5)) 
			      (b a)) 
			     (b)))
	     )])
      (display-results correct answers equal?)))

(define (test-my-or)
    (let ([correct '(
		     #t
		     (#(2 s c) 5 2)
		     #t
		     #f
		     1
		     4
		     1
		     6
		     )]
          [answers 
            (list 
	     (begin (set! a #f) 
		    (my-or #f 
			   (begin 
			     (set! a (not a)) 
			     a) 
			   #f))
	     (let loop ((L (quote (a b 2 5 #f (a b c) #(2 s c) foo a))) 
			(A (quote ()))) 
	       (if (null? L) 
		   A 
		   (loop (cdr L) 
			 (if (my-or (number? (car L)) 
				    (vector? (car L)) 
				    (char? (car L))) 
			     (cons (car L) A) 
			     A))))
	     (let loop ((L (quote (1 2 3 4 5 a 6)))) 
	       (if (null? L) 
		   #f 
		   (my-or (symbol? (car L)) 
			  (loop (cdr L)))))
	     (my-or)
	     (let ([x 0]) 
	       (if (my-or 
		    #f 
		    4 
		    (begin (set! x 12) 
			   #t)) 
		   (set! x (+ x 1)) 
		   (set! x (+ x 3))) 
	       x)
	     (my-or #f 4 3)
	     (let ([x 0]) 
	       (my-or (begin (set! x (+ 1 x)) 
			     x) 
		      #f))
	     (my-or 6)
	     )])
      (display-results correct answers equal?)))

(define (test-+=)
    (let ([correct '(
		     25
		     (41 31 41)
		     )]
          [answers 
            (list 
	     (let ([a 5]) 
	       (+= a 10) 
	       (+ a 10))
	     (begin (let* ((a 10) (b 21) (c (+= a (+= b a)))) (list a b c)))
	     )])
      (display-results correct answers equal?)))

(define (test-return-first)
    (let ([correct '(
		     2
		     5
		     3
		     (5 3)
		     )]
          [answers 
            (list 
	     (return-first 2)
	     (begin (let ([a 3]) 
		      (return-first (+ a 2) 
				    (set! a 7) 
				    a)))
	     (return-first (return-first 
			    3 
			    4 
			    5) 
			   1 
			   2)
	     (let ([a 4]) 
	       (let ([b (return-first 3 
				      (set! a 5) 
				      2)]) 
		 (list a b)))
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
		     an
		     br
		     ak
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
(max-interior
 '(interior-node
   aa
   (interior-node
    ab
    (interior-node
     ac
     (interior-node
      ad
      (interior-node ae (leaf-node 24) (leaf-node -75))
      (interior-node af (leaf-node 55) (leaf-node 34)))
     (interior-node
      ag
      (interior-node ah (leaf-node 15) (leaf-node -78))
      (interior-node ai (leaf-node -31) (leaf-node -11))))
    (interior-node
     aj
     (interior-node
      ak
      (interior-node al (leaf-node 40) (leaf-node -55))
      (interior-node am (leaf-node 48) (leaf-node -21)))
     (leaf-node -77)))
   (interior-node
    an
    (interior-node
     ao
     (interior-node
      ap
      (leaf-node -76)
      (interior-node aq (leaf-node 41) (leaf-node 67)))
     (interior-node
      ar
      (leaf-node 50)
      (interior-node as (leaf-node 60) (leaf-node -27))))
    (interior-node
     at
     (leaf-node 16)
     (interior-node
      au
      (interior-node av (leaf-node 62) (leaf-node -58))
      (interior-node aw (leaf-node -9) (leaf-node 72)))))))
(max-interior
  '(interior-node
     aa
     (interior-node
       ab
       (interior-node
         ac
         (interior-node
           ad
           (interior-node
             ae
             (interior-node
               af
               (interior-node ag (leaf-node 5) (leaf-node 74))
               (leaf-node 37))
             (leaf-node 31))
           (interior-node
             ah
             (interior-node
               ai
               (interior-node aj (leaf-node 29) (leaf-node -34))
               (interior-node ak (leaf-node -67) (leaf-node 18)))
             (interior-node
               al
               (interior-node am (leaf-node -41) (leaf-node 27))
               (leaf-node 16))))
         (interior-node
           an
           (interior-node
             ao
             (interior-node
               ap
               (interior-node aq (leaf-node 2) (leaf-node -12))
               (interior-node ar (leaf-node -66) (leaf-node 59)))
             (interior-node
               as
               (interior-node at (leaf-node -27) (leaf-node -59))
               (interior-node au (leaf-node -32) (leaf-node 43))))
           (interior-node
             av
             (interior-node
               aw
               (interior-node ax (leaf-node -56) (leaf-node -2))
               (interior-node ay (leaf-node 36) (leaf-node 40)))
             (interior-node
               az
               (interior-node ba (leaf-node -65) (leaf-node 76))
               (interior-node bb (leaf-node -48) (leaf-node -47))))))
       (interior-node
         bc
         (interior-node
           bd
           (interior-node
             be
             (interior-node
               bf
               (leaf-node 15)
               (interior-node bg (leaf-node 75) (leaf-node -77)))
             (interior-node
               bh
               (interior-node bi (leaf-node -24) (leaf-node -45))
               (interior-node bj (leaf-node 64) (leaf-node 1))))
           (interior-node
             bk
             (interior-node
               bl
               (interior-node bm (leaf-node -70) (leaf-node -3))
               (interior-node bn (leaf-node -71) (leaf-node 35)))
             (leaf-node 45)))
         (interior-node bo (leaf-node -78) (leaf-node 47))))
     (interior-node
       bp
       (interior-node
         bq
         (interior-node
           br
           (interior-node
             bs
             (interior-node
               bt
               (interior-node bu (leaf-node 39) (leaf-node 49))
               (interior-node bv (leaf-node -11) (leaf-node 63)))
             (interior-node
               bw
               (interior-node bx (leaf-node 48) (leaf-node -42))
               (interior-node by (leaf-node 25) (leaf-node 33))))
           (interior-node
             bz
             (interior-node
               ca
               (interior-node cb (leaf-node 38) (leaf-node 66))
               (interior-node cc (leaf-node -40) (leaf-node -37)))
             (interior-node
               cd
               (interior-node ce (leaf-node 26) (leaf-node 30))
               (interior-node cf (leaf-node -26) (leaf-node 58)))))
         (interior-node cg (leaf-node 28) (leaf-node -39)))
       (interior-node
         ch
         (interior-node
           ci
           (interior-node
             cj
             (interior-node
               ck
               (interior-node cl (leaf-node -15) (leaf-node -31))
               (interior-node cm (leaf-node -62) (leaf-node 32)))
             (interior-node
               cn
               (interior-node co (leaf-node -54) (leaf-node -57))
               (interior-node cp (leaf-node 13) (leaf-node -73))))
           (interior-node
             cq
             (interior-node
               cr
               (interior-node cs (leaf-node 68) (leaf-node 62))
               (leaf-node 42))
             (leaf-node 65)))
         (interior-node
           ct
           (interior-node
             cu
             (interior-node
               cv
               (interior-node cw (leaf-node -8) (leaf-node -49))
               (interior-node cx (leaf-node 24) (leaf-node -60)))
             (interior-node
               cy
               (interior-node cz (leaf-node 73) (leaf-node -5))
               (interior-node da (leaf-node 46) (leaf-node -43))))
           (leaf-node 20))))))
(max-interior 
 '(interior-node
  aa
  (interior-node
    ab
    (leaf-node -7)
    (interior-node
      ac
      (leaf-node 0)
      (interior-node
        ad
        (interior-node
          ae
          (interior-node af (leaf-node -2) (leaf-node -10))
          (interior-node ag (leaf-node 1) (leaf-node -9)))
        (interior-node
          ah
          (leaf-node 5)
          (interior-node ai (leaf-node -3) (leaf-node -12))))))
  (interior-node
    aj
    (leaf-node -1)
    (interior-node
      ak
      (interior-node
        al
        (interior-node
          am
          (interior-node an (leaf-node -4) (leaf-node -8))
          (interior-node ao (leaf-node -5) (leaf-node 12)))
        (interior-node
          ap
          (interior-node aq (leaf-node 2) (leaf-node 11))
          (interior-node ar (leaf-node 7) (leaf-node 6))))
      (interior-node as (leaf-node 9) (leaf-node 10))))))
)])
(display-results correct answers equal?)))


(define (test-parse-unparse)
    (let ([correct '(
		     x
		     (lambda (x) (+ x 5))
		     (lambda x y z)
		     (let ((x y)) x x x y)
		     (lambda (x) 1 z)
		     (let* ((a b) (c d) (e f)) g h)
		     (let* ((a b)) b)
		     (lambda x x y)
		     (let ((x 1) 
			   (y (let () 
				(let ((z t)) 
				  z)))) 
		       (+ z y))
		     (lambda () 
		       (letrec ((foo 
				 (lambda (L) 
				   (if (null? L) 
				       3 
				       (if (symbol? (car L)) 
					   (cons (car L) 
						 (foo (cdr L))) 
					   (foo (cdr L))))))) foo))
		     (lambda (x) 
		       (if (boolean? x) 
			   '#(1 2 3 4) 1234))
		     (lambda x (car x))
		     (lambda (c) (if (char? c) string 12345))
		     (lambda (datum) 
		       (or (number? datum) 
			   (boolean? datum) 
			   (null? datum) 
			   (string? datum) 
			   (symbol? datum) 
			   (pair? datum) 
			   (vector? datum)))
		     (lambda (t) 
		       (let ((L (build-list t)) 
			     (sum< (lambda (a b) 
				     (< (cdr a) (cdr b)))) 
			     (intsum? (lambda (x) 
					(symbol? (car x))))) 
			 (car (genmax sum< (filter intsum? L)))))
		     (letrec ((a (lambda () (b 2))) 
			      (b (lambda (x) (- x 4)))) 
		       (lambda () (a)))
		     (let* ((a (lambda () (c 4))) 
			    (b a)) 
		       (lambda (b) (a)))
		     (lambda x (cons a x))
		     (lambda x 
		       (let* ((a x) 
			      (b (cons x a))) b))
		     (lambda (a b c) 
		       (let* ((dbl (lambda x 
				     (append x x))) 
			      (lst (dbl a b c))) 
			 lst))
		     (lambda a 
		       (letrec ((stuff (lambda (b) 
					 (if (null? b) 
					     (list) 
					     (cons (car b) 
						   (stuff (cdr b))))))) 
			 (stuff a)))
		     (lambda (a b c) 
		       (let* ((a b) 
			      (d (append a c))) 
			 d))
		     )]
          [answers 
            (list 
	     (unparse-exp (parse-exp (quote x)))
	     (unparse-exp (parse-exp (quote (lambda (x) (+ x 5)))))
	     (unparse-exp (parse-exp (quote (lambda x y z))))
	     (unparse-exp (parse-exp (quote (let ((x y)) x x x y))))
	     (unparse-exp (parse-exp (quote (lambda (x) 1 z))))
	     (unparse-exp (parse-exp (quote (let* ((a b) (c d) (e f)) g h))))
	     (unparse-exp (parse-exp (quote (let* ((a b)) b))))
	     (unparse-exp (parse-exp (quote (lambda x x y))))
	     (unparse-exp (parse-exp (quote (let ((x 1) 
						  (y (let () 
						       (let ((z t)) 
							 z)))) 
					      (+ z y)))))
	     (unparse-exp 
	      (parse-exp 
	       (quote (lambda () 
			(letrec ((foo (lambda (L) 
					(if (null? L) 
					    3 
					    (if (symbol? (car L)) 
						(cons (car L) 
						      (foo (cdr L))) 
						(foo (cdr L))))))) 
			  foo)))))
	     (unparse-exp (parse-exp (quote (lambda (x) 
					      (if (boolean? x) '#(1 2 3 4) 1234)))))
	     (unparse-exp (parse-exp (quote (lambda x (car x)))))
	     (unparse-exp (parse-exp (quote (lambda (c) (if (char? c) string 12345)))))
	     (unparse-exp (parse-exp (quote (lambda (datum) 
					      (or (number? datum) 
						  (boolean? datum) 
						  (null? datum) 
						  (string? datum) 
						  (symbol? datum) 
						  (pair? datum) 
						  (vector? datum))))))
	     (unparse-exp 
	      (parse-exp 
	       (quote 
		(lambda (t) 
		  (let ((L (build-list t)) 
			(sum< (lambda (a b) 
				(< (cdr a) (cdr b)))) 
			(intsum? (lambda (x) 
				   (symbol? (car x))))) 
		    (car (genmax sum< 
				 (filter intsum? L))))))))
	     (unparse-exp (parse-exp (quote (letrec ((a (lambda () 
							  (b 2))) 
						     (b (lambda (x) 
							  (- x 4)))) 
					      (lambda () (a))))))
	     (unparse-exp (parse-exp (quote (let* ((a (lambda () (c 4))) 
						   (b a)) 
					      (lambda (b) (a))))))
	     (unparse-exp (parse-exp (quote (lambda x (cons a x)))))
	     (unparse-exp (parse-exp (quote (lambda x 
					      (let* ((a x) 
						     (b (cons x a))) 
						b)))))
	     (unparse-exp (parse-exp (quote (lambda (a b c) 
					      (let* ((dbl (lambda x 
							    (append x x))) 
						     (lst (dbl a b c))) 
						lst)))))
	     (unparse-exp (parse-exp (quote (lambda a 
					      (letrec ((stuff (lambda (b) 
								(if (null? b) (list) 
								    (cons (car b) 
									  (stuff (cdr b))))))) 
						(stuff a))))))
	     (unparse-exp (parse-exp (quote (lambda (a b c) 
					      (let* ((a b) 
						     (d (append a c))) 
						d)))))
	     )])
      (display-results correct answers equal?)))

; I don't have a simple way to test for parsing erros off-line.
; I wrote this in the familiar form of my test procedures, but you should not actually run it.
; You can read the "correct" answers to get an idea of what the error issue is for each case.
; run each case individually and make sure that it causes an error, with 'parse-exp


(define (test-parse-errors)
    (let ([correct '(
		     (*error* parse-exp "lambda-expression: incorrect length ~s" '((lambda (a))))
		     (*error* parse-exp "lambda-expression: incorrect length ~s" '((lambda x)))
		     (*error* parse-exp "expression ~s is not a proper list" '((a b . c)))
		     (*error* parse-exp "lambda's formal arguments ~s must all be symbols" '((a b 1)))
		     (*error* parse-exp "if-expression ~s does not have (only) test, then, and else" '((if a)))
		     (*error* parse-exp "~s-expression has incorrect length ~s" '(let (let [(a b)])))
		     (*error* parse-exp "~s-expression has incorrect length ~s" '(letrec (letrec [(a b)])))
		     (*error* parse-exp "declarations in ~s-expression not a list ~s" '(let (let [(a b) . c] e)))
		     (*error* parse-exp "declaration in ~s-exp is not a proper list ~s" '(let (let [(a b) (c d) (e . f)] g)))
		     (*error* parse-exp "lambda-expression: incorrect length ~s" '((lambda x)))
		     (*error* parse-exp "declarations in ~s-expression not a list ~s" '(let* (let* a b)))
		     (*error* parse-exp "declarations in ~s-expression not a list ~s" '(letrec (letrec a b)))
		     (*error* parse-exp "declaration in ~s-exp must be a list of length 2 ~s" '(let (let [(a b c) (d e)] f)))
		     (*error* parse-exp "declaration in ~s-exp must be a list of length 2 ~s" '(let* (let* [(a b c) (d e)] f)))
		     (*error* parse-exp "declaration in ~s-exp must be a list of length 2 ~s" '(letrec (letrec [(a b) (c)] d)))
		     (*error* parse-exp "vars in ~s-exp must be symbols ~s" '(let (let [(a b) (3 c)] d)))
		     (*error* parse-exp "vars in ~s-exp must be symbols ~s" '(letrec (letrec [(a b) (3 c)] d)))
		     (*error* parse-exp "vars in ~s-exp must be symbols ~s" '(let* (let* [(a b) (3 c)] d)))
		     (*error* parse-exp "~s-expression has incorrect length ~s" '(let (let [(a (lambda (x)))])))
		     (*error* parse-exp "set! expression ~s does not have (only) variable and expression" '((set! x)))
		     (*error* parse-exp "if-expression ~s does not have (only) test, then, and else" '((if x)))
		     (*error* parse-exp "set! expression ~s does not have (only) variable and expression" "")
		     )]
          [answers 
            (list 
(parse-exp (quote (lambda (a))))
(parse-exp (quote (lambda x)))
(parse-exp (quote (a b . c)))
(parse-exp (quote (lambda (a b 1) c)))
(parse-exp (quote (if a)))
(parse-exp (quote (let ((a b)))))
(parse-exp (quote (letrec ((a b)))))
(parse-exp (quote (let ((a b) . c) e)))
(parse-exp (quote (let ((a b) (c d) (e . f)) g)))
(parse-exp (quote (letrec ((a b) (c d) (e (lambda x))) g)))
(parse-exp (quote (let* a b)))
(parse-exp (quote (letrec a b)))
(parse-exp (quote (let ((a b c) (d e)) f)))
(parse-exp (quote (let* ((a b c) (d e)) f)))
(parse-exp (quote (letrec ((a b) (c)) d)))
(parse-exp (quote (let ((a b) (3 c)) d)))
(parse-exp (quote (letrec ((a b) (3 c)) d)))
(parse-exp (quote (let* ((a b) (3 c)) d)))
(parse-exp (quote (let ((a (lambda (x)))))))
(parse-exp (quote (set! x)))
(parse-exp '(let ((a (let ((b (if x))) b))) a))
(parse-exp '(set! x (let ((a (set! a b c))) a)))
	     )])
      (display-results correct answers error-equal?)))

	  
     


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
  (display 'my-let) 
  (test-my-let)
  (display 'my-or) 
  (test-my-or)   
  (display '+=) 
  (test-+=)
  (display 'return-first) 
  (test-return-first)
  (display 'bintree-to-list) 
  (test-bintree-to-list)  
  (display 'max-interior) 
  (test-max-interior)
;  (display 'parse-errors)   ;; commented out on purpose
;  (test-parse-errors)       ;; see note before the definition of test-parse-errors.
                             ;; You will  most likely want to run those tests by hand.
  (display 'parse-unparse) 
  (test-parse-unparse)
  
)

(define r run-all)

