(eval-one-exp (quote
(let ([a (lambda (x) (- 3 x))]
      [b (lambda (x) (+ 2 x))])
 (let
   ([a (lambda (x)
	 (if (< x 25)
	     (b (+ 10 x))
	     (+ 100 x)))]
    [b (lambda (x) (a (+ 4 x)))])
  (b 3)))
))


(eval-one-exp (quote
(let ([a (lambda (x) (- 3 x))]
      [b (lambda (x) (+ 2 x))])
 (let*
   ([a (lambda (x)
	 (if (< x 25)
	     (b (+ 10 x))
	     (+ 100 x)))]
    [b (lambda (x) (a (+ 4 x)))])
  (b 3)))
))


(eval-one-exp (quote
(let ([a (lambda (x) (- 3 x))]
      [b (lambda (x) (+ 2 x))])
 (letrec
   ([a (lambda (x)
	 (if (< x 25)
	     (b (+ 10 x))
	     (+ 100 x)))]
    [b (lambda (x) (a (+ 4 x)))])
  (b 3)))
))


(eval-one-exp (quote
(letrec ([make-range
          (lambda (start stop)
            (if (= start stop)
                (list stop)
                (cons start (make-range (+ 1 start) stop))))])
  (make-range 4 8))
))


(eval-one-exp (quote
(let make-range ([start 4] [stop 8])
  (if (= start stop)
      (list stop)
      (cons start (make-range (+ 1 start) stop))))
))


(eval-one-exp (quote
(let ([one-list '(1)])
  (let loop ([count 0])
    (set-car! one-list (+ 2 (car one-list)))
    (if (< count 6)
        (loop (+ 1 count))
        one-list)))
))


(eval-one-exp (quote
(let* ([y 5] 
       [z (+ y (let ([x (+ y 2)]) 
                 (+ x y)))])
  (cond [(< z 0) 4]
        [(< z 20) 
         (cond [(< y 3) #f]
               [(< y 8) (if (> y 12) 
                            2 
                            (list 7 z))]
               [else (or #f (- y 6) y)])]
        [else 16]))
))


(eval-one-exp (quote
(letrec ([o? (lambda (n)
               (if (zero? n)
                   #f
                   (e? (- n 1))))]
         [e? (lambda (n)
               (if (zero? n)
                   #t
                   (o? (- n 1))))])
  ((lambda (n)
      (o? n))
   3))
))


(eval-one-exp (quote
(let
   ([largest-in-lists
     (letrec
	([largest-of-two 
	  (lambda (x y)
	    (cond [(not x) y]
		  [(not y) x]
		  [else (max x y)]))]
	 [largest-in-one-list 
	  (lambda (L)
	    (if (null? L) 
		#f
		(largest-of-two 
		 (car L)   
		 (largest-in-one-list
		  (cdr L)))))])
       (lambda (L) ; list of lists
	 (largest-in-one-list
	  (map largest-in-one-list L))))])
  (largest-in-lists
   '((4 6 -5 2 1) () (-3 12 1) (-9 8))))
))
