; Parser for simple expressions, such as those in EOPL, 3.1 thru 3.3.
; Environment definitions also appear at the end.

(load "chez-init.ss") ; for define-datatype, etc.


;; helper
(define list-of
  (lambda (pred)
    (lambda (val)
      (or (null? val)
          (and (pair? val)
               (pred (car val))
               ((list-of pred) (cdr val)))))))


;; environment definitions

;;
(define scheme-value?
  (lambda (x) #t))

;;
;; (define-datatype environment environment?
;;   (empty-env-record)
;;   (extended-env-record
;;    (syms (list-of symbol?))
;;    (vals (list-of scheme-value?))
;;    (env environment?))
;;   (recursively-extended-env-record
;;    (proc-names (list-of symbol?))
;;    (ids (list-of (list-of symbol?)))
;;    (bodies (list-of expression?))
;;    (env environment?)))


;  10/24 I changed the environment to a ribcage here.
; Still need to change recursive version.

(define empty-env
  (lambda ()
    '()))

(define environment?
  (lambda (x)
    (or (null? x)
	(and (pair? x)
	     (pair? (car x))
	     (list? (caar x))
	     (vector? (cdar x))
	     (environment? (cdr x))))))

(define extend-env
  (lambda (syms vals env)
    (cons (cons syms (list->vector (map cell vals))) env)))

;
;; (define extend-env-recursively
;;   (lambda (proc-names ids bodies old-env)
;;     (recursively-extended-env-record proc-names ids bodies old-env)))

;; (define extend-env-recursively
;;   (lambda (proc-names idss bodies old-env)
;;     (let ((len (length proc-names)))
;;       (let ((vec (make-vector len)))
;;         (let ((env (cons (cons proc-names vec) old-env)))
;;           (for-each
;;             (lambda (pos ids body)
;;               (vector-set! vec pos (cell (closure ids body env))))
;;             (iota len) idss bodies)
;;           env)))))

;; (define iota
;;   (lambda (end)
;;     (let loop ((next 0))
;;       (if (>= next end) '()
;;         (cons next (loop (+ 1 next)))))))


(define list-find-position
  (lambda (sym los)
    (list-index (lambda (xsym) (eqv? sym xsym)) los)))

(define list-index
  (lambda (pred ls)
    (cond
     ((null? ls) #f)
     ((pred (car ls)) 0)
     (else (let ((list-index-r (list-index pred (cdr ls))))
	     (if (number? list-index-r)
		 (+ 1 list-index-r)
		 #f))))))

(define apply-env-ref
  (lambda (env sym)
    (cond
     [(null? env) (apply-global-env-ref sym)]
     [else (let ([syms (caar env)]
		 [vals (cdar env)]
		 [env (cdr env)])
	     (let ((pos (list-find-position sym syms)))
	       (if (number? pos)
		   (vector-ref vals pos)
		   (apply-env-ref env sym))))]
;      [recursively-extended-env-record
;       (procnames ids bodies old-env)
;       (let ([pos (list-find-position sym procnames)])
;	 (if (number? pos)
;	     (closure (list-ref ids pos)
;		      (list-ref bodies pos)
;		      env)
;	     (apply-env old-env sym)))]
	   
   )))


(define apply-env
  (lambda (env id)
    (deref (apply-env-ref env id))))
(define apply-global-env-ref
  (lambda (sym)
    (let ([syms (caar global-env)]
	  [vals (cdar global-env)]
	  )
        (let ((pos (list-find-position sym syms)))
          (if (number? pos)
              (vector-ref vals pos)
              (eopl:error 'apply-global-env "no binding for ~s" sym))))))

(define cell box)
(define cell-ref unbox)
(define cell-set! set-box!)
(define cell? box?)

(define deref cell-ref)
(define setref! cell-set!)


;; Nathan Froyd wrote:
;; It would be better to pass succeed and fail continuations to apply-env,
;; rather than invoking error when the lookup fails.
;; We may discuss this later.



; Datatype for procedures.  At first there is only one
; kind of procedure, but more kinds will be added later.

(define-datatype proc-val proc-val?
  [prim-proc
   (name symbol?)]
  [escape-proc (real-proc proc-val?)]
  [trace-closure
   (trace-name symbol?)
   (formals (list-of symbol?))
   (body    expression?)
   (env     environment?)]
  [closure
   (formals (list-of symbol?))
   (body    expression?)
   (env     environment?)])

(define-datatype expression expression?
  [var-exp        ; variable references
   (id symbol?)]
  [lit-exp        ; "Normal" data.  Did I leave out any types?
   (datum  (lambda (x)
	     (ormap (lambda (pred) (pred x))
		    (list number? vector? boolean? symbol?
			  string? pair? null?))))]
  [app-exp        ; applications
   (rator expression?)
   (rands (list-of expression?))]
  [lambda-exp     ; lambda expressions
   (formals (list-of symbol?))
   (body expression?)]
  [trace-lambda-exp     
   (trace-name symbol?)
   (formals (list-of symbol?))
   (body expression?)]
  [begin-exp
   (exps (list-of expression?))]
  [varassign-exp
   (id symbol?)
   (exp expression?)]
  [let-exp     ; lambda expressions
   (vars (list-of symbol?))
   (exps (list-of expression?))
   (bodies (list-of expression?))]
  [letrec-exp
   (proc-names (list-of symbol?))
   (ids (list-of (list-of symbol?)))
   (bodies (list-of expression?))
   (letrec-body expression?)]
  [if-exp         ; if expressions (must have an "else" part)
   (test-exp expression?)
   (true-exp expression?)
   (false-exp expression?)]
  ;; for exam 2 2009
  [for-exp
   (init expression?)
   (test expression?)
   (update expression?)
   (bodies (list-of expression?))]
  ;; maybe not needed, but was in the file already
  [lex-info
   (distance number?)
   (position number?)])


; Procedures to make the parser a little bit saner.
(define 1st car)
(define 2nd cadr)
(define 3rd caddr)
(define 4th cadddr)

(define proper-list?     ; for example, '(a b . c) is not a proper-list.
  (lambda (exp)
    (cond [(null? exp) #t]
          [(atom? exp) #f]
          [else (proper-list? (cdr exp))])))

(define set?
  (lambda (sym-list)
    (cond [(null? sym-list) #t]
          [(member (car sym-list) (cdr sym-list)) #f]
          [else (set? (cdr sym-list))])))

(define parse-exp         
  (lambda (datum)
    (cond
     [(symbol? datum) (var-exp datum)]
     [(number? datum) (lit-exp datum)]
     [(member datum (list #f #t '())) (lit-exp datum)]     
     [(pair? datum)
      (cond
       [(eq? (1st datum) 'quote) (lit-exp (2nd datum))]
       ;; add error checking to the above.
       [(eq? (1st datum) 'lambda)
        (cond [(not (= (length datum) 3))
               (error 'parse "lambda-expression: incorrect length ~s" datum)]
              [(not (proper-list? datum))
               (error 'parse "lambda-expression: ~s is not a list" datum)]
	      ; You should add other correctness  tests, of course.
            [else (lambda-exp (2nd datum)
                                (parse-exp (3rd datum)))])]
       [(eq? (1st datum) 'trace-lambda)
          (trace-lambda-exp (2nd datum) (3rd datum)
                                (parse-exp (4th datum)))]
       [(eq? (1st datum) 'let)
	                       ;(display "*********** let ") (newline)
	(let-exp (map car (2nd datum))
		 (map (lambda (x) (parse-exp (cadr x))) (2nd datum))
		 (map parse-exp (cddr datum)))]
       [ (eq? (1st datum) 'letrec)
	 (letrec-exp (map 1st (2nd datum))
		     (map (lambda (exp) (2nd (2nd exp))) (2nd datum))
		     (map (lambda (exp) (parse-exp (3rd (2nd exp))))
			  (2nd datum))
		     (parse-exp (3rd datum)))]
       [(eq? (1st datum) 'begin)
	(begin-exp (map parse-exp (cdr datum)))]
       [(eq? (1st datum) 'set!)
	(varassign-exp (2nd datum) (parse-exp (3rd datum)))]
       ;; for exam 3
       [(eq? (car datum) 'for) ; no error checking here.
	(for-exp (parse-exp (car (cadr datum)))
		 (parse-exp (cadr (cadr datum)))
		 (parse-exp (caddr (cadr  datum)))
		 (map parse-exp (cddr datum)))]
	
       [(eq? (1st datum) 'if)
        (if (= (length datum) 4)
            (apply if-exp (map parse-exp (cdr datum)))
            (error 'parse
                   "if ~s does not have (only) test, then, and else"
                   datum))]
       [(not (proper-list? datum))
        (error 'parse "application ~s is not a proper list" datum)]
       [else (app-exp (parse-exp (1st datum))
		      (map parse-exp (cdr datum)))])]
     [else (error 'parse "bad expression: ~s" datum)])))


(define unparse-exp ; I haven't tested this much yet.
  (lambda (exp)
    (cases expression exp
      [var-exp (var) var]
      [lit-exp (datum) datum]
      [lex-info (distance position) (list ': distance position)]
      [lambda-exp (formals body) (list 'lambda
                                       formals
                                       (unparse-exp body))]
      [if-exp (test-exp then-exp else-exp)
        (cons 'if (map unparse-exp (list test-exp then-exp else-exp)))]
      [app-exp (rator rands) (cons (unparse-exp rator) (map unparse-exp rand))]
      [else (eopl:error 'unparse "malformed abstract syntax ~a" exp)])))

