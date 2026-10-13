#lang racket/base

(require racket/set)

;;; cps-conversion-helper.rkt
;;;
;;; Infrastructure for CPS-conversion exercises.
;;;
;;;   (define-cps-procedure (my-new-proc p1 p2) code ...)
;;;
;;; defines an ordinary procedure: it runs `code ...` with p1 and p2 bound, it is
;;; called exactly like any lambda, (trace my-new-proc) traces it, and its arity
;;; is the one written in its parameter list.  What is special is that its source
;;; code is analysed once, as the procedure is defined:
;;;
;;;   (procs-in-non-tail-position my-new-proc)   -> (listof symbol?)
;;;
;;; returns the sorted names of the procedures that `code ...` applies in a
;;; non-tail position -- the calls that need a continuation when the body is
;;; converted to CPS.
;;;
;;;   (define-cps-procedure (add-then-double p1 p2) (* 2 (+ p1 p2)))
;;;   (define-cps-procedure (count-binones n)
;;;     (cond [(zero? n) 0]
;;;           [(even? n) (count-binones (quotient n 2))]
;;;           [else (+ 1 (count-binones (quotient n 2)))]))
;;;
;;;   (add-then-double 3 4)                             ;; => 14
;;;   (map (lambda (n) (add-then-double n n)) '(1 2))   ;; => '(4 8)
;;;   (procs-in-non-tail-position count-binones)
;;;   ;; => (count-binones even? quotient zero?)
;;;
;;; One definition therefore gives a test both the runnable reference behaviour
;;; of the procedure and the expected non-tail call list of its body:
;;;
;;;   (check-equal? (count-binones 200) 3)
;;;   (check-equal? (procs-in-non-tail-position count-binones)
;;;                 '(count-binones even? quotient zero?))
;;;
;;; Looking up a procedure that was not defined with define-cps-procedure says
;;; so, rather than returning an arbitrary answer.
;;;
;;; See the comment above procs-in-non-tail-position/code for what counts as tail
;;; position and which forms are understood.

(provide define-cps-procedure
         procs-in-non-tail-position)

;; The analysis of each procedure is computed as that procedure is defined and
;; kept here, keyed by the procedure itself.  eq? is the comparison that matters:
;; every lambda is its own procedure object, so two identically written
;; definitions get two entries and neither can answer for the other.  The table
;; is weak, so a procedure the program has dropped -- leaving only the table
;; referring to it -- takes its entry with it instead of staying alive for the
;; rest of the session; a procedure you can still look up is one you still hold.
(define non-tail-procs-of (make-weak-hasheq))

(define (record-cps-procedure proc code)
  (hash-set! non-tail-procs-of proc (procs-in-non-tail-position/code code))
  proc)

;; procs-in-non-tail-position : procedure? -> (listof symbol?)
;;
;; The non-tail call list that was recorded for `proc` when it was defined with
;; define-cps-procedure.
(define (procs-in-non-tail-position proc)
  (hash-ref non-tail-procs-of proc
            (lambda ()
              (error 'procs-in-non-tail-position
                     (string-append
                      "no non-tail call analysis for ~a: it was not defined with"
                      " define-cps-procedure, or its binding was replaced since"
                      " (tracing a procedure rebinds it)")
                     (or (object-name proc) proc)))))

(define-syntax define-cps-procedure
  (syntax-rules ()
    [(_ (name arg ... . rest) body0 body ...)
     (define name
       (record-cps-procedure
        (lambda (arg ... . rest) body0 body ...)
        '(define-cps-procedure (name arg ... . rest) body0 body ...)))]))

;;; ---------------------------------------------------------------------------
;;; Non-tail call analysis
;;;
;;; (procs-in-non-tail-position/code code) takes the source code of a
;;; define-cps-procedure form and returns the names of the procedures that its
;;; body applies in a non-tail position -- the calls that need a continuation
;;; when the body is converted to CPS.  A call is a tail call when it is the
;;; call that returns the procedure's own answer, so its result is passed
;;; straight on instead of being inspected.  R5RS/R7RS section 3.5 defines tail
;;; contexts inductively; the cond in `non-tail-procs` below is a direct
;;; transcription of its cases:
;;;
;;;   (if test then else)          test is non-tail, then/else keep the position
;;;   (cond clause ...)            tests are non-tail
;;;   (case key clause ...)        key is non-tail, every clause body keeps the
;;;                                position (not just the else clause)
;;;   (cases Type-name e clause ...)  the datatype dispatch from chez-init.rkt:
;;;                                a clause head is a variant name and its field
;;;                                names, so only the clause body is scanned
;;;   (cond (test => receiver))    the implied call to receiver keeps the
;;;                                position, the receiver expression does not;
;;;                                Racket's case has no arrow clause
;;;   (and e ...) etc.             only the last expression keeps the position
;;;   (let (binding ...) body ...) binding inits are non-tail, body keeps it
;;;   (lambda formals body ...)    see the exception noted at that clause
;;;   (f arg ...)                  f and every arg are non-tail, and f itself is
;;;                                reported unless the call is a tail call
;;;
;;; Every other form is treated as a procedure call: its name is reported when
;;; the form is non-tail and all of its subexpressions are scanned as non-tail
;;; code.  That is the conservative direction -- a form that is really
;;; tail-positioned but unhandled can only add a name that does not belong,
;;; never hide one that does.  Adding a clause for such a form removes the
;;; false report.  Unhandled on purpose for now: do, case-lambda, parameterize,
;;; guard, delay, and the Racket-specific for/... and match forms.
;;;
;;; The walker indexes into forms directly -- (cadddr (if ...)), (cadr (binding
;;; ...)) -- so it assumes well-formed Racket syntax, as define-cps-procedure
;;; provides by only ever analysing code that compiled.

;; procs-in-non-tail-position/code : pair? -> (listof symbol?)
(define (procs-in-non-tail-position/code code)
  ;; `code` is (define-cps-procedure (name arg ...) body ...), so (cddr code) is
  ;; the body.  The last expression of that body is the procedure's answer, which
  ;; is the one expression that starts out in tail position.  The set collapses
  ;; duplicates; the sort makes the list order depend only on the names.
  (sort (set->list (body-procs (cddr code) #t))
        symbol<?))

(define let-forms
  '(let let* letrec letrec* let-values let*-values let-syntax letrec-syntax))

;; non-tail-procs : datum boolean? -> (setof symbol?)
;;
;; The procedure names applied in a non-tail position inside `expr`.
;;
;; `in-tail?` says whether the value of `expr` is passed back unchanged as the
;; answer of the procedure being analysed, i.e. whether a call sitting in
;; `expr`'s own position would be a tail call.  Every subexpression that is not
;; itself the answer of the whole procedure is visited with #f, and that is what
;; makes a name land in the result.
(define (non-tail-procs expr in-tail?)
  (cond
    ;; literals, strings, vectors, variables: nothing is applied
    [(not (pair? expr)) (set)]

    ;; quoted text is data, not code, so (quote (f x)) applies nothing
    [(memq (car expr) '(quote quasiquote)) (set)]

    ;; (if test then else): the test runs before the branch is chosen, and the
    ;; branch that is chosen answers in place of the if.  Racket requires the
    ;; else expression -- (if test then) is a syntax error, unlike R5RS -- so
    ;; there is no one-armed case to check for
    [(eq? (car expr) 'if)
     (set-union (non-tail-procs (cadr expr) #f)
                (non-tail-procs (caddr expr) in-tail?)
                (non-tail-procs (cadddr expr) in-tail?))]

    ;; (cond clause ...) and (case key clause ...): whichever clause fires
    ;; answers in place of the whole expression, so every clause body is in the
    ;; position of the cond/case; only the tests and the case key are non-tail
    [(eq? (car expr) 'cond) (clauses-procs (cdr expr) cond-clause-procs in-tail?)]
    [(eq? (car expr) 'case)
     (set-union (non-tail-procs (cadr expr) #f)
                (clauses-procs (cddr expr) case-clause-procs in-tail?))]

    ;; (cases Type-name scrutinee clause ...), the datatype dispatch from
    ;; chez-init.rkt: like cond, whichever clause fires answers in place of the
    ;; whole form, and the scrutinee is evaluated first
    [(eq? (car expr) 'cases)
     (set-union (non-tail-procs (caddr expr) #f)
                (clauses-procs (cdddr expr) cases-clause-procs in-tail?))]

    ;; (and e ...), (or e ...), (begin e ...): the last expression can answer in
    ;; place of the whole form, the earlier ones are evaluated for effect
    [(memq (car expr) '(and or begin)) (body-procs (cdr expr) in-tail?)]
    [(memq (car expr) '(when unless))
     (set-union (non-tail-procs (cadr expr) #f)
                (body-procs (cddr expr) in-tail?))]

    ;; the let family, named let included: the bindings are evaluated before the
    ;; body can run, so their expressions are non-tail, and then the body takes
    ;; over the position of the let
    [(memq (car expr) let-forms) (let-procs expr in-tail?)]

    ;; (lambda formals body ...).  Strictly, the last expression of a lambda
    ;; body is where that closure returns from, so a call there is a tail call
    ;; *for the closure* (R5RS 3.5).  But the lambdas met while analysing a
    ;; procedure are normally arguments to map, filter, or similar, i.e. they
    ;; are not the code this procedure returns, so what they run does not
    ;; happen on this procedure's way out.  Handing the position down unchanged
    ;; means a lambda in tail position keeps tail position inside, and every
    ;; other lambda -- by far the common case -- is scanned as non-tail code.
    [(eq? (car expr) 'lambda) (body-procs (cddr expr) in-tail?)]

    ;; a definition inside a body: not the body's tail expression, and it
    ;; defines another one of those procedures that are not being returned here
    [(memq (car expr) '(define define-values)) (definition-procs expr)]

    ;; (set! variable expr): expr is stored, not returned
    [(eq? (car expr) 'set!) (non-tail-procs (caddr expr) #f)]

    ;; anything else is a procedure call, (rator rand ...): the callee settles
    ;; whether the call is a tail call, and every operand is non-tail
    [else (set-union (callee-procs (car expr) in-tail?)
                     (args-procs (cdr expr)))]))

;; A body, or the body of a sequence: the last expression can be the answer of
;; the whole form, the earlier ones are evaluated for their effect.
(define (body-procs forms in-tail?)
  (cond
    [(null? forms) (set)]
    [(null? (cdr forms)) (non-tail-procs (car forms) in-tail?)]
    [else (set-union (non-tail-procs (car forms) #f)
                     (body-procs (cdr forms) in-tail?))]))

;; Every expression in the list is evaluated before the surrounding call, so
;; none of them is in tail position.
(define (args-procs exprs)
  (cond
    [(null? exprs) (set)]
    [else (set-union (non-tail-procs (car exprs) #f)
                     (args-procs (cdr exprs)))]))

;; (let (binding ...) body ...) or (let name (binding ...) body ...), plus the
;; let*, letrec, let-values, let-syntax ... variants, which differ in how their
;; bindings are evaluated but not in where the body sits.
(define (let-procs expr in-tail?)
  (define named? (symbol? (cadr expr)))
  (set-union (bindings-procs (if named? (caddr expr) (cadr expr)))
             (body-procs (if named? (cdddr expr) (cddr expr)) in-tail?)))

;; Each binding is (name init) or, for the -values forms, ((name ...) init).
(define (bindings-procs bindings)
  (cond
    [(null? bindings) (set)]
    [else (set-union (non-tail-procs (cadr (car bindings)) #f)
                     (bindings-procs (cdr bindings)))]))

(define (clauses-procs clauses clause-procs in-tail?)
  (cond
    [(null? clauses) (set)]
    [else (set-union (clause-procs (car clauses) in-tail?)
                     (clauses-procs (cdr clauses) clause-procs in-tail?))]))

;; cond's clauses are (test body ...), (test => receiver), or (else body ...),
;; and its test is an expression.
(define (cond-clause-procs clause in-tail?)
  (cond
    [(and (pair? (cdr clause)) (eq? '=> (cadr clause)))
     (set-union (non-tail-procs (car clause) #f)
                (callee-procs (caddr clause) in-tail?))]
    [(eq? (car clause) 'else) (body-procs (cdr clause) in-tail?)]
    [else (set-union (non-tail-procs (car clause) #f)
                     (body-procs (cdr clause) in-tail?))]))

;; A case clause is ((datum ...) body ...) or (else body ...), so its head is a
;; list of data rather than an expression and only the body is scanned.  Racket's
;; case has no => clause either -- that arrow is R7RS-only, and Racket reads it
;; as a body expression and rejects the clause -- so unlike cond's there is no
;; receiver to account for.
(define (case-clause-procs clause in-tail?)
  (body-procs (cdr clause) in-tail?))

;; A cases clause is (variant-name (field-name ...) body ...) or (else body ...):
;; the variant name and the field names are data, so only the body is scanned.
;; Each clause body answers in place of the whole cases, exactly as a cond clause
;; body does -- chez-init's cases applies the chosen clause's body in tail
;; position (R5RS: the first argument to apply is called via a tail call).
(define (cases-clause-procs clause in-tail?)
  (body-procs (if (eq? (car clause) 'else) (cdr clause) (cddr clause)) in-tail?))

;; The callee position: the operator of a call, and the receiver of a cond =>
;; clause, since cond is what applies that receiver.  This is where the
;; procedure being called is written, so a symbol here is reported like any
;; other non-tail call -- a symbol anywhere else (an operand, a branch, a body)
;; is a variable reference, not a call, so this is the only place a symbol that
;; is not itself an application can become an entry in the result.
;;
;; A callee that is itself an expression, as in ((f x) y), has no name to report;
;; scanning it as non-tail code is what reports the f inside it.  A callee sitting
;; in tail position is a tail call, which is why nothing is reported for it --
;; for a cond receiver that is R5RS 3.5's rule that the implied call is in tail
;; position exactly when the whole cond is, while the receiver expression itself
;; is not.
(define (callee-procs callee in-tail?)
  (if (and (not in-tail?) (symbol? callee))
      (set-add (set) callee)
      (non-tail-procs callee #f)))

;; (define (name arg ...) body ...), (define name expr), (define-values
;; (name ...) expr).  The body of the inner procedure is scanned like any other
;; lambda body.
(define (definition-procs expr)
  (cond
    [(eq? (car expr) 'define-values) (non-tail-procs (caddr expr) #f)]
    [(pair? (cadr expr)) (body-procs (cddr expr) #f)]
    [else (non-tail-procs (caddr expr) #f)]))
