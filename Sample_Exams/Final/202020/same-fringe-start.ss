

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


(define same-fringe?
  (lambda (tree1 tree2)
    (call/cc
     (lambda (return-cont)
       (let ([co1 '()] [co2 '()] [driver '()])
         (set! driver
               (make-coroutine
                (lambda (init-value)
                  (let loop ()
                    (let ([leaf1 (resume co1 'whocares)]
                          [leaf2 (resume co2 'whocare2)])
                      (if (equal? leaf1 leaf2)
                          (if (eq? leaf1 #f) (return-cont #t) (loop))
                          (return-cont #f)))))))
         (set! driver
               (make-coroutine
                (lambda (init-value)
                  (let loop ()
                    (let ([leaf1 (resume co1 'whocares)]
                          [leaf2 (resume co2 'whocare2)])
                      (if (equal? leaf1 leaf2)
                          (if (eq? leaf1 #f) (return-cont #t) (loop))
                          (return-cont #f)))))))
         (set! co1 (make-sf-coroutine driver tree1))
         (set! co2 (make-sf-coroutine driver tree2))
         (driver 'Whatsittoya?))))))

(define same-fringes? 'fill-it-in

(define all-same?
  (lambda (ls)
    (or (null? ls)
	(null? (cdr ls))
	(and (equal? (car ls) (cadr ls))
	     (all-same? (cdr ls))))))
			    
		       
(same-fringes? '(1) '(1) '(1))
(same-fringe? '(1) '(2) '(1))
(same-fringe? '(1 (2)) '(() 1 2) '((1) 2) '(1 () ((2))))
(same-fringe? '(1 (2)) '(() 1 2) '((1) 2 (3)) '(1 () ((2))))


