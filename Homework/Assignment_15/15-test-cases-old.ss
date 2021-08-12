(begin 
  (reset-global-env)
  (eval-one-exp
   '(define xyz (list 1 2 3 4 5)))
  (eval-one-exp
   '(define g (lambda (x)
		(cdr (cdr x)))))
  (eval-one-exp '(g xyz)))
					; answer: (3 4 5)

(begin 
  (reset-global-env)
  (eval-one-exp
   '(define xyz (list 1 2 3 4 5)))
  (eval-one-exp
   '(define g (lambda (x)
		(cdr (cdr x)))))
  (eval-one-exp
   '(set! xyz (cdr xyz)))
  (eval-one-exp
   '(g xyz)))        ;  Answer: (4 5)

; (4
;  55
;  (eval-one-exp
;   '(let ([x 3])
;     (define f (lambda (x)
;		 (if (zero? x)
;		     0
;		     (+ x (f (- x 1))))))
;     (f (+ 7 x)))
;  ))

(begin 
  (reset-global-env)
  (eval-one-exp
   '(define null?
      (lambda (L)
	(eq? L '()))))
  (eval-one-exp
   '(define len
      (lambda (L)
	(if (null? L)
	    0
	    (+ 1 (len (cdr L)))))))
  (eval-one-exp '(len '(3 2 1 7))))

(5
  21
  (begin 
    (reset-global-env)
    (eval-one-exp '(define x 17))
    (eval-one-exp '(+ x 4))))  ; answer: 21


(begin 
  (reset-global-env)
  (eval-one-exp
   '(define curry2
      (lambda (f)
	(lambda (x)
	  (lambda (y)
	    (f x y))))))

   (eval-one-exp
    '(define c2+ (curry2 +)))
   
   (eval-one-exp '((c2+ 4) 5)))


(begin 
  (reset-global-env)
  (eval-one-exp
   '(define fib-memo
      (let ([max 2]
	    [sofar '((1 . 1) (0 . 1))])
	(lambda (n)
	  (if (< n max)
	      (cdr (assq n sofar))
	      (let* ([v1 (fib-memo (- n 1))]
		     [v2 (fib-memo (- n 2))]
		     [v3 (+ v2 v1)])
		(set! max (+ n 1))
		(set! sofar
		  (cons  (cons n v3) sofar))
		v3))))))   
  (eval-one-exp
   '(list (fib-memo 15)(fib-memo 20))))      ; Answer: 987

(5
  10946
  (eval-one-exp '(fib-memo 20)))      ; answer: 10946

(begin (reset-global-env)
	(eval-one-exp '(define f1 (lambda (x) (f2 (+ x 1)))))
	(eval-one-exp '(define f2 (lambda (x) (* x x))))
	(eval-one-exp '(f1 3)))



)
)


("#1 letrec and named let"
 24
 
 (eval-one-exp
  60
  equal?
  ""


(begin
 (reset-global-env)
 (eval-one-exp
  '(define list-index
    (lambda (s los)
     (let loop ([count 0]
		[los los])
      (cond
       [(null? los) -1]
       [(eq? (car los) s) count]
       [else (loop (add1 count)
		   (cdr los))])))))
 (eval-one-exp
  '(list-index 4 '(1 2 3 4 5))))

(begin 
 (reset-global-env)
 (eval-one-exp
  '(define rotate-linear	
    (letrec
     ([reverse
       (lambda (lyst revlist)
	 (if (null? lyst)
	     revlist
	     (reverse (cdr lyst)
		      (cons (car lyst)
			    revlist))))])
     (lambda (los)
      (let loop ([los los]
		 [sofar '()])
	(cond [(null? los) los]
	      [(null? (cdr los))
	       (cons (car los)
		     (reverse sofar '()))]
	       [else
		(loop (cdr los)
		      (cons (car los)
			    sofar))]))))))
 (eval-one-exp '(rotate-linear '(1 2 3 4 5 6 7 8))))

(6
  55
  (begin 
    (reset-global-env)
    (eval-one-exp '(define zero? (lambda (x) (= x 0))))
    (eval-one-exp '(letrec ([f (lambda (n)
	      (if (zero? n)
		  0
		  (+ n (f (sub1 n)))))])
		     (f 10)))))        ; answer: 55


(8
  773
  (eval-one-exp '(letrec ([f (lambda (n) (if (zero? n)
					     0
					     (+ 4 (g (sub1 n)))))]
			  [g (lambda (n) (if (zero? n)
					     0
					     (+ 3 (f (sub1 n)))))])
		   (g (f (g (f 5)))))))     ; answer: 773


  )
 )



("#1 Misc interpreter tests for assignment 10 "
 68
 
 (eval-one-exp
  60
  equal?
  ""



(3
   (1 2 3 4 2)
   (eval-one-exp '(let ([sss (list->vector '(1 2 3 4 5))])
		    (vector-set! sss 4 2)
		       (vector->list sss))))   ; Answer:  (1 2 3 4 2)




(begin 
 (reset-global-env)
 (eval-one-exp
  '(define ns-list-recur
    (lambda (seed item-proc list-proc)
     (letrec (
      [helper
       (lambda (ls)
	 (if (null? ls)
	     seed
	     (let ([c (car ls)])
	       (if (or (pair? c) (null? c))
		   (list-proc (helper c)
		     (helper (cdr ls)))
		   (item-proc c
		     (helper (cdr ls)))))))])
       helper))))
 (eval-one-exp
  '(define append
     (lambda (s t)
       (if (null? s)
	   t
	   (cons (car s)
		 (append (cdr s) t))))))
 (eval-one-exp
  '(define reverse*
     (let ([snoc (lambda (x y)
		   (append y (list x)))])
       (ns-list-recur '() snoc snoc))))
 (eval-one-exp
  '(reverse* '(1 (2 3) (((4))) () 5))))


(5
  #t
  (eval-one-exp '(let ([sss '(1 (2 3) (((4))) () 5)])
  (equal? (reverse* (reverse* sss)) sss)))) ; answer: #t


 (begin
   (reset-global-env)

   (eval-one-exp
    '(define subst
       (lambda (old new x)
	 (cond
	  [(null? x) '()]
	  [(not (pair? x))
	   (if (= x old)
	       new
	       x)]
	  [else (map (lambda (x)
		       (subst old new x))
		     x)]))))
   (eval-one-exp
    '(subst 2 3
	    (list 1 2 3 4 5 2 3 4))))

(5
  (2 3 4)
  (eval-one-exp '(map (lambda (x) (+ x 1)) '(1 2 3))))     ; answer: (2 3 4)

(5
 ((1) (2) (3))
 (eval-one-exp '(map (lambda (x) (cons x '())) '(1 2 3))))

(4
  (3 . 4)
  (eval-one-exp '(apply cons '(3 4))))     ; answer: (3 . 4)

(4
 #5(1 8 3 4 5)
 (begin (reset-global-env)
	(eval-one-exp '(define ssss (vector 1 2 3 4 5)))
	(eval-one-exp '(vector-set! ssss 1 (+ 5 (vector-ref ssss 2))))
	(eval-one-exp 'ssss)))    ; answer: #5(1 8 3 4 5)

(2
  (1 2)
  (eval-one-exp '(car (vector->list (list->vector '((1 2) (3 4) (5 6)))))))


(5
  ((6 7) 8)
  (eval-one-exp '(let ([a '(1 2)])
		   (set-car! a '(6 7))
		      (set-cdr! a '(8))
		      a)))         ; answer: ((6 7) 8)

(5 
 3 
 (eval-one-exp '(apply apply (list + '(1 2)))))

