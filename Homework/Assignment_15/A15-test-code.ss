;; Test code for CSSE 304 Assignment 15

(define (test-member?-cps)
    (let ([correct '(
		     #t
		     (#f)
		     3
		     )]
          [answers 
            (list 
	     (member?-cps 1 (quote (3 2 4 1 5)) (make-k (lambda (x) x)))
	     (member?-cps 7 (quote (3 2 4 1 5)) (make-k list))
	     (member?-cps 2 (quote (1 3 2 4)) (make-k (lambda (x) (if x 3 4))))
	     )])
      (display-results correct answers equal?)))

(define (test-set?-cps)   ; removed for 202120; shouldn't have because other tests use it.
    (let ([correct '(
		     #f
		     (#t #t)
		     4
		     )]
          [answers 
            (list 
	     (set?-cps (quote (a b c b d)) 
		       (make-k (lambda (v) v)))
	     (set?-cps (quote (a b c)) 
		       (make-k (lambda (v) 
			 (set?-cps (quote ()) 
				   (make-k (lambda (w) (list v w)))))))
	     (set?-cps (quote (a b c a)) 
		       (make-k (lambda (x) (if x 3 4))))
	     )])
      (display-results correct answers equal?)))

(define (test-1st-cps)
    (let ([correct '(
		     2
		     )]
          [answers 
            (list 
	     (1st-cps '((1 2) (3 4)) (make-k cadr))
	     )])
      (display-results correct answers equal?)))

