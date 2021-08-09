; Claude Anderson Modified 11/5/2014 


(load "35-parse.ss")
    ;  defines expression datatypes; also  parse-exp, unparse-exp,
    ;  1st, 2nd,  3rd, and environment functions.

(define (l) (load "35-starting-code-for-CPS-interpreter-and-adding-callcc.ss")) 
    ; make it easy to reload during debugging

; eval-exp is the main component of the interpreter

  (define indent-level 0)

(define display-traced-output
  (let ([multi-indent-string
	 (lambda (level)
	   (let loop ([level level] [result ""])
	     (if (zero? level)
		 result
		 (loop (- level 1) (string-append result "| ")))))])
  (lambda args; (level proc-name args) or (level answer)
    (let ([indent-string (multi-indent-string (car args))])
      (display indent-string)
      (display (if (= 2(length args))
		   (cadr args)
		   (cons (cadr args) (caddr args)))))
      (newline))))

(define eval-exp
  (lambda (exp env)
    (cases expression exp
      [lit-exp (datum) datum]
      [var-exp (id) (apply-env env id)] ; look up its value.
      [lambda-exp (formals body)
	(closure formals body env)]
      [if-exp (test-exp then-exp else=exp)
	(if (eval-exp test-exp env)
	    (eval-exp then-exp env)
	    (eval-exp else=exp env))]
      [varassign-exp (id exp)
	(setref! (apply-env-ref env id) (eval-exp exp env))]
      [app-exp (rator rands)
        (let ([proc-value (eval-exp rator env)]
              [args (eval-rands rands env)])
          (apply-proc proc-value args))]
      [trace-lambda-exp (trace-name formals body)
	    (trace-closure trace-name formals body env)]
      [letrec-exp (proc-names ids bodies letrec-body)
	(eval-exp letrec-body
		  (extend-env-recursively proc-names ids bodies env))]
      [let-exp (vars exps bodies)
        (let ([extended-env
	       (extend-env vars
			   (map (lambda (exp)
				  (eval-exp exp env))
				exps)
			   env)])
	  (let loop ([bodies bodies])            
	     (if (null? (cdr bodies))
		 (eval-exp (car bodies) extended-env)
		 (begin (eval-exp (car bodies) extended-env) 
			(loop (cdr bodies))))))]
      [begin-exp (exps)
	(let ([val (eval-exp (car exps) env)])
	  (if (null? (cdr exps))
	      val
	      (eval-exp (begin-exp (cdr exps)) env)))]
      [for-exp (init test update bodies)
	(eval-exp init env)
	(let loop ()
	  (if (eval-exp test env)
	      (begin
		(for-each (lambda (body) (eval-exp body env))
		  bodies)
		(eval-exp update env)
		(loop))))]	    
      [else (error 'eval-exp "Bad abstract syntax: ~a" exp)])))

; evaluate the list of operands, putting results into a list

(define eval-rands
  (lambda (rands env)
    (map (lambda (x) (eval-exp x env)) rands)))

;  Apply a procedure to its arguments.
;  At this point, we only have primitive procedures.  
;  User-defined procedures will be added later.

(define apply-proc
  (lambda (proc-value args)
    (cases proc-val proc-value
      [prim-proc (op) (apply-prim-proc op args)]
      [escape-proc (real-proc)
	    (escape-continuation (apply-proc real-proc args))]
      [closure (formals body env)
	(eval-exp body
	   (extend-env formals args env))]
      [trace-closure (trace-name formals body env)
	(set! indent-level (+ 1 indent-level))
	(display-traced-output indent-level trace-name args)
	(let ([val (eval-exp body (extend-env formals args env))])
	  (display-traced-output indent-level val)
		 (set! indent-level (- indent-level 1))
		 val) ]
;[trace-closure (trace-name formals body env)
;	(set! indent-level (+ 2 indent-level))
;	(display (substring indent-string 0 indent-level))
;	(display (cons trace-name args)) (newline)
;	(let ([val
;	       (eval-exp body
;			 (extend-env formals args env))])
;	  (display (substring indent-string 0 indent-level))
;	  (display val) (newline)
;	  (set! indent-level (- indent-level 2))
;	  val)
;	]
	
      [else (error 'apply-proc
                   "Attempt to apply bad procedure: ~s" 
                    proc-value)])))

(define *prim-proc-names* '(+ - * add1 sub1 cons = zero?
			      vector make-vector vector-ref vector-set!
			      list->vector vector->list < <= list map escaper procedure?))

(define init-env         ; for now, our initial environment 
  (extend-env            ; only contains procedure names.
     *prim-proc-names*   ; Recall that an environment associates a
     (map prim-proc      ; value (not an expression) with a variable.
          *prim-proc-names*)
     (empty-env)))

; Usually an interpreter must define each 
; built-in procedure individually.

(define apply-prim-proc
  (lambda (prim-proc args)
    (case prim-proc
      [(+) (+ (1st args) (2nd args))]
      [(<) (apply < args)]
      [(<=) (apply <= args)]
      [(list) args]
      [(-) (- (1st args) (2nd args))]
      [(*) (* (1st args) (2nd args))]
      [(add1) (+ (1st args) 1)]
      [(sub1) (- (1st args) 1)]
      [(zero?) (zero? (1st args))]
      [(cons) (cons (1st args) (2nd args))]
      [(=) (= (1st args) (2nd args))]
      [(vector) (apply vector args)]
      [(vector-ref) (apply vector-ref args)]
      [(vector-set!) (apply vector-set! args)]
      [(make-vector) (apply make-vector args)]
      [(list->vector) (apply list->vector args)]
      [(vector->list) (apply vector->list args)]
      [(map) (map (lambda (x) (apply-proc (car args) (list x))) (cadr args))]
      [(escaper) (escape-proc (car args))]
			[(procedure?) (proc-val? (car args))]
      [else (eopl:error 'apply-prim-proc 
            "Bad primitive procedure name:" 
            prim-op)])))

(define global-env init-env)

(define rep      ; "read-eval-print" loop.
  (lambda ()
    (display "-->")
    ;; notice that we don't save changes to the environment...
    (let ([raw-exp (read)])
      (unless (equal? raw-exp '(exit))
	(let ([answer (eval-exp (parse-exp raw-exp) (empty-env))])
	  ;; TODO: are there answers that should display differently?
	  (pretty-print answer)
	  (rep))))))  ; tail-recursive, so stack doesn't grow.

(define eval-one-exp
  (lambda (e)
    (call/cc 
     (lambda (k)
       (set! escape-continuation k)
       (eval-exp (parse-exp e) (empty-env))))))

(define escape-continuation #f)