(5 
 (5 7) 
  (eval-one-exp '(apply map (list (lambda (x) (+ x 3))  '(2
4)))))

	  
(5
 5
(begin
   (reset-global-env)
   (eval-one-exp '(define x 2))
   (eval-one-exp
    '(and 
      (begin (set! x (+ 1 x)) #t)
      (begin (set! x (+ 1 x)) #t)
      (begin (set! x (+ 1 x)) #f)
      (begin (set! x (+ 1 x)) #t)
      ))
   (eval-one-exp 'x))
 )))


("#1 Pass by reference tests for interpreter " 
 35  
 (eval-one-exp  
 60  
 equal?  
 ""
 (5  (4 3)
(begin
  (reset-global-env)
  (eval-one-exp '
   (let ([a 3]
	 [b 4]
	 [swap (lambda ((ref x) (ref y))
		 (let ([temp x])
		   (set! x y)
		   (set! y temp)))])
     (swap a b)
     (list a b)))
  )
)

(5
 (3 2 3)
 (begin (reset-global-env)
(eval-one-exp
 '(let ([a '(1 2 3)])
    ((lambda ((ref x))
       (set-car! x 3))
     a) a))))

(5 
 ((1 2 3) (b b b))
(begin
 (reset-global-env)
 (eval-one-exp '(define x '(a a a)))
 (eval-one-exp '(define y '(b b b)))
 (eval-one-exp
  '(let ()
     ((lambda ((ref x) y)
	(set! x '(1 2 3))
	(set! y '(4 5 6)))
      x y)
     (list x y)))))

(5
 (23 45)
(begin
  (reset-global-env)
  (eval-one-exp '(define x (lambda (x)
			     (+ 44 x))))
  (eval-one-exp
   '((lambda ((ref x))
       (let ([a (x 1)])
	 (set! x (lambda (x) (+ 22 x)))
	 (list (x 1) a)))
     x))))
