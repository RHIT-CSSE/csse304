# A Warning About Submitting

So macro code, when implemented incorrectly, has a tendency to crash the grading scripts.  Please do not submit macro code that crashes on gradescope, then email myself or the TAs asking to hand comment out individual testcases so you can get an individual point here or there.  The policy is if your macro crashes gradescope, you do not get partial credit for that macro.  So there is no advantage to submitting a crashing macro implementation - if your macro does not work, replace it with the original NYI version from the repo and submit a version that does not require hand grading.

## Named My-Let

I've included a basic implementation of let in the starting code,
called my-let.  Modify my-let to also support named let syntax, for
example:

     (define fact 
       (lambda (n) 
         (my-let fact2 ((acc 1) (n n))
                 (if (zero? n) 
                     acc 
                     (fact2 (* n acc) (sub1 n))))))


Your solution should expand into a letrec, not the regular named let
syntax.

## null-let

Make a version of let called null-let where you don't have to specify
values for the variables you create.  Instead, each new variable
should be set to null.

    (null-let (a b c)
          (set! a 'not-null)
          (list a b c)) yields '(not-null () ())
          
null-let is allowed to expand into regular let-expressions.  You might
find it easier to expand it similarly to let*.  That is allowed even
though it is arguably needlessly inefficient.

## all-equal

Implement the operation all-equal which is a boolean operation that
returns true if all the expressions are equal to each other (in terms
of equal? equality).

    (all-equal (+ 1 2) 3 (- 103 100)) yields #t
    (all-equal 1 1 1 3) yields #f

all-equal uses "short circuiting" i.e. if two earlier values are
unequal, later expressions will not be evaluated.  For example:

    (all-equal 7 (display "I print") (display "I dont print"))

This short circuiting behavior means all-equal cannot be implemented
as a function - it must be a macro.

Note that the smallest all-equal expression is with 2
terms. (i.e. (all-equal 3) or (all-equal) have no defined meaning).

For full credit, each subexpression in the all equal should only be
evaluated once.  For example:

    (all-equal (display "a") (display "b") (display "c") (display "d"))

each letter should only print once. 

## begin-unless

Implement the operation begin-unless.  Here's how it looks:

    (let ((myvar #f))
        (begin-unless myvar
            (display "prints")
            (display "also prints")
            (set! myvar 17)
            (display "does not print"))) ; returns 17

begin-unless takes a single variable and then a list of bodies.
Before execuiting each body, it checks to see if the variable is true.
If the variable is a true value, begin-unless stops executing bodies
and the begin-unless expression ends.  If the variable is false, the
next body is executed.  The return result of the whole expression is
the value of the variable.

begin-unless might seem like an odd operation and it is.  But it
actually lets us implment a crude type of return semantics.  Imagine a
little macro that would make (return 17) transform to (set! return-val
17).  That plus begin-unless would make it possible to return from
functions...kinda.  This has its problems and we'll find a much better
way to return once we add continuations to our toolbox.


## Range cases

Range cases is a switch statement for a single numerical variable
where different ranges have different behavior.  Example:

    (define get-grade
      (lambda (grade)
        (range-cases grade
                     (< 65 "F")
                     (< 70 "D")
                     (< 80 "C")
                     (< 90 "B")
                     (else "A"))))


Or general form:

    (range-cases value-exp
                 (< cutoff-exp1 body-exp1)
                 (< cutoff-exp2 body-exp2)
                 ...
                 (else else-body-exp))

As with a cond only one body-exp is executed.  For simplictly only 1
body expression is allowed per case.  The cutoffs can be assumed to be
in increasing order.  The value-exp is only executed once, with the
result being reused to compare against the various cutoffs.  The else
expression must always be present.

The "<" is a placeholder value (i.e. you can't change it to <= or >)
so is else.  Because of this, be sure to mark them as placeholders in
your syntax cases like this:

    (syntax-case stx (< else)

This means < and else in patterns only match the literal values "<"
and "else".

## ifelse

So this one is simple conceptually

(ifelse testexp thenexps else elseexps)

Example:

    (ifelse 
        (> (length mylist) 10)
        (display "the list is very long")
        (display "more than 10 elements)
        'biglist
        else
        (display "the list is small")
        'smalllist)

There can be any number of thenexps and elseexps BUT there is always at
least one of each.  else is a special keyword that separates thenexps
from elseexps.  It acts like an normal if with then statements and
else statements in begin blocks.

This problem can be solved with syntax-cases, BUT to do so requires
far more trickiness than the problem deserves.  Instead, use
syntax->datum to turn the input code into a list, transform it, and
then use datum->syntax to convert it back again.

## Destructuring Let (1 point)

This is another bonus question.  It requires no special macro stuff,
beyond what you've already learned but the recursion is a little less
straightforward.

Oftentimes in scheme we use complicated list structures to represent
something.  A circle for drawing might be represented like ((x y)
radius (red green blue)).  But getting those individual element out
can be really annoying (consider the expression you need to get the
blue value).  So what about a let that allows us to pull out of
structured lists:

    (let-destruct ((x y) radius (red green blue)) my-circ
              (printf "x ~s y ~s r ~s" x y radius))

The general structure is

    (let-destruct vars value bodies ...)
    
Where *vars* is not just a variable or list of variables but rather a
structure that indicates where we expect variables to in the
structured list *value*.

A few details:
            

* The usual form like this:

        (let-destruct (a b (c)) '(1 2 (3)) (+ a b c))
        
  Only works if the value matches the structure.  I.e. in this case it
  must be a 3 element list and the 3rd element must be a 1 element
  list.  If the value was '(1 2 3) it's an invalid let and ought to
  error.  To make your life easy, I'm not going to test you on invalid
  inputs and so your code can just assume value is right.  HOWEVER,
  the value does not have to be a quoted list like above.  These would
  be just as good:
  
        (let ((my-val '(1 2 (3))))
            (let-destruct (a b (c)) myval (+ a b c)))

        (let-destruct (a b (c)) (my-cool-funct 'foo 'bar) (+ a b c))
        
  ...as long as my-cool-funct returns the right kind of list when
  called.  Your generated code should generate cars and cdrs as
  appropriate to destructure the input assuming it is a value of the
  expected form.

* To simplify the problem, you don't have to worry about potential
  side effects of evaluating the value expression more than once
  E.g. how do ensure we don't call my-cool-funct (above) more than one
  time?  In my test cases, you can call it many times and it won't
  error.  This is something we would have to solve before we would
  really want to use let-destruct (easiest way is just a introduce a
  little helper define-syntax "procedure").

* Be a little careful with the syntax.  This is not legal:

        (let-destruct ([(a b) '(1 2)]
               [(c d) '(3 4)]) ; this c d line is not allowed
              bodies ...)
              
  even though that is arguably more consistent with other let forms.
  Only one pairing of var names to structure is allowed per
  let-destruct used, which makes parsing it easier.


* These are a valid:

        (let-destruct x 3 (+ x 1))
        (let-destruct x '(1 2) (length x))
        
  A variable by itself is still a structure, and if a variable by
  itself is given a list value, it gets assigned into a normal list.

* This is valid too:

        (let-destruct () '() 'foo)
        
  And that is a useful base case.

* Speaking of base cases, this problem can be solved with careful use
  of recursion via syntax-case.  Just be sure to put your cases in
  careful order.  A pattern like (let-destruct var val bodies ...)
  will match input like (let-destruct (a b) '(1 2) (cons a b)).  To
  only match var if it is a standalone variable and not a structure,
  put the list cases earlier in the case so by the time you get to
  that pattern you know it's a singleton.

* As always, look to the test cases for more examples.

* Recursion is your friend.  let-destructs mostly expand to other let
  destructs, except in a few cases.
  
  <details>     
      <summary> A more detailed hint for the really stuck </summary>
  
  In my solution, the initial breakdown of (let-destruct ((a b) c d) cool-var bodies)
  transforms into 2 let destructs.  The outer one is (let-destruct (a b) (car cool-var) ???).  
  </details>

