#lang racket
(require "chez-init.rkt")
(provide check)
;; ============================================================================
;; Type Checker — Starter Code
;; ============================================================================
;; Implement a type checker for a small functional language with explicit
;; type annotations on functions.
;;
;; Your tasks are marked with TODO.  Work through the phases in order:
;;   Phase 1: Literals and arithmetic
;;   Phase 2: Conditionals
;;   Phase 3: Variables, functions, and application
;;   Phase 4: Let expressions
;; ============================================================================



;; ============================================================================
;; Type Definitions
;; ============================================================================

(define-datatype type type?
  (tnum)                                ; the numeric type
  (tbool)                               ; the boolean type
  (tfun                                 ; function type: arg → ret
   (arg type?)
   (ret type?)))

;; ============================================================================
;; AST Definitions
;; ============================================================================

(define-datatype expression expression?
  (num-e                                ; numeric literal
   (val number?))
  (bool-e                               ; boolean literal
   (val boolean?))
  (var-e                                ; variable reference
   (name symbol?))
  (add-e                                ; (+ e1 e2)
   (lhs expression?)
   (rhs expression?))
  (sub-e                                ; (- e1 e2)
   (lhs expression?)
   (rhs expression?))
  (if-e                                 ; (if e1 e2 e3)
   (cond-exp expression?)
   (then-exp expression?)
   (else-exp expression?))
  (fun-e                                ; (fun (x : τ) : τ_ret body)
   (param symbol?)
   (param-type type?)
   (ret-type type?)
   (body expression?))
  (app-e                                ; (e1 e2)
   (func expression?)
   (arg expression?))
  (let-e                                ; (let ((x e1)) e2)
   (name symbol?)
   (binding expression?)
   (body expression?)))

;; ============================================================================
;; Type Formatting (for readable error messages)
;; ============================================================================

(define type->string
  (lambda (ty)
    (cases type ty
      (tnum () "Num")
      (tbool () "Bool")
      (tfun (a r)
        (string-append "(" (type->string a) " → " (type->string r) ")")))))

;; ============================================================================
;; Type Equality
;; ============================================================================

