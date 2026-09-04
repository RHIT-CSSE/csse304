#lang racket

; In-class examples: lambda-depth, max-vars, replace-vars-with-depth,
; and replace-depth-with-vars (the reverse of problem 3)
; (solutions)
;
; All three problems use the simplified lambda-calculus representation
; that we used for occurs-bound? and occurs-free?:
;
;   <LcExp> ::= <identifier>
;            |  (lambda (<identifier>) <LcExp>)
;            |  (<LcExp> <LcExp>)
;
; An LcExp is represented with ordinary Scheme data:
;
;   * an identifier (a variable use) is a symbol, e.g.  x
;
;   * an abstraction (lambda (x) body) is the list  (lambda (x) body)
;       - the bound variable is (caadr exp)
;       - the body is (third exp)
;
;   * an application (rator rand) is a two-element list  (rator rand)
;       - (first exp) is the rator, (second exp) is the rand

; ----------------------------------------------------------------------
; Problem 1: lambda-depth
;
; (lambda-depth exp) returns the deepest level of lambda nesting in
; exp.  A variable use is at depth 0, a lambda expression is at depth
; 1 plus the depth of its body, and an application is at the depth of
; its deeper subexpression.

(define lambda-depth
  (lambda (exp)
    (cond [(symbol? exp) 0]
          [(eqv? 'lambda (car exp))
           (add1 (lambda-depth (third exp)))]
          [else (max (lambda-depth (first exp))
                     (lambda-depth (second exp)))])))

(lambda-depth 'x) ; 0
(lambda-depth '(lambda (x) x)) ; 1
(lambda-depth '(lambda (x) (x x))) ; 1
(lambda-depth '(lambda (x) (lambda (y) x))) ; 2
(lambda-depth '(lambda (x) (lambda (x) x))) ; 2
(lambda-depth '(lambda (x) (lambda (y) (lambda (z) (z y))))) ; 3
(lambda-depth '((lambda (x) x) (lambda (y) (lambda (z) (y z))))) ; 2

; ----------------------------------------------------------------------
; Problem 2: max-vars
;
; (max-vars exp) returns the largest number of variables that are in
; scope at any point inside exp.  Because an inner binding shadows an
; outer binding with the same name, this is the number of DISTINCT
; variable names bound by the enclosing lambdas, not the number of
; enclosing lambdas.
;
; The helper threads the bound variables of the enclosing lambdas
; (duplicates are kept -- each new lambda's bound variable is simply
; consed onto the front) together with the current number of distinct
; variables in scope.  Entering a lambda only increases that count if
; the lambda's variable name is not already in bound-vars.

(define max-vars
  (lambda (exp)
    (max-vars-helper exp '() 0)))

(define max-vars-helper
  (lambda (exp bound-vars count)
    (cond [(symbol? exp) count]
          [(eqv? 'lambda (car exp))
           (max-vars-helper (third exp)
                            (cons (caadr exp) bound-vars)
                            (if (member (caadr exp) bound-vars)
                                count
                                (add1 count)))]
          [else (max (max-vars-helper (first exp) bound-vars count)
                     (max-vars-helper (second exp) bound-vars count))])))

(max-vars 'x) ; 0
(max-vars '(lambda (x) x)) ; 1
(max-vars '(lambda (x) (lambda (y) (x y)))) ; 2
(max-vars '(lambda (x) (lambda (x) (x x)))) ; 1
(max-vars '(lambda (x) (lambda (y) (lambda (x) (x y))))) ; 2
(max-vars '((lambda (x) (x x)) (lambda (x) x))) ; 1

; ----------------------------------------------------------------------
; Problem 3: replace-vars-with-depth
;
; (replace-vars-with-depth exp) transforms exp into a new expression in
; which every USE of a bound variable is replaced by the number of
; lambda scopes one must pass through to reach the lambda that binds it
; (0 for the immediately enclosing lambda).  A variable that is not
; bound by any enclosing lambda is FREE: its use is left unchanged (it
; keeps its name).  The lambda binders and the overall structure are
; preserved.
;
; The helper threads the bound variables of the enclosing lambdas, with
; the most recent binding at the front.  A bound variable's number is
; its 0-based position in bound-vars; the first match is the binding
; that is actually in scope.  (member var bound-vars) gives the part of
; bound-vars that starts at the first occurrence of var, so the depth
; is (- (length bound-vars) (length (member var bound-vars))).

(define replace-vars-with-depth
  (lambda (exp)
    (replace-vars-with-depth-helper exp '())))

(define replace-vars-with-depth-helper
  (lambda (exp bound-vars)
    (cond [(symbol? exp)
           (let ([var-rest (member exp bound-vars)])
             (if var-rest
                 (- (length bound-vars) (length var-rest))
                 exp))]
          [(eqv? 'lambda (car exp))
           (list 'lambda (list (caadr exp))
                 (replace-vars-with-depth-helper
                  (third exp)
                  (cons (caadr exp) bound-vars)))]
          [else (list (replace-vars-with-depth-helper (first exp) bound-vars)
                      (replace-vars-with-depth-helper (second exp) bound-vars))])))

(replace-vars-with-depth '(lambda (x) x)) ; '(lambda (x) 0)
(replace-vars-with-depth '(lambda (x) (x x))) ; '(lambda (x) (0 0))
(replace-vars-with-depth '(lambda (x) (lambda (y) x))) ; '(lambda (x) (lambda (y) 1))
(replace-vars-with-depth '(lambda (x) y)) ; '(lambda (x) y)
(replace-vars-with-depth '(lambda (x) (lambda (x) (x x)))) ; '(lambda (x) (lambda (x) (0 0)))
(replace-vars-with-depth '(x (lambda (x) (y x)))) ; '(x (lambda (x) (y 0)))
(replace-vars-with-depth '(lambda (x) (lambda (y) (lambda (x) (x y))))) ; '(lambda (x) (lambda (y) (lambda (x) (0 1))))
(replace-vars-with-depth '(lambda (x) (lambda (y) (x (y x))))) ; '(lambda (x) (lambda (y) (1 (0 1))))
(replace-vars-with-depth '((lambda (x) (x (lambda (y) (x y)))) (lambda (z) z))) ; '((lambda (x) (0 (lambda (y) (1 0)))) (lambda (z) 0))

; ----------------------------------------------------------------------
; Problem 4 (for fun): replace-depth-with-vars
;
; This is the reverse of Problem 3.  Given an expression in the
; translated form produced by replace-vars-with-depth, put the variable
; names back.  In the translated form, each leaf is either
;
;   * a number n, meaning the variable bound n scopes out from here, or
;   * a symbol, meaning a free variable (its name is already there).
;
; A number leaf is replaced by the variable name bound n scopes out,
; i.e. the element at position n of the bound-vars list of the
; enclosing lambdas (most recent binding first).  A symbol leaf is
; already a free variable's name, so it is left alone.  The lambda
; binders and overall structure are unchanged, so
; (replace-depth-with-vars (replace-vars-with-depth exp)) gives back
; the original exp.

(define replace-depth-with-vars
  (lambda (exp)
    (replace-depth-with-vars-helper exp '())))

(define replace-depth-with-vars-helper
  (lambda (exp bound-vars)
    (cond [(symbol? exp) exp]
          [(number? exp) (list-ref bound-vars exp)]
          [(eqv? 'lambda (car exp))
           (list 'lambda (list (caadr exp))
                 (replace-depth-with-vars-helper
                  (third exp)
                  (cons (caadr exp) bound-vars)))]
          [else (list (replace-depth-with-vars-helper (first exp) bound-vars)
                      (replace-depth-with-vars-helper (second exp) bound-vars))])))

(replace-depth-with-vars '(lambda (x) 0)) ; '(lambda (x) x)
(replace-depth-with-vars '(lambda (x) (0 0))) ; '(lambda (x) (x x))
(replace-depth-with-vars '(lambda (x) (lambda (y) 1))) ; '(lambda (x) (lambda (y) x))
(replace-depth-with-vars '(lambda (x) y)) ; '(lambda (x) y)
(replace-depth-with-vars '(x (lambda (x) (y 0)))) ; '(x (lambda (x) (y x)))
(replace-depth-with-vars '(lambda (x) (lambda (x) 0))) ; '(lambda (x) (lambda (x) x))
(replace-depth-with-vars '((lambda (x) (0 (lambda (y) (1 0)))) (lambda (z) 0))) ; '((lambda (x) (x (lambda (y) (x y)))) (lambda (z) z))
