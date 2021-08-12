(load "chez-init.ss") ; remove this isf using Dr. Scheme EoPL language

(define-datatype expression expression?  ; based on the simple expression grammar, EoPL-2 p6
  (var-exp
    (id symbol?))
  (lambda-exp
    (id symbol?)
    (body expression?))
  (app-exp
    (rator expression?)
    (rand expression?)))

(define parse-exp
  (lambda (datum)
    (cond
      ((symbol? datum) (var-exp datum))
      ((pair? datum)
       (if (eqv? (car datum) 'lambda)
         (lambda-exp (caadr datum)
           (parse-exp (caddr datum)))
         (app-exp
           (parse-exp (car datum))
           (parse-exp (cadr datum)))))
      (else (eopl:error 'parse-exp
              "Invalid concrete syntax ~s" datum)))))

(define unparse-exp ; an inverse for parse-exp
  (lambda (exp)
    (cases expression exp
      (var-exp (id) id)
      (lambda-exp (id body) 
        (list 'lambda (list id)
          (unparse-exp body)))
      (app-exp (rator rand)
        (list (unparse-exp rator)
              (unparse-exp rand))))))

(define occurs-free? ; in parsed expression
  (lambda (var exp)
    (cases expression exp
      (var-exp (id) (eqv? id var))
      (lambda-exp (id body)
        (and (not (eqv? id var))
             (occurs-free? var body)))
      (app-exp (rator rand)
        (or (occurs-free? var rator)
            (occurs-free? var rand))))))


