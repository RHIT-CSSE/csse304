## Assignment 11

This assignment has only four problems, but three of them are non-trivial.  Start early! 
A11a is an individual assignment.  

**You must work with your Interpreter project partner for A11b.  One partner should submit the assignment to the Gradescope server. Make sure to add your partner in Gradescope as you submit.**


No mutation is allowed in your code, except for problem 1c

## Q1 (30 points)

define-syntax exercises.  Your code may not involve mutation.  But the test cases, may include code that includes mutation

(a) Extend the definition of my-let produced in class to include the syntax for named let.  This should be translated into an equivalent letrec expression.  

Example: 

    (my-let fact ([n 5]) 
         (if (zero? n) 
            1 
            (* n (fact (- n 1)))))  -> 120

(b)  Suppose that or was not part of the Scheme language.  Show how we could add it by using define-syntax to define my-or, similar to my-and that we defined in class.  This may be a little bit trickier than my-and; the trouble comes if some of the expressions have side-effects; you want to make sure that no expression gets evaluated twice.  In general, your my-or should behave just like Scheme's or.  You may not use or in your expansion of my-or.  

Example:

        (begin (define a #t) 
            (define x (my-or #f 
                              (begin (set! a (not a)) a) 
                           #t 
                           (set! a (not a))))
             (list a x))
    (#f #t)

(c) Use define-syntax to define += , with behavior that is like += in other languages.  Of course += will do mutation.

Example: 

    (begin (define r 4) 
                    (define y (+ 6 (+= r 3))) 
                   (list r y))                    -> (7 13)

(d) Recall that (begin e1 … en) evaluates the expressions e1 … en in order, returning the value of the last expression. It is sometimes useful to have a mechanism for evaluating a number of expressions sequentially and returning the value of the first expression.  I call that syntax return-first.  Use define-syntax to define return-first.

Examples: 

    (define a 3) (begin a 
                    (set! a (+ 1 a)) 
                    a)                  -> 4
    (define a 3) (return-first a 
                              (set! a (+ 1 a)) 
                              a)           -> 3


A note on testing problem 1 offline.  Defining new syntax is very different than defining a procedure.  Every time you reload your code for problem 1 into Scheme, you must subsequently reload the test code file before running the tests.  Can you see why this is necessary?


## Q2 (10 points)

bintree-to-list.  EoPL Exercise 2.24, page 50.   This is a simple introduction to using cases and the bintree datatype (bintree definition is given on page 50).  See notes below on using define-datatype and bintree.


## Q3 (40 points)

max-interior.  EoPL Exercise 2.25, page 50.  The algorithm will be the same as in a previous assignment, but you must write it so that it expects its input to be an object of the bintree datatype.  As before, you may not use mutation.  As before, you may not traverse any subtree twice (such as by calling leaf-sum on each interior node).  You may not create an additional non-constant-size data structure that you then traverse to get the answer.  Think about how to return enough info from each recursive call to be able to compute the answer for the parent node without doing another traversal.

## Q4 (85 Points)

**HW11b is a with-your-team assignment.  You should not begin it until teams are established.**

The given code has a bare-bones parser for the lambda calculus plus numbers.  Your goal will be to expand parse/unparse to accommodante something much closer to a full subset of scheme.  You’ll want to do that step by step, testing each individual construct by hand.  I have a suggested order here.

- Modify the expression datatype, parse-exp, and unparse-exp so that they work for lambdas with multiple parameters and procedure applications with multiple parameters (including 0 parameters).
- Add basic let, name let, let*, and letrec.  Exactly how you want your abstract syntax trees to handle these multiple similar structures is up to you – the only requirement at this point is that you be able to unpase them correctly.  Many ways will work – just try to avoid code duplication and realize that you might want to change your mind later in the interepreter.
- Allow multiple bodies for lambda, let (including named let), let*, and letrec expressions. Also allow (lambda x lambda-body …) (note that the x is not in parentheses) or an improper list of arguments in a lambda expression, such as 
                (lambda (x y . z) …). 
- Add if expressions, with and without the "else" expression;
- Add set! expressions.  
- Expand lit-exp, which currently only supports number but will be the parsed form for numbers, strings, quoted lists, symbols, the two Boolean constants #t and #f, and any other expression that evaluates to itself.   Then make parse-exp recognize these literals. 
- Make parse-exp bulletproof. I.e., add error checking to your parse-exp procedure. It should "do the right thing" when given any Scheme data as its argument. Error messages should be as specific as possible (that will help you tremendously when you write your interpreter in a later assignment). Call the error procedure (same syntax as Chez Scheme's errorf, whose documentation can be found at http://www.scheme.com/csug8/system.html#./system:s2) ; the first argument that you give to error for this problem must be 'parse-exp. This will enable the grading program to process your error message properly, i.e. to recognize that the error is caught and the error message is generated by your program rather than by a built-in procedure. 
- Modify unparse-exp so it accepts any valid expression object produced by parse-exp, and returns the original concrete syntax expression that produced that parsed expression.   Suggestion:  when you modify or add a case to parse-exp, go ahead and make the corresponding change to unparse-exp and test both.  No credit for this part unless your unparsed-exp is representation-independent (using cases instead of car, cadr, etc.)

*The grading program will have two kinds of tests for this problem:*

1. Call parse-exp with an argument that is not a valid expression, then check to make sure that your program uses (error 'parse-exp …)to flag the input as an error.

2. Call (unparse-exp (parse-exp x)), where x is a valid expression, and check to see if your  code returns something that is equal? to the original expression. I will never directly compare the output of your parse-exp to any particular answer, since you have some leeway in what your parsed expressions look like. Note: It is possible to "pass" these tests by simply defining both procedures to be the identity procedure, so that you do not parse at all. This is clearly unacceptable.
