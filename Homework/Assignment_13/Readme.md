## Assignment 13

**Deliverables** : Your code (submit to Gradescope).  

## Programming Problem (120 points)

This is perhaps the most important assignment of the term. The challenge is to understand the set-up of an interpreter, how all the components interact to read, parse, evaluate and return a result.

Feel free to start with the code that we studied in class.

This is an individual assignment.

I suggest that you thoroughly test each addition before adding the next one. Augmenting unparse whenever you augment parse is a good idea, to help you with debugging.

**Specification**:  Please implement the following functionality to your interpreter, i.e. parser and interpreter:

- Ensure you use the datatyped ribcage implementation that uses lists of symbols and vectors of values.
- Add the following literals to your interpreter:
    - numbers
    - Boolean constants #t, and #f 
    - quoted values, such as '( ) ,  '(a b c) , '(a b . (c)) , '#(2 5 4)
    - string literals, such as "abc" You do not need to add any string-manipulation procedures.
    - vectors You do not need to add any vector-manipulation procedures.
    - if  two-armed only: i.e., (if test-exp then-exp else-exp).  You’ll add one-armed if (i.e. when) later.  Most of the code is in the textbook, but you will have to adapt it to recognize and use Boolean and other literal values–– in addition to the numeric values.  In the book's interpreted language, the authors represent true and false by numbers. In Scheme (and thus in your interpreter), any non-false value should be treated as true.  The number 0 is a true value in Scheme (and in your interpreted language), but 0 is the false value in the textbook's language). 	

- Any primitive procedures that are used to evaluate the A13 test cases, including  +, -, *, /, add1, sub1, zero?,  not, = and < (and the other numeric comparison operators), and also cons, car, cdr, list, null?, assq, eq?, equal?, atom?, length,  list->vector, list?, pair?,  procedure?, vector->list, vector, make-vector, vector-ref, vector?, number?, symbol?, vector-set!,  display , newline to your interpreter.   Add the c**r and c***r procedures (where each "*" stands for an "a" or "d"). Note: You may use built-in Racket procedures in your implementation of most of the primitive procedures, as I do in the starting code that is provided for you.
-  Add lambda expressions of the form (lambda (var ...) body1 body2 ...). See the description of rep (short for "read-eval-print") below for a description of what to print if a closure or primitive procedure is part of the final value of an expression entered interactively in the interpreter.  Section 3.3 of EoPL may be helpful.
- Add begin to the parser and interpreter. 
- rep and eval-one-exp  (two alternative interfaces to your interpreter, described below)


## You are to provide two interfaces to your interpreter

**A.   A normal interactive interface (read-eval-print loop)  (rep)**

This interface will be used primarily for your interactive testing of your interpreter and to facilitate interaction if you bring the interpreter to me for help.  The user should load your code, type 
    (rep)
and start entering Scheme expressions.  Your read-eval-print loop should display a prompt that is different from the normal Scheme prompt.  It should read and evaluate an expression, print the value, and then prompt for the next expression.  If the value happens to be (or contain) a closure or prim-proc, your interpreter should not print the internal representation of the procedure, but instead it should print `<interpreter-procedure>`.  For debugging purposes, you might want to write a separate procedure called rep-debug that behaves like rep, except that it displays the internal representation of everything that it prints, including procedures.  Using trace on your eval-exp procedure can be a big help, but be prepared to wade through a lot of output!  

