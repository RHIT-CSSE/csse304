; The first three tests should produce parse errors

(eval-one-exp '
 (let ([a 4])
   (define a (lambda (x) (* x (+ x 2))))
   (a 4)
   (define b (lambda (y) (- y 7))
   (b 2))))

(eval-one-exp '
 (let ([a 4])
   (define a (lambda (x) (* x (+ x 2))))
   (define b (lambda (y) (- y 7)))))

(eval-one-exp '
 (let ([x 3])
   (if (< x 2)
       (define a (lambda (x) (- 2 x)))
       (define b (lambda (x) (+ 3 x))))
   (a 7)))

;  VALID TEST CASES

(eval-one-exp '
(let ([x 5])
  (define foo (lambda (y) (bar x y)))
  (define bar (lambda (a b) (+ (* a b) a)))
  (foo (+ x 3)))) ; answer 45

(eval-one-exp '
 ((lambda (x y)
    (define a (lambda (z) (+ x y z)))
    (define b (lambda (w) (+ w (* x y))))
    (list (a 4) (b 5)))
  6 7)) ; answer (17 47)

(eval-one-exp '
 (let ([a 10] [b (list 6)])
   (set-car! b 7)
   (letrec ([fact (lambda (n)
		    (if (zero? n)
			1
			(* n (fact (- n 1)))))])
     (define fib (lambda (n)
		   (if (< n 2)
		       n
		       (+ (fib (- n 1))
			  (fib (- n 2))))))
     (list (fib a) (fact (fib (car b)))))))
     ; answer (55 6227020800)


(eval-one-exp '
 (begin
   (define odd?
     (lambda (x)
       (define odd? (lambda (n)
		      (if (zero? n)
			  #f
			  (even? (- n 1)))))
       (define even? (lambda (m)
		       (if (zero? m)
			   #t
			   (odd? (- m 1)))))
       (odd? x)))
   (list (odd? 3) (odd? 4)))) ; answer (#t #f)

(eval-one-exp '
 ((lambda (x y)
    (define a (lambda (z) (+ (b x) y z)))
    (define b (lambda (w) (+ w (* x y))))
    (list (a 4) (b 5)))
  6 7)) ; answer (59 47)
