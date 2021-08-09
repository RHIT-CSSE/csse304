(define occurs-bound?
  (lambda (var exp)
    (cond
      ((symbol? exp) #f)
      ((eqv? (car exp) 'lambda)
       (or (occurs-bound? var (caddr exp))
            (and (eqv? (caadr exp) var)
                   (occurs-free? var (caddr exp)))))
      (else (or (occurs-bound? var  (car exp))
                   (occurs-bound? var (cadr exp)))))))