(define type-equal?
  (lambda (t1 t2)
    (cases type t1
      (tnum ()
        (cases type t2
          (tnum () #t)
          (else #f)))
      (tbool ()
        (cases type t2
          (tbool () #t)
          (else #f)))
      (tfun (a1 r1)
        (cases type t2
          (tfun (a2 r2)
            (and (type-equal? a1 a2)
                 (type-equal? r1 r2)))
          (else #f))))))

;; ============================================================================
;; Environment (association list)
;; ============================================================================
;; An environment is a list of (symbol . type) pairs.

(define empty-env '())

(define extend-env
  (lambda (name ty env)
    (cons (cons name ty) env)))

(define lookup-env
  (lambda (name env)
    (let ([pair (assq name env)])
      (if pair
          (cdr pair)
          (error 'type-check
                 (string-append "unbound variable: "
                                (symbol->string name)))))))

;; ============================================================================
;; Parser
;; ============================================================================
;; Converts s-expressions into AST nodes.
;; Type annotations use this syntax:
;;   (fun (x : Num) : Num (+ x 1))
;;   (fun (f : (Num -> Num)) : Num (f 5))

;; Parse a type annotation
(define parse-type
  (lambda (ty-sexpr)
    (cond
      [(eq? ty-sexpr 'Num)  (tnum)]
      [(eq? ty-sexpr 'Bool) (tbool)]
      [(and (list? ty-sexpr) (= (length ty-sexpr) 3)
            (eq? (cadr ty-sexpr) '->))
       (tfun (parse-type (car ty-sexpr))
             (parse-type (caddr ty-sexpr)))]
      [else (error 'parse-type "unrecognized type" ty-sexpr)])))

;; Parse an expression
(define parse
  (lambda (sexpr)
    (cond
      [(number? sexpr)
       (num-e sexpr)]
      [(boolean? sexpr)
       (bool-e sexpr)]
      [(eq? sexpr 'true)  (bool-e #t)]
      [(eq? sexpr 'false) (bool-e #f)]
      [(symbol? sexpr)
       (var-e sexpr)]
      [(and (list? sexpr) (not (null? sexpr)))
       (case (car sexpr)
         [(+) (add-e (parse (cadr sexpr)) (parse (caddr sexpr)))]
         [(-) (sub-e (parse (cadr sexpr)) (parse (caddr sexpr)))]
         [(if) (if-e (parse (cadr sexpr))
                     (parse (caddr sexpr))
                     (parse (cadddr sexpr)))]
         [(fun)
          ;; (fun (x : Type) : RetType body)
          (let* ([param-list (cadr sexpr)]      ; (x : Type)
                 [param (car param-list)]        ; x
                 [param-ty (caddr param-list)]   ; Type
                 [ret-ty (cadddr sexpr)]         ; RetType
                 [body (car (cddddr sexpr))])    ; body
            (fun-e param
                   (parse-type param-ty)
                   (parse-type ret-ty)
                   (parse body)))]
         [(let)
          ;; (let ((x e1)) e2)
          (let* ([binding-list (caadr sexpr)]    ; (x e1)
                 [name (car binding-list)]
                 [binding (cadr binding-list)]
                 [body (caddr sexpr)])
            (let-e name (parse binding) (parse body)))]
         [else
          ;; Application: (e1 e2)
          (if (= (length sexpr) 2)
              (app-e (parse (car sexpr)) (parse (cadr sexpr)))
              (error 'parse "unrecognized expression" sexpr))])]
      [else (error 'parse "unrecognized expression" sexpr)])))

;; ============================================================================
;; TODO: Type Checker
;; ============================================================================
;; type-check : Env × Expr → Type
;;
;; The environment (env) is an association list mapping symbols to types.
;;
;; Returns the type of the expression if it is well-typed.
;; Raises an error with a descriptive message if it is ill-typed.

(define type-check
  (lambda (env expr)
    (cases expression expr

      ;; --- Phase 1: Literals and Arithmetic ---

      (num-e (val)
        ;; TODO: What type does a numeric literal always have?
        (error 'type-check "TODO: num-e"))

      (bool-e (val)
        ;; TODO: What type does a boolean literal always have?
        (error 'type-check "TODO: bool-e"))

      (add-e (lhs rhs)
        ;; TODO:
        ;; 1. Type-check both operands
        ;; 2. Verify both have type Num (use type-equal? and tnum)
        ;; 3. Return the result type
        (error 'type-check "TODO: add-e"))

      (sub-e (lhs rhs)
        ;; TODO: Same rules as addition.
        (error 'type-check "TODO: sub-e"))

      ;; --- Phase 2: Conditionals ---

      (if-e (cond-exp then-exp else-exp)
        ;; TODO:
        ;; 1. Type-check all three sub-expressions
        ;; 2. Verify the condition has type Bool
        ;; 3. Verify both branches have the same type (type-equal?)
        ;; 4. Return the branch type
        (error 'type-check "TODO: if-e"))

      ;; --- Phase 3: Variables, Functions, and Application ---

      (var-e (name)
        ;; TODO: Look up `name` in env using lookup-env.
        (error 'type-check "TODO: var-e"))

      (fun-e (param param-type ret-type body)
        ;; TODO:
        ;; 1. Extend the environment with param : param-type
        ;; 2. Type-check the body in the extended environment
        ;; 3. Verify the body's type matches ret-type (error otherwise)
        ;; 4. Return (tfun param-type ret-type)
        (error 'type-check "TODO: fun-e"))

      (app-e (func arg)
        ;; TODO:
        ;; 1. Type-check the function expression
        ;; 2. Verify it has a function type (tfun) — error if not
        ;;    Hint: use cases on the result type to destructure tfun
        ;; 3. Type-check the argument
        ;; 4. Verify the argument type matches the function's parameter type
        ;; 5. Return the function's return type
        (error 'type-check "TODO: app-e"))

      ;; --- Phase 4: Let ---

      (let-e (name binding body)
        ;; TODO:
        ;; 1. Type-check the binding expression
        ;; 2. Extend the environment with name : (type of binding)
        ;; 3. Type-check the body in the extended environment
        ;; 4. Return the body's type
        (error 'type-check "TODO: let-e"))
      )))

;; ======================================================================='x=====
;; Top-Level Entry Point
;; ============================================================================
;; check : s-expression → Type
;;
;; Parse and type-check in one step.

(define check
  (lambda (sexpr)
    (type-check empty-env (parse sexpr))))

;; ============================================================================
;; Helper: Check if a type is a tfun (for use in app-e)
;; ============================================================================
;; Since we cannot use predicates like tfun? directly with define-datatype,
;; here is a helper you may find useful in your app-e implementation.

(define tfun?
  (lambda (ty)
    (cases type ty
      (tfun (a r) #t)
      (else #f))))

