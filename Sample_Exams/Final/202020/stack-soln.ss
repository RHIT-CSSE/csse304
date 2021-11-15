(define make-stack
  (let ([pushes 0])
    (lambda ()
      (let ([stk '()] [size 0])
	(lambda (msg  . args ) 
	  (case msg
            [(empty?) (null? stk)]
            [(push)
	     (set! stk (cons (car args) stk))
	     (set! size (+ 1 size))
	     (set! pushes (+ 1 pushes))]
            [(pop)    (let ([top (car stk)])
			(set! stk (cdr stk))
			(set! size (- size 1))
			top)]
	    [(top) (car stk)]
	    [(push-count) pushes]
	    [(size) size]
            [else (errorf 'stack "illegal message to stack object: ~a" msg)]))))))

