

(define resume 'resume-undefined)

(define make-coroutine
  (lambda (body)
    (let ([local-continuation 'local-continuation-undefined])
      (letrec
          ([newcoroutine
            (lambda  (value) (local-continuation value))]
           [localresume
            (lambda  (continuation value)
              (let ([value (call/cc (lambda (k)
                                      (set! local-continuation k)
                                      (continuation value)))])
                (set! resume localresume)
                value))])
        (call/cc
         (lambda (exit)
           (body (localresume exit newcoroutine))
           (error 'co-routine "fell off end of coroutine")))))))


(define make-sf-coroutine
  (lambda (driver tree)
    (make-coroutine
     (lambda (init-value)
       (letrec ([traverse
                 (lambda (tree)
                   (if (pair? tree)
                       (begin
                         (traverse (car tree))
                         (if (pair? (cdr tree))
                             (traverse (cdr tree))))
                       (unless (null? tree)
			 (resume driver tree))))])
         (traverse tree)
         (resume driver #f))))))

(define same-fringes?
  (lambda trees
    (or (null? trees)
	(null? (cdr trees))
	(call/cc
	 (lambda (return-cont)
	   (let* ([driver '()] [cors '()])
	     (set! driver
               (make-coroutine
                (lambda (ignored-value)
                  (let loop ()
		    (let ([leaves (map (lambda (cor)
					 (resume cor 'not-used))
				       cors)])
		      (if (all-same? leaves)
			  (if (car leaves)
			      (loop)
			      (return-cont #t))
			  (return-cont #f)))))))
	     (set! cors (map (lambda (tree)
			       (make-sf-coroutine driver tree))
			     trees))
	     (driver 'whocares)))))))

(define all-same?
  (lambda (ls)
    (or (null? ls)
	(null? (cdr ls))
	(and (equal? (car ls) (cadr ls))
	     (all-same? (cdr ls))))))
			    
		       
(same-fringes? '(1) '(1) '(1))
(same-fringes? '(1) '(2) '(1))
(same-fringes? '(1 (2)) '(() 1 2) '((1) 2) '(1 () ((2))))
(same-fringes? '(1 (2)) '(() 1 2) '((1) 2 (3)) '(1 () ((2))))
(same-fringes? '((1)))
(same-fringes? '((1)) '(1 ()) '(() 1))
(same-fringes? '(1 2) '((1 2)) '(1 (((2)))) '((((1)) ((2)))) '((1 () (() 2))))
(same-fringes? '(1 2) '((1 2)) '(1 (((2)))) '((((1)) ((2) 3))) '((1 () (() 2))))
