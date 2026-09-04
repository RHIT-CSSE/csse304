#lang racket

; In-class examples: lambda-depth, max-vars, replace-vars-with-depth,
; and replace-depth-with-vars (its reverse)
;
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
;
; Every lambda binds exactly one variable and every application has
; exactly two subexpressions.  You may assume that the arguments to
; these functions are always valid LcExps (no error checking is
; needed).  Mutation is not allowed.

; ----------------------------------------------------------------------
; Problem 1: lambda-depth
;
; (lambda-depth exp) returns the deepest level of lambda nesting in
; exp.
;
; Think of the "depth" of a subexpression as the number of lambdas that
; enclose it:
;
;   * a variable use is at depth 0
;   * a lambda expression is at depth 1 plus the depth of its body
;   * an application is at depth max(depth of rator, depth of rand)
;
; Then lambda-depth returns the depth of the whole expression it is
; given.  Since every lambda adds one level to everything inside its
; body, this is the same as the number of lambdas in the longest chain
; of nested lambdas in the expression.
;
; Examples:
;   (lambda-depth '(lambda (x) x)) => 1
;   (lambda-depth '(lambda (x) (lambda (y) (x y)))) => 2
;   (lambda-depth '(lambda (x) (lambda (x) x))) => 2
;       ; even though the name x is reused, these are two nested
;       ; lambdas, so the nesting depth is 2
;
; No helper is needed here.  Write a single recursive function that
; follows the grammar.

(define lambda-depth
  (lambda (exp)
    (cond [(symbol? exp) 'nyi]
          [(eqv? 'lambda (car exp)) 'nyi]
          [else 'nyi])))

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
; scope at any point inside exp.
;
; When you move into the body of a lambda, that lambda's bound variable
; comes into scope.  But names can be reused: a lambda may bind a name
; that an enclosing lambda already binds.  The inner binding shadows
; the outer one, so inside the inner lambda the outer binding of that
; name is NOT in scope.  Thus the number of variables in scope at a
; point is the number of DISTINCT variable names bound by the lambdas
; that enclose that point, not the number of enclosing lambdas.
;
; Examples:
;   (max-vars '(lambda (x) x)) => 1
;   (max-vars '(lambda (x) (lambda (y) (x y)))) => 2
;   (max-vars '(lambda (x) (lambda (x) (x x)))) => 1
;       ; the inner x shadows the outer x, so only one variable name is
;       ; in scope inside the innermost body
;
; We'll do this one together

(define max-vars
  (lambda (exp)
    'nyi))


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
; which every USE of a bound variable is replaced by a number that says
; how to find that variable's value, instead of by the variable's name.
;
; Each use of a bound variable is replaced by a non-negative integer:
; the number of lambda scopes you must pass through (move outward)
; before you reach the lambda that binds that variable.  A variable
; bound by the immediately enclosing lambda is replaced by 0, one bound
; by the lambda just outside that is replaced by 1, and so on.  A use
; of a variable that is not bound by any enclosing lambda is FREE: it
; is left unchanged (it keeps its name).
;
; Everything else about the expression is unchanged.  Keep the
; (lambda (<identifier>) ...) binders exactly as they are, and preserve
; the overall structure.  The only leaves that change are bound
; variable uses, which become numbers.
;
; Examples:
;   (replace-vars-with-depth '(lambda (x) x))
;       => (lambda (x) 0)
;   (replace-vars-with-depth '(lambda (x) (lambda (y) x)))
;       => (lambda (x) (lambda (y) 1))
;       ; the use of x sits inside lambda y; we pass one scope (y's) to
;       ; reach the lambda that binds x, so x becomes 1
;   (replace-vars-with-depth '(lambda (x) y))
;       => (lambda (x) y)
;       ; y is free (not bound by lambda x), so its use keeps its name
;   (replace-vars-with-depth '(x (lambda (x) (y x))))
;       => (x (lambda (x) (y 0)))
;       ; x and y are free and keep their names; the use of x inside
;       ; the lambda is bound by it, so it becomes 0
;   (replace-vars-with-depth '(lambda (x) (lambda (x) (x x))))
;       => (lambda (x) (lambda (x) (0 0)))
;       ; both uses of x are bound by the inner lambda, so each is 0
;
; As in max-vars, use a helper that threads the bound variables of the
; enclosing lambdas, with the most recent binding at the front:
;
;   (replace-vars-with-depth-helper exp bound-vars)
;
; Hint: to find the number that replaces a variable use, use member.
; (member var bound-vars) returns the part of bound-vars that starts at
; the first occurrence of var so its length mins the original length will
; let you calculate the depth.  Or if that's confusing, you can use
; a named let.  If var is not in bound-vars, it is free: leave it
; unchanged.
; 

(define replace-vars-with-depth
  (lambda (exp)
    (replace-vars-with-depth-helper exp '())))

; hint
(define replace-vars-with-depth-helper
  (lambda (exp bound-vars)
    'nyi))

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
; This problem is just for fun if you get through with the other one.
;
; This is the reverse of Problem 3.  Given an expression in the
; translated form produced by replace-vars-with-depth, put the variable
; names back.  In the translated form, each leaf of the expression is
; either
;
;   * a number n, meaning "the variable bound n lambda scopes out from
;     here", or
;   * a symbol, meaning a free variable (its name is already there).
;
; A number leaf is replaced by the name of the variable bound n scopes
; out.  A symbol leaf is already a free variable's name, so it is left
; alone.  The (lambda (<identifier>) ...) binders and the overall
; structure are unchanged.
;
; If e is an ordinary LcExp, then
;   (replace-depth-with-vars (replace-vars-with-depth e))
; should give back e.
;
; Examples:
;   (replace-depth-with-vars '(lambda (x) 0))
;       => (lambda (x) x)
;   (replace-depth-with-vars '(lambda (x) (lambda (y) 1)))
;       => (lambda (x) (lambda (y) x))
;   (replace-depth-with-vars '(lambda (x) y))
;       => (lambda (x) y)
;       ; y is a free variable, so its name is already there
;   (replace-depth-with-vars '(x (lambda (x) (y 0))))
;       => (x (lambda (x) (y x)))
;
; As in the previous problems, use a helper that threads the bound
; variables of the enclosing lambdas, with the most recent binding at
; the front:
;
;   (replace-depth-with-vars-helper exp bound-vars)
;
; Hint: you may find the function list-ref useful.

(define replace-depth-with-vars
  (lambda (exp)
    (replace-depth-with-vars-helper exp '())))

; hint
(define replace-depth-with-vars-helper
  (lambda (exp bound-vars)
    'nyi))

(replace-depth-with-vars '(lambda (x) 0)) ; '(lambda (x) x)
(replace-depth-with-vars '(lambda (x) (0 0))) ; '(lambda (x) (x x))
(replace-depth-with-vars '(lambda (x) (lambda (y) 1))) ; '(lambda (x) (lambda (y) x))
(replace-depth-with-vars '(lambda (x) y)) ; '(lambda (x) y)
(replace-depth-with-vars '(x (lambda (x) (y 0)))) ; '(x (lambda (x) (y x)))
(replace-depth-with-vars '(lambda (x) (lambda (x) 0))) ; '(lambda (x) (lambda (x) x))
(replace-depth-with-vars '((lambda (x) (0 (lambda (y) (1 0)))) (lambda (z) 0))) ; '((lambda (x) (x (lambda (y) (x y)))) (lambda (z) z))