(define (test-set-of-cps)
    (let ([correct '(
		     4
		     14
;		     (#t)
		     #f
	     )]
          [answers 
            (list 
	     (set-of-cps '(a c b b c d a b) (make-k length))
	     (set-of-cps '(a c b b c e a b d e) 
			 (make-k (lambda (v) 
			   (apply max (map (lambda (x) 
					     (string->number x 16)) 
					   (map symbol->string v))))))
;	     (set-of-cps '(a c b b c d a b) 
;			 (make-k (lambda (v) 
;			   (set?-cps v (make-k list)))))
	     (set-of-cps '(a c b b c d a b) 
			 (make-k (lambda (v) 
			   (member?-cps 'b v (make-k not)))))
	     )])
      (display-results correct answers equal?)))

(define (test-map-cps)
    (let ([correct '(
		     (4 3 2)
;		     ((#t #t #f #f #f))
		     ((3 4 5 6) 3 4 5 6)
		     )]
          [answers 
            (list 
	     (map-cps (lambda (x k) 
			(apply-k k (add1 x))) 
		      '(1 2 3) 
		      (make-k reverse))
;	     (map-cps set?-cps 
;		      '((a b c) () (a b c b) (a b c c) (a b c a)) 
;		      (make-k list))
	     (let ([add1-cps (make-cps add1)])
	       (map-cps add1-cps '(1 2 3 4)
			(make-k (lambda (v) 
			  (map-cps add1-cps 
				   v
				   (make-k (lambda (v) (cons v v))))))))
	     )])
      (display-results correct answers equal?)))

(define (test-domain-cps)
    (let ([correct '(
		     (4 4 1)
		     #t
;		     "The result is a set"
		     (#f #f #t #f #t #t #t)
		     )]
          [answers 
            (list 
	     (domain-cps '((1 3) (2 4) (1 5) (2 2) (3 6) (2 1) (4 4)) 
			 (make-k (lambda (v)
				   (list (length v)
					 (apply max v)
					 (apply min v)))))
	     (domain-cps '((1 3) (5 4) (1 5) (2 2) (3 6) (2 1)(4 4)) 
			 (make-k (lambda (v)
				   (member?-cps 6 v (make-k not)))))
;	     (domain-cps '((1 3) (5 4) (1 5) (2 2) (3 6) (2 1)(4 4)) 
;			 (make-k (lambda (v) 
;				   (set?-cps v 
;					     (make-k (lambda (vv) 
;				       (format "The result is ~aa set" 
;					       (if vv "" "not "))))))))
	     (domain-cps '((1 3) (5 4) (1 5) (2 2) (3 6) (2 14 4)) 
			 (make-k (lambda (v) 
			   (map-cps (lambda (x k) 
				      (member?-cps x v k)) 
				    '(1 2 3 4 5 6 7) 
				    (make-k reverse)))))
	     )])
      (display-results correct answers equal?)))

; not used for this assignment in 201510
(define (test-intersection-cps)
    (let ([correct '(
		     (b c e)
		     ((b c e))
		     3
		     )]
          [answers 
            (list 
	     (intersection-cps (quote (a b c d e))
			       (quote (f e t b c))
			       (make-k (lambda (x) x)))
	     (intersection-cps (quote (a b c d e))
			       (quote (f e t b c))
			       (make-k list))
	     (intersection-cps (quote (a b c))
			       (quote (d e f))
			       (make-k (lambda (x)
					 (if (null? x) 3 4))))
	     )])
      (display-results correct answers equal?)))

(define (test-make-cps)
    (let ([correct '(
		     (1)
		     #t
		     #f
		     )]
          [answers 
            (list 
	     (let ((car-cps (make-cps car))) 
	       (car-cps (quote (1 2 3)) (make-k list)))
	     (let ([number?-cps (make-cps number?)] 
		   [car-cps (make-cps car)]) 
	       (car-cps (quote (1 2 3)) 
			(make-k (lambda (x) 
				  (number?-cps x 
				       (make-k (lambda (x) x)))))))
	     ((make-cps list?) (quote (1 2 3)) (make-k (lambda (x) (not x))))
	     )])
      (display-results correct answers equal?)))

; not used for 202120, but would be good practice
(define (test-matrix?-cps)
    (let ([correct '(
		     #t
		     #t
		     #t
		     #t
		     #f
		     #t
		     #f
		     #t
		     #t
		     #t
		     #t
		     (#f #t)
		     )]
          [answers 
            (list 
	     (matrix?-cps (quote (()))
			  (make-k not))
	     (matrix?-cps (quote ())
			  (make-k not))
	     (matrix?-cps (quote ((a b) (1 2 3)))
			  (make-k not))
	     (matrix?-cps (quote ((a b 3 4) (1 2 3)))
			  (make-k not))
	     (matrix?-cps (quote ((a b) (1 2) (1 2)))
			  (make-k not))
	     (matrix?-cps (quote ((a b) (1 2) (1 2)))
			  (make-k (lambda (x) x)))
	     (matrix?-cps (quote ((a b) (1 2 v) (1 2)))
			  (make-k (lambda (x) x)))
	     (matrix?-cps (quote ((a b) (1 2)))
			  (make-k (lambda (x) x)))
	     (matrix?-cps (quote ((a)))
			  (make-k (lambda (x) x)))
	     (matrix?-cps (quote ((a b 5) (1 2 3) (1 3 v)))
			  (make-k (lambda (x) x)))
	     (matrix?-cps (quote ((a b 3 3) (1 2 q q) (6 5 4 3) (1 0 1 0)))
			  (make-k (lambda (x) x)))
	     (matrix?-cps (quote ((a b 3 3) (1 2 q q) (6 5 4) (1 0 1 0))) 
			  (make-k (lambda (x) (matrix?-cps
					       (quote ((3))) 
					       (make-k (lambda (y) 
							 (list x y)))))))
	     )])
      (display-results correct answers equal?)))

(define (test-andmap-cps)
    (let ([correct '(
		     (#t)
		     (#f)
		     (#t)
		     #t
		     (#f 4)
		     )]
          [answers 
            (list 
	     (andmap-cps (make-cps number?) (quote (2 3 4 5)) (make-k list))
	     (andmap-cps (make-cps number?) (quote (2 3 a 5)) (make-k list))
	     (andmap-cps (lambda (L k) (member?-cps (quote a) L k))
			 (quote ((b a) (c b a)))
			 (make-k list))
	     (andmap-cps (lambda (L k) (member?-cps (quote a) L k))
			 (quote ((b a) (c b)))
			 (make-k not))
	     (let ([t 0]) 
	       (andmap-cps (lambda (x k) 
			     (set! t (+ 1 t))
			     (apply-k k x)) 
			   (quote (#t #t #t #f #t)) 
			   (make-k (lambda (v) (list v t)))))
	    ; There is another test on the server that I cannot run in this context
	     )])
      (display-results correct answers equal?)))

; Not used in 201020, but could be good practice.
(define (test-cps-snlist-recur)
    (let ([correct '(
		     300
		     -4
		     2
		     (2)
		     #t
		     ((1))
		     (2 1)
		     (3 ((2 1)))
		     (a (c b) () ((f e) d))
		     ((a (b c) () (d (e f))))
		    (0)
		     0
		     -2
		     2
		     )]
          [answers 
            (list 
	     (sn-list-depth-cps '((1 2 3 4 0) (2 () (3) 4 5))
				(make-k (lambda (x) (* 100 x))))
	     (sn-list-depth-cps '((1 2 3 4 0) (2 3 (4 () (6)) 5))
				(make-k -))
	     (sn-list-depth-cps '(1 2 3 4) (make-k add1))
	     (sn-list-depth-cps '(()) (make-k list))
	     (sn-list-reverse-cps '() (make-k null?))
	     (sn-list-reverse-cps '(1) (make-k list))
	     (sn-list-reverse-cps '(1 2) (make-k (lambda (x) x)))
	     (sn-list-reverse-cps '((((1 2)) 3)) (make-k car))
	     (sn-list-reverse-cps '(a (b c) () (d (e f)))
				  (make-k reverse))
	     (sn-list-reverse-cps '(a (b c) () (d (e f))) 
				  (make-k (lambda (v)
					    (sn-list-reverse-cps v
								 (make-k list)))))
	     (sn-list-occur-cps '*sore-thumb* '() (make-k list))
	     (sn-list-occur-cps '*sore-thumb*
				'(x () *sore-thumb* x)
				(make-k sub1))
	     (sn-list-occur-cps '*sore-thumb* 
				'(x (*sore-thumb*) x ((y *sore-thumb* ()))) 
				(make-k -))
	     (sn-list-occur-cps '*sore-head* 
				'((*sore-head*) 
				  (*sore-thumb* x (x x)) 
				  x 
				  (x (*sore-head*))
				  x) 
				(make-k +))
	     )])
      (display-results correct answers equal?)))


(define (test-free-vars-union-remove)
    (let ([correct '(
		     (x y)
		     ((x))
		     (y z)
		     (y)
		     (x)
		     (x y z)
		     (x y)
		     ()
		     (c e r b a g d t)
		     (b c e d a)
		     (c e a d)
		     (a b c d e f)
		     )]
          [answers 
            (list 
	     (free-vars-cps '((lambda (x) y)
			      (lambda (y) x))
			    (init-k))
	     (free-vars-cps '(x x)
			    (list-k))
	     (free-vars-cps '((lambda (x) (x y))
			      (z
			       (lambda (y) (z y))))
			    (init-k))
	     (free-vars-cps '(lambda (x) y)
			    (init-k))
	     (free-vars-cps '(x (lambda (x) x))
			    (init-k))
	     (free-vars-cps '(x
			      (lambda (x) (y z)))
			    (init-k))
	     (free-vars-cps '(x
			      (lambda (x) y))
			    (init-k))
	     (free-vars-cps '((lambda (y)
				(lambda (y) y))
			      (lambda (x)
				(lambda (x) x)))
			    (init-k))
	     (union-cps '(a c e g r) '(b a g d t) (init-k))
	     (remove-cps 'a '(b c e a d a) (init-k))
	     (remove-cps 'b '(b c e a d) (init-k))
	     (free-vars-cps '(a (b ((lambda (x)
				      (c (d (lambda (y)
					      ((x y)
					       e)))))
				    f)))
			    (init-k))
	     )])
      (display-results correct answers  set-equals?)))
	  

; It's easy to get the correct answer.  If properly memoized, that will happen much faster than if not.
; The test code on the server attempts to check for this.  A time-out probably means "not properly memoized")

; DOn't forget to include your answer to the question from the assignment document at the top of your submission file!

(define (test-memoized-fib)
    (let ([correct '(
		     (317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 
			     317811 317811 317811 317811 317811 317811 317811 317811 317811 196418 
			     196418 196418 196418 196418 196418 196418 196418 196418 196418 196418 
			     196418 196418 196418 196418 196418 196418 196418 196418)
		     )]
          [answers 
            (list 
(letrec ([fib (lambda (n)
		(if (< n 2)
		    1
		    (+ (fib (- n 1))
		       (fib (- n 2)))))])
  (let ([fib-memo (memoize fib car equal?)])
    (map fib-memo (append (make-list 20 27) (make-list 19 26)))))
	     )])
      (display-results correct answers equal?)))
	  


