; Warmup example 1

(define curry2
  (lambda (f)
    (lambda (x)
      (lambda (y)
	(f x y)))))

(((curry2 (lambda (x y) (+ x (* 3 y))))
  4)
5)



; Warmup example 2

(letrec ([map (lambda (proc ls)
		(if (null? ls)
		    '()
		    (cons (proc (car ls))
			  (map proc (cdr ls)))))])
  (let ([proc (lambda (y) (+ 3 y))]
	[ls '(5 6)])
    (map proc ls)))
	
	

; Warmup example 3

(let* ([curry2 (lambda (f)
		(lambda (x)
		  (lambda (y) 
		    (f x y))))]
       [f (lambda (x y)
	    (+ x (* 3 y)))])
  (((curry2 f) 4) 5))
  
