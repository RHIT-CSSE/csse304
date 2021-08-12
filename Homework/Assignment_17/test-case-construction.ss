(eval-one-exp '
(letrec ([fact (lambda (x)
		 (if (zero? x) 
		     1
		     (* x (fact (- x 1)))))])
  (map fact '(0 1 2 3 4 5))))


(eval-one-exp '
(let f ([n 8] [acc 1])
  (if (= n 0)
      acc
      (f (sub1 n) (* acc n))))))

(eval-one-exp '
(let ([n 5])
  (let f ([n n] [acc 1])
    (if (= n 0)
	acc
	(f (sub1 n) (* acc n))))))

(eval-one-exp '
(letrec ([even? (lambda (n)
		  (if (zero? n) 
		      #t
		      (odd? (- n 1))))]
	 [odd? (lambda (m)
		 (if (zero? m)
		     #f
		     (even? (- m 1))))])
  (list (odd? 3) (even? 3) (odd? 4) (even? 4))))

(eval-one-exp '
(letrec ([union
	  (lambda (s1 s2)
	    (cond [(null? s1) s2]
		  [(member? (car s1) s2) (union (cdr s1) s2)]
		  [else (cons (car s1) (union (cdr s1) s2))]))]
	 [member? (lambda (sym ls)
		    (cond [(null? ls) #f]
			  [(eqv? (car ls) sym) #t]
			  [else (member? sym (cdr ls))]))])
  (union '(a c e d k) '(e b a d c))))
 

(eval-one-exp '
(letrec (
   [largest-of-two 
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
	   (largest-in-one-list (cdr L)))))])
  (map 
   (lambda (L) ; list of lists
     (largest-in-one-list (map largest-in-one-list L)))
   '((() (9 1) (8) (7 6 3))
     ((1 3 5) () (4) (2 6 1) (4))))))