(5
 (1 2 3)
 (begin (reset-global-env)
(eval-one-exp
 '(let* ([a '(1 2 3)]
	 [b ((lambda ((ref x)) x) a)])
    (set! b 'foo)
    a))))
(5
 15
 (begin (reset-global-env)
(eval-one-exp
 '(let ([a (lambda ((ref x) (ref z))
	     (x z))]
	[b (lambda ((ref y))
	     (set! y (+ y 15)))]
	[c 0])
    (a b c) 
    c))))

(5
 (10 12 3 4)
(begin
  (reset-global-env)
  (eval-one-exp '(define a 10))
  (eval-one-exp '(define b 12))
  (eval-one-exp '(define c 14))
  (eval-one-exp '(define d 16))
  (eval-one-exp
   '(define f (lambda (w (ref x) (ref y) z)
		(lambda (w x (ref y) (ref z))
		  (set! w 1)
		  (set! x 2)
		  (set! y 3)
		  (set! z 4)))))
  (eval-one-exp
   '(let ()
      ((f a b c d) a b c d)
      (list a b c d)))))))



; testing an earlier test case
(begin 
  (trace-define ns-list-recur
    (lambda (seed item-proc list-proc)
     (letrec (
      [helper
       (trace-lambda recur-proc (ls)
	 (if (null? ls)
	     (begin (printf "Seed: ~s~n" seed) seed)
	     (let ([c (car ls)])
	       (printf "c: ~s~n" c)
	       (if (or (pair? c) (null? c))
		   (list-proc (helper c)
		     (helper (cdr ls)))
		   (item-proc c
		     (helper (cdr ls)))))))])
       helper)))
  (define append
     (trace-lambda append (s t)
       (if (null? s)
	   t
	   (cons (car s)
		 (append (cdr s) t)))))
  (define reverse*
     (let ([snoc (trace-lambda snoc (x y)
		   (append y (list x)))])
       (ns-list-recur '() snoc snoc)))
  (reverse* '(1 (2 3) (((4))) () 5)))