If the user types (exit) as an input expression to your interpreter, (some later version of) your interpreter should exit and simply return to the Scheme top-level; for now it is okay if your interpreter “crashes”.  What happens when the user enters illegal Scheme code or encounters a run-time error?   Ideally, the interpreter should print an error message and return to the "read" portion of the "read-eval-print" loop.  Think about how you might do that.  But we do not expect you to do it for this assignment. Again it can just crash your interpreter.  A sample transcript follows:

    > (rep)
    --> (+ 3 5)
    8
    --> (list 6 (lambda (x) x) 7)
    (6 <interpreter-procedure> 7)
    --> (cons 'a '(b c d))
    (a b c d)
    --> ((lambda (x)
          ((lambda (y)
                (+ x y))
            5))
        6)
    11  
    --> (((lambda (f)
           ((lambda (x) (f (lambda (y) ((x x) y))))
            (lambda (x) (f (lambda (y) ((x x) y))))))
        (lambda (g)
            (lambda (n)
                (if (zero? n)
                    1
                    (* n (g (- n 1)))))))
            6)
        720
    -->(exit)

**B. Single-procedure interface:  (eval-one-exp parsed-expression)**

In addition to the (rep) interactive interface, you must provide the procedure eval-one-exp.  The code below is intended to clarify this procedure’s function, not to make you rewrite your interpreter.  You will of course need to adapt it to your particular program.  It may be possible to arrange things so that your rep procedure can call eval-one-exp.

(define eval-one-exp 
 	   (lambda (exp) (eval-exp (parse-exp exp))))))

    >(eval-one-exp '(- (* 2 3) (* 6 3)))
    -12
    >

**Note that** eval-one-exp **does not have to be available to the user when running your interpreter interactively**.  It only has to be available from the normal Scheme prompt.  The interpreter test cases will call this procedure.  Testing of your rep loop will need to be done by hand.


# Lexical Depth (1 point)

This is worth very little credit, so it is for those teams looking for
additional fun.  My recommendation is that you save your existing
interpreter before you attempt this part, and use that as your
starting point in later milestones.  There's nothing about lexical
depth that makes it incompatible with future work, but it makes
debugging a bit harder sometimes and makes a little more work as you
add new constructs like named let etc.  Of course, if you want to be
hardcore and push lex depth through the whole project I won't stand in
your way.

You've seen lexical depth in earlier homeworks, but here's where we do
it for real.  The basic idea is that making variable lookups require a
O(number of variables in scope) linked list traversal is uhh...not
great.  In this new world, lookups will be a O(depth) linked list
traversal by precomputing where in an environment we expect a variable
to be.

## Lexical Depth Step 1

To get you warmed up, make two changes

1. Make your environments store values in vector form rather than as a
    list

2. Make your interpreter support variables in lexical-depth form we
   used in the earlier homeworks:

        (let ((x 10) (y 2))
            ((: free -) (: 0 0) (: 0 1)))
            
  This will require adding some new constructs to your parse tree.
  Evaluating these expressions should be comparatively easier due to
  the new vector form - but you'll need a new variant of apply-env to
  do it.
  
If you do this you will pass the test cases.  However, you are not
done (and you won't get credit).

## Lexical Depth Step 2

Go into your eval-exp and in the case for var-exps, change it to this:

      [var-exp (id)
               (error "we should never do this")]
               
You should never evaluate a var expression directly because var
expressions should be transformed into lexical depth expressions.
Here's how my top-level-eval looks:

    (define top-level-eval
        (lambda (parsed-code)
            (eval-exp (empty-env-record) (lexical-depth '() parsed-code))))
            
You can see that my lexical depth procedure takes a parsed abstract
syntax tree and returns a new abstract syntax tree where all var-exps
have been removed.  It also takes an additional parameter representing
the current scope - I'll let you decide on the details of that.

In theory, if you wanted to reuse your existing lexical-depth
solution, you could do the transformation earlier - transform the
input scheme code before parsing it.  I won't stop you from this
approach - it is uglier and more error prone (because lexical-depth is
doing its own parsing before your real parse-exp).  As a general rule,
we want all code transformations to occur on the abstract syntax tree
representation - but in the end it's up to you.

Once your have this working, all the A13 test cases should pass
despite the error in your var expression.  You can now even go further
and remove the old apply-env and remove the variable names from your
environments.  Woo!  Much more efficient!
