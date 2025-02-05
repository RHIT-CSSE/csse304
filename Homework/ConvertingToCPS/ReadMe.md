# Converting to data-typed continuation-passing style (CPS)

This is an TEAM assignment.

In order for a procedure definition to be in CPS, all calls to non-primitive procedures must be in tail position, and any call to a CPS procedure must produce the final answer for the computation that involves that call. That is, the procedure passed as a continuation to any CPS procedure must contain all of the information necessary to complete the computation.

In order to receive any credit for each part of this problem, several criteria must be met:

- The procedure must pass the grading program's tests.
- A by-hand analysis will be performed to determine whether your procedures are indeed in CPS form.
- You must use data-typed continuations.
- Your halt continuation "(halt-cont)" must simply return the value accessible to it, rather than pretty-print it..
- You must call your continuation datatype continuation.

1. (10 points) Write member?-cps. Form: (member?-cps item list continuation). It calculates the same thing as member?
Examples:

\> (member?-cps 1 '(3 2 4 1 5) (halt-cont))

#t

\> (member?-cps 7 '(3 2 4 1 5) (halt-cont))

#f

2. (10 points) set?-cps. Here is a solution:

        (define set?
          (lambda (ls)
            (cond [(null? ls) #t]
                  [(member? (car ls) (cdr ls)) #f]
                  [else (set? (cdr ls))])))

You are to write set?-cps, a CPS version of set? Since member? is not primitive, you must instead use member?-cps in your solution.

Examples:
 
\>  (set?-cps '(a b c b d) (halt-cont))

#f

\> (set?-cps '(a b c) (halt-cont))

#t

3. (10 points) intersection-cps. Here is a solution from an earlier assignment:
 
          (define intersection
            (lambda (los1 los2)
              (cond
                   [(null? los1) '()]
                   [(member? (car los1) los2)   
                      (cons (car los1) (intersection (cdr los1) los2))]        
                   [else (intersection (cdr los1) los2)]))) 
     
You are to write intersection-cps, which should of course use member?-cps.
Examples:

\> (intersection-cps '(a b c d e) '(f e t b c) (halt-cont))

(b c e)

\> (intersection-cps '(a b c d e) '(f g h i k) (halt-cont))

()

4. (5 points) make-cps. Sometimes, we may want to use a non-CPS procedure in a context where a CPS procedure is expected. Write an adapter procedure called make-cps that takes a one-argument non-cps (primitive) procedure and produces the corresponding two-argument procedure that can be called in a CPS context. This procedure may be helpful in a subsequent part of this exercise.
Example:

\> (let ([car-cps (make-cps car)])
     (car-cps '(1 2 3) (halt-cont)))

1

5. (10 points) Write andmap-cps. Form: (andmap-cps pred-cps list continuation), where pred-cps is a cps version of a predicate. Andmap-cps must short-circuit!
Examples:

\> (andmap-cps (make-cps number?) '(2 3 4 5) (halt-cont))

#t

\> (andmap-cps (make-cps number?) '(2 3 a 5) (halt-cont))

#f

\> (andmap-cps (lambda (L k) (member?-cps 'a L k)) '((b a) (c b a)) (halt-cont))

#t

\> (andmap-cps (lambda (L k) (member?-cps 'a L k)) '((b a) (c b)) (halt-cont))

#f

6. (20 points) Consider the following code.
 
        (define matrix?
           (lambda (m)
            (and (list? m)
                 (not (null? m))   
                 (not (null? (car m)))   
                 (andmap list? m)
                 (andmap (lambda (L) (= (length L) (length (car m))))   
                         (cdr m)))))
                    
You are to write matrix?-cps, which should use andmap-cps.

For this exercise, I ask you to assume that the length procedure is not primitive, so you must write length-cps. You may use make-cps to define length-cps. Examples:

\> (matrix?-cps '((1 2) (3 4)) (halt-cont))

#t

\> (matrix?-cps '((1 2) (3 4 5)) (halt-cont))

#f

\> (matrix?-cps '(()) (halt-cont))

#f

