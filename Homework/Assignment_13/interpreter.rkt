#lang racket

(require "../chez-init.rkt")
(provide eval-one-exp)

;-------------------+
;                   |
;   sec:DATATYPES   |
;                   |
;-------------------+

; parsed expression.  You'll probably want to replace this 
; code with your expression datatype from A11b

(define-datatype expression expression?  
  [var-exp        ; variable references
   (id symbol?)]
  [lit-exp        ; "Normal" data.  Did I leave out any types?
   (datum
    (lambda (x)
      (ormap 
       (lambda (pred) (pred x))
       (list number? vector? boolean? symbol? string? pair? null?))))]
  [app-exp        ; applications
   (rator expression?)
   (rands (list-of? expression?))]  
  )
	

;; environment type definitions

(define scheme-value?
  (lambda (x) #t))
  
(define-datatype environment environment?
  [empty-env-record]
  [extended-env-record
   (syms (list-of? symbol?))
   (vals (list-of? scheme-value?))
   (env environment?)])


; datatype for procedures.  At first there is only one
; kind of procedure, but more kinds will be added later.

(define-datatype proc-val proc-val?
  [prim-proc
   (name symbol?)])

  
;-------------------+
;                   |
;    sec:PARSER     |
;                   |
;-------------------+

; This is a parser for simple Scheme expressions, such as those in EOPL 3.1 thru 3.3.

; You will want to replace this with your parser that includes more expression types, more options for these types, and error-checking.

; Again, you'll probably want to use your code from A11b

(define parse-exp         
  (lambda (datum)
    (cond
      [(symbol? datum) (var-exp datum)]
      [(number? datum) (lit-exp datum)]
      [(pair? datum)
       (cond
         [else (app-exp (parse-exp (first datum))
                        (map parse-exp (cdr datum)))])]
      [else (error 'parse-exp "bad expression: ~s" datum)])))


;-------------------+
;                   |
; sec:ENVIRONMENTS  |
;                   |
;-------------------+

; Pick your favorite representation based on the lecture

(define apply-env
  (lambda (env id)
    (if (equal? id '+)
        (prim-proc '+)
        (error "this is not a real environment implementation"))))

;-----------------------+
;                       |
;  sec:SYNTAX EXPANSION |
;                       |
;-----------------------+

; To be added in assignment 14.

;---------------------------------------+
;                                       |
; sec:CONTINUATION DATATYPE and APPLY-K |
;                                       |
;---------------------------------------+

; To be added in assignment 18a.


;-------------------+
;                   |
;  sec:INTERPRETER  |
;                   |
;-------------------+

; top-level-eval evaluates a form in the global environment

(define top-level-eval
  (lambda (form)
    ; later we may add things that are not expressions.
    (eval-exp form)))

; eval-exp is the main component of the interpreter

(define eval-exp
  (lambda (exp)
    (cases expression exp
      [lit-exp (datum) datum]
      [var-exp (id)
               (apply-env init-env id)]
      [app-exp (rator rands)
               (let ([proc-value (eval-exp rator)]
                     [args (eval-rands rands)])
                 (apply-proc proc-value args))]
      [else (error 'eval-exp "Bad abstract syntax: ~a" exp)])))

; evaluate the list of operands, putting results into a list

(define eval-rands
  (lambda (rands)
    (map eval-exp rands)))

;  Apply a procedure to its arguments.
;  At this point, we only have primitive procedures.  
;  User-defined procedures will be added later.

(define apply-proc
  (lambda (proc-value args)
    (cases proc-val proc-value
      [prim-proc (op) (apply-prim-proc op args)]
      ; You will add other cases
      [else (error 'apply-proc
                   "Attempt to apply bad procedure: ~s" 
                   proc-value)])))



(define init-env         ; you'll want to have a global environment with the prim procs and maybe other stuff
  '())



(define apply-prim-proc
  (lambda (prim-proc args)
    (case prim-proc
      [(+) (+ (first args) (second args))]
      [(-) (- (first args) (second args))]
      [(*) (* (first args) (second args))]
      [(add1) (+ (first args) 1)]
      [(sub1) (- (first args) 1)]
      [(cons) (cons (first args) (second args))]
      [(=) (= (first args) (second args))]
      [else (error 'apply-prim-proc 
                   "Bad primitive procedure name: ~s" 
                   prim-proc)])))

(define rep      ; "read-eval-print" loop.
  (lambda ()
    (display "--> ")
    ;; notice that we don't save changes to the environment...
    (let ([answer (top-level-eval (parse-exp (read)))])
      ;; TODO: are there answers that should display differently?
      (pretty-print answer) (newline)
      (rep))))  ; tail-recursive, so stack doesn't grow.

(define eval-one-exp
  (lambda (x) (top-level-eval (parse-exp x))))
