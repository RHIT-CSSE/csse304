(define new-stack
  (lambda () '()))

(define empty? null?)

(define top car)

(define-syntax push!
  (syntax-rules ()
    [(_ value-to-push name-of-stack)
        ;name-of-stack must be a symbol
     (set! name-of-stack (cons value-to-push name-of-stack))]))


(define-syntax pop!
  (syntax-rules ()
    [(_ name-of-stack) 
     (let ([temp (car name-of-stack)])
       (set! name-of-stack 
            (cdr name-of-stack))
       temp)]))

(define counter-maker
  (lambda (f)
    (let ([count 0])
      (lambda args
	(if (and (= (length args) 1)
		 (eqv? (car args) 'count))
	    count
	    (begin
	      (set! count (+ 1 count))
	      (apply f args)))))))