(define (test-memoized-comb)
    (let ([correct '(
(((1)) ((1) (1 1)) ((1) (1 1) (1 2 1))
  ((1) (1 1) (1 2 1) (1 3 3 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)
       (1 8 28 56 70 56 28 8 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)
       (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)
       (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1)
       (1 10 45 120 210 252 210 120 45 10 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)
       (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1)
       (1 10 45 120 210 252 210 120 45 10 1)
       (1 11 55 165 330 462 462 330 165 55 11 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)
       (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1)
       (1 10 45 120 210 252 210 120 45 10 1)
       (1 11 55 165 330 462 462 330 165 55 11 1)
       (1 12 66 220 495 792 924 792 495 220 66 12 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)
       (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1)
       (1 10 45 120 210 252 210 120 45 10 1)
       (1 11 55 165 330 462 462 330 165 55 11 1)
       (1 12 66 220 495 792 924 792 495 220 66 12 1)
       (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)
       (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1)
       (1 10 45 120 210 252 210 120 45 10 1)
       (1 11 55 165 330 462 462 330 165 55 11 1)
       (1 12 66 220 495 792 924 792 495 220 66 12 1)
       (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1)
       (1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14
          1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)
       (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1)
       (1 10 45 120 210 252 210 120 45 10 1)
       (1 11 55 165 330 462 462 330 165 55 11 1)
       (1 12 66 220 495 792 924 792 495 220 66 12 1)
       (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1)
       (1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14 1)
       (1 15 105 455 1365 3003 5005 6435 6435 5005 3003 1365 455
          105 15 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)
       (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1)
       (1 10 45 120 210 252 210 120 45 10 1)
       (1 11 55 165 330 462 462 330 165 55 11 1)
       (1 12 66 220 495 792 924 792 495 220 66 12 1)
       (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1)
       (1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14 1)
       (1 15 105 455 1365 3003 5005 6435 6435 5005 3003 1365 455
          105 15 1)
       (1 16 120 560 1820 4368 8008 11440 12870 11440 8008 4368
          1820 560 120 16 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)
       (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1)
       (1 10 45 120 210 252 210 120 45 10 1)
       (1 11 55 165 330 462 462 330 165 55 11 1)
       (1 12 66 220 495 792 924 792 495 220 66 12 1)
       (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1)
       (1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14 1)
       (1 15 105 455 1365 3003 5005 6435 6435 5005 3003 1365 455
          105 15 1)
       (1 16 120 560 1820 4368 8008 11440 12870 11440 8008 4368
          1820 560 120 16 1)
       (1 17 136 680 2380 6188 12376 19448 24310 24310 19448 12376
          6188 2380 680 136 17 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)
       (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1)
       (1 10 45 120 210 252 210 120 45 10 1)
       (1 11 55 165 330 462 462 330 165 55 11 1)
       (1 12 66 220 495 792 924 792 495 220 66 12 1)
       (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1)
       (1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14 1)
       (1 15 105 455 1365 3003 5005 6435 6435 5005 3003 1365 455
          105 15 1)
       (1 16 120 560 1820 4368 8008 11440 12870 11440 8008 4368
          1820 560 120 16 1)
       (1 17 136 680 2380 6188 12376 19448 24310 24310 19448 12376
          6188 2380 680 136 17 1)
       (1 18 153 816 3060 8568 18564 31824 43758 48620 43758 31824
          18564 8568 3060 816 153 18 1))
  ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)
       (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)
       (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1)
       (1 10 45 120 210 252 210 120 45 10 1)
       (1 11 55 165 330 462 462 330 165 55 11 1)
       (1 12 66 220 495 792 924 792 495 220 66 12 1)
       (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1)
       (1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14 1)
       (1 15 105 455 1365 3003 5005 6435 6435 5005 3003 1365 455
          105 15 1)
       (1 16 120 560 1820 4368 8008 11440 12870 11440 8008 4368
          1820 560 120 16 1)
       (1 17 136 680 2380 6188 12376 19448 24310 24310 19448 12376
          6188 2380 680 136 17 1)
       (1 18 153 816 3060 8568 18564 31824 43758 48620 43758 31824
          18564 8568 3060 816 153 18 1)
       (1 19 171 969 3876 11628 27132 50388 75582 92378 92378 75582
          50388 27132 11628 3876 969 171 19 1)))		     )]
          [answers 
            (list 
(letrec (
  [comb 
    (lambda (n k)
      (if (or (= k n) (zero? k))
	  1
	  (+ (comb (- n 1) k) (comb (- n 1) (- k 1)))))]
  [map
   (lambda (proc ls)
     (if (null? ls) 
	 '()
	 (let ([new-car (proc (car ls))])
	   (cons new-car (map proc (cdr ls))))))])
  (let*
      ([comb-memo 
	(memoize comb 
		 (lambda (x) (+ (* 100 (car x))
				(min (cadr x) (- (car x) (cadr x)))))
		 (lambda (x y) 
		   (and (= (car x) (car y))
			(or (= (cadr x) (cadr y))
			    (= (cadr x) (- (car y) (cadr y)))))))]
       [pascal-triangle
	(lambda (max)
	  (let row-loop ([n max] [row-accumulator '()])
	    (if (< n 0) 
		row-accumulator
		(row-loop (- n 1)
			  (cons 
			   (let col-loop ([k n] [col-accumulator '()])
			     (if (< k 0) 
				 col-accumulator
				 (col-loop (- k 1) 
					   (cons (comb-memo n k) 
						 col-accumulator))))
			   row-accumulator)))))])
    (map pascal-triangle (iota 20))))
         )])
      (display-results correct answers equal?)))

(define (test-subst-leftmost)
    (let ([correct '(
		     ()
		     (k b)
		     (a k a b)
		     (a ((k b)) a b)
		     ((c d a (e () f k (c b)) (a b)) (b))
		     (c (b e) a d)
		     )]
          [answers 
            (list 
	     (subst-leftmost 'k 'b '() eq?)
	     (subst-leftmost 'k 'b '(b b) eq?)
	     (subst-leftmost 'k 'b '(a b a b) eq?)
	     (subst-leftmost 'k 'b '(a ((b b)) a b) eq?)
	     (subst-leftmost 'k 'b '((c d a (e () f b (c b)) (a b)) (b)) eq?)
	     (subst-leftmost 'b 'a '(c (A e) a d) 
			     (lambda (x y) 
			       (string-ci=? 
				(symbol->string x) 
				(symbol->string y))))
	     )])
      (display-results correct answers  equal?)))

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
;  (display 'member?-cps) 
;  (test-member?-cps )
  (display 'set?-cps) 
  (test-set?-cps)

;  (display 'intersection-cps)  ; removed in 201510, but tests
;  (test-intersection-cps)      ; are here in case you want extra practice

; domain-cps and its helpers:

  (display '1st-cps) 
  (test-1st-cps)
  (display 'set-of-cps) 
  (test-set-of-cps)
  (display 'map-cps) 
  (test-map-cps)
  (display 'domain-cps) 
  (test-domain-cps)    

  (display 'make-cps) 
  (test-make-cps)    
  (display 'andmap-cps) 
  (test-andmap-cps)  
; (display 'cps-snlist-recur) ; removed in 202020
;  (test-cps-snlist-recur)
  (display 'free-vars-union-remove)
  (test-free-vars-union-remove)
  

 (display 'memoized-fib) 
 (test-memoized-fib)  
 (display 'memoized-comb) 
 (test-memoized-comb)
 (display 'subst-leftmost)
 (test-subst-leftmost)  
)

(define r run-all)

