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

## my-or

 Suppose that or was not part of the Scheme language. Show how we
 could add it by using define-syntax to define my-or, similar to
 my-and that we defined in class. This may be a little bit trickier
 than my-and; the trouble comes if some of the expressions have
 side-effects; you want to make sure that no expression gets evaluated
 twice. In general, your my-or should behave just like Scheme's
 or. You may not use or in your expansion of my-or.

Example:

    (begin (define a #t) 
        (define x (my-or #f 
                          (begin (set! a (not a)) a) 
                       #t 
                       (set! a (not a))))
         (list a x))
    > (#f #t)

One thing you do not have to worry about is variable capture should
you introduce a let - scheme's namespacing will solve your problem.

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

## Destructuring Let

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

* This let only does one assignment, rather than a list - although
  that single assignment can do many mappings.  Allowing vars value
  pairs just further muddies things though, so I'm restricting it to
  just one.

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
  

* These are a valid:

        (let-destruct x 3 (+ x 1))
        (let-destruct x '(1 2) (length x))
        
  A variable by itself is still a structure, and if a variable by
  itself is given a list value, it gets assigned into a normal list.

* This is valid too:

        (let-destruct () () 'foo)
        
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

Interestingly, this problem can not be solved using syntax case
templates (at least as far as I know).  Instead, handle the
transformation directly using syntax->datum and datum->syntax.

## Methods with Fields

Note that question is worth a very small amount of credit for its
difficultly.  I hope your will be interested enough to try it anyway.

Macros are great for utility features like let variants and ifs, but
their real power is that they let us write code that is really
different from standard Scheme.

Lets imagine I'd like to do some object oriented programming, but not
with complicated lambdas like last time.  This time I'm going to
declare new kinds of objects like this:

    (define-object point x y)
    
And the object itself will be represented by a regular list e.g. (1 2)
represents a point where x = 1 and y = 2.  We could add a constructor
syntax (e.g. new-point 1 2) but the tests wont bother and just use
lists directly as objects.

The magic happens when we define a new method:

    (define-method point point.getx ()
        (printf "calling getx for point ~s ~s" x y)
        x)
        
Which is called like this:

    (point.getx '(1 2)) ; yields 1
    
Methods in this system always expect the "object" passed as the first
parameter.  Then within the body of the method, the entries of the
list are mapped to the field names.  So the x that is seemly unmapped
in the point.getx definition is mapped because point is defined to
have an x and y.

Note that methods can have ordinary non field parameters too:

    (define-method point point.manhat_dist (ox oy)
        (+ (abs (- x ox)) (abs (- y oy))))
    
    (point.manhat_dist '(1 2) 0 0) ; dist to orgin - returns 3

More generally, define-method looks like this:

    (define-method object-type-name method-name (extra_params ...) bodies ...)

Note that although I have named point methods point.somename, that's
just to make it clear.  I could have called point.getx getx and then
it would be invoked using the ordinary global name getx.

Any solution to this problem will require the mapping between object
names and field names to be stored in a global expansion time data
structure.  Then define method must be turned into a regular define +
lambda that pulls out the various bits and then includes the given
body code.  I found it handy to use apply & some extra internal
lambdas for that latter part, but I think there are multiple
solutions.
