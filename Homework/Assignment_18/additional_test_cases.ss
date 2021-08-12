(eval-one-exp '
 (begin
  (define a 4)
  (define f (lambda ()
	      (call/cc (lambda (k)
			 (set! a (+ 1 a))
			 (set! a (+ 2 a))
			 (k a)
			 (set! a (+ 3 a))
			 a))))
  (f)))




(define eval-one-exp eval)
