# Assignment 2

This is an individual assignment.  You can talk to anyone and get as much help as you need, but you should type in the code and do the debugging process, as well as the submission process.  You should never give or receive code for the individual assignments

*Restriction on Mutation continues.*  One of the main goals of the first few assignments is to introduce you to the functional style of programming, in which the values of variables are never modified.  Until further notice, you may not use set! or any other built-in procedure whose name ends in an exclamation point.  It will be best to not use any exclamation points at all in your code.  You will receive zero credit for a problem if any procedure that you write for that problem uses mutation or calls a procedure that mutates something.  	
	
Assume valid inputs.  As in assignment 1, you do not have to check for illegal arguments to your procedures.  Note that in the set? problem, any Scheme list is a valid input.

## Q1 (5 points) 

Write a procedure (sum-of-squares lon) that takes a (single-level) list of numbers, lon, and returns the sum of the squares of the numbers in lon.

sum-of-squares:  Listof(Number) -> Number

Examples:

    (sum-of-squares '(1 3 5 7)) -> 84
    (sum-of-squares '())        -> 0


## Q2 (8 points) 

Write the procedure (range m n) that returns the ordered list of integers starting at the integer m and increasing by one until just before the integer n is reached (do not include n in the resulting list).  This is similar to Python's range function.  If n is less than or equal to m, range returns the empty list. 
  
range:  Integer x Integer -> Listof(Integer)

Examples:

    (range 5 10) ->  (5 6 7 8 9)
    (range 5 6)  -> (5)
    (range 5 5)  -> ( )
    (range 5 3)  -> ( )

## Q3 (10 points)

In mathematics, we informally define a set to be a collection of items with no duplicates.  In Scheme, we could represent a set by a (single-level) list.  We say that a list is a set if and only if it contains no duplicates.  We say that two objects o1 and o2 are duplicates if (equal? o1 o2).  Write the predicate (my-set? list), that takes any list as an argument and determines whether it is a set.

Do not use the built in set when solving this problem.

my-set? : list -> Boolean

Examples:

    (my-set? '())                              -> #t         ; empty set
    (my-set? '(1 (2 3) (3 2) 5))               -> #t         ; (2 3) and (3 2) are not equal?
    (my-set? '(r o s e - h u l m a n))         -> #t
    (mt-set? '(c o m p u t e r s c i e n c e)) -> #f         ; duplicates

## Q4 (6 points) 

The union of two sets is the set of all items that occur in either or both sets (the order of the items in the list does not matter).

union:  Set x Set -> Set

Examples:

    (union '(a f e h t b) '(g c e a b)) -> (a f e h t b g c)  ; (or some permutation of it)
    (union '(2 3 4) '(1 a b 2))         -> (2 3 4 1 a b)      ; (or some permutation of it)

## Q5 (6 points)

Write a procedure (more-positives? lon) that return true if the list has more positive numbers than non-positive numbers.

hint: you might need to write a recursive helper function with a
different return type or different parameters.  This one is
straightforward to solve with tail recursion, but we won't require
that.

more-positives: Listof(Integer) -> Boolean

Examples:

    (more-positives '(1 2 -1)) -> #t
    (more-positives '(10 -2 -1)) -> #f
    (more-positives '(10 0)) -> #f

## Q6 (5 points)

For this one we have to talk about quote.  Most straightforwardly,
quote is an operation that turns stuff that looks like scheme code
into lists and symbols rather than attempting to execute it.

So for example:

    (length (quote (+ 7 13))) yields 3
    
' is an abbreviation for quote.  'whatever means the same thing as (quote whatever)

So if you execute (quote (+ 7 13)) in the interactive mode, it will
display the abbreviated version.

    '(+ 7 13)
    
But fundimentally, this is just (quote (+ 7 13)) under the hood. But
because the interactive interpreter mode just displays the
abbreviation it can be easy to get confused.  Consider this:

    > (car ''(+ 7 13))
    'quote
    
This might not initially make sense unless you look at the
non-abbreviated version

    > (car (quote (quote (+ 7 13))))
    'quote

Maybe even more confusing is this:

    > (list 1 2 3)
    '(1 2 3)

Where is the quote coming from here?  The thing to realize is that the
interactive mode always tries to display expressions that if executed
would yield the thing it is trying to display.  What is returned from
the list operation?  Well just the list 1 2 3 or if you like a pair
with 1 as its car.  But if scheme just displayed (1 2 3) and you
attempted to execute that, you'd get an error.  So it displays it
quoted.

This turns out to be the same thing with symbols 

    > (car '(+ 1 2))
    '+

'+ is the symbol plus.  But if we displayed that just as "+" in the
interactive mode, when you executed it you'd get a procedure not a
symbol.  So we display it as '+.

Now that that's out of the way, we can talk about the function we want
to write.  It's called add-quotes.  So 

    (add-quotes '(1 2 3) 2) yields '''(1 2 3)
    
Calling add quotes with a value of 2 adds two quotes to whatever is
passed in.  To understand how to make this work, lets just talk about
the meanings

1.  '(1 2 3) is just the ordinary list with 1 2 3.  The car of this
    list is 1.

2.  ''(1 2 3) is a 2 element list.  The first element is the symbol
    quote (which if displayed interactively would be 'quote).  The
    second element of the list is the ordinary list 1 2 3.  The car of
    this list is quote.  The cadr is 1.

3.  '''(1 2 3) is a 2 element list.  The car of this list is the symbol quote.
    The cadr of this list is the symbol quote.

Here's an additional hint: Evaluate this expression and see how it looks 

	(list (quote quote) (list (quote quote) (list 1 2 3)))
    
## Quines (1 point)

This is the first of a set of occasional 304 problems that I call
"optional".  They are not technically optional in that they are worth
a tiny amount of credit.  They are worth so little it is
inconsequential in the final accounting of your grade.  However, you
can't have a perfect score on A02 if you don't complete this quines
problem.  I hope that maybe that tiny sliver of credit will motivate
some of you to try this problem and problems like it on future
assignments.  Be warned though, they are generally a fair bit harder
than the rest of the problems in the set.

If you're feeling overwhelmed (as Rose students often are) just skip
these problems.  From a grade perspective, it's far more strategic to
just start on A03 if you have extra time.  The only reason you'd
continue is if you are curious and don't want to shy aware from
writing some weird code.

What is a quine?  Here's a scheme quine.  To see it work, execute it
in Racket's interactive mode.

    ((lambda (f) (printf "(~s '~s)" f f)) '(lambda (f) (printf "(~s '~s)" f f)))
    
Then take that result and execute it.

What’s going on?  This is a program that outputs its own code.  Quines
can exist in basically all programming languages, but Scheme is an
excellent one to start with.  I think the above quine should be
understandable to you, but let's work with a different one:

    ((lambda (f) (list f (list (quote quote) f))) (quote (lambda (f) (list f (list (quote quote) f)))))
    
If you execute this one interactively, it doesn't work quite right.
There are two mostly inconsequential issues:

1.  The output in interactive mode abbreviates quote as '

2.  The whole output is a scheme list.  But that makes interactive
    mode add a ' to the outside...which makes it unrunnable

To smooth of some of these rough edges, I've written a function called
eval-string.  It takes in a string of scheme and outputs a string
result of it executing (and it doesn't abbreviate quote).

    > (eval-string "((lambda (f) (list f (list (quote quote) f))) (quote (lambda (f) (list f (list (quote quote) f)))))")
    "((lambda (f) (list f (list (quote quote) f))) (quote (lambda (f) (list f (list (quote quote) f)))))"
    
There we go!

I've got some links below if you'd like to see some explanation of
quines and how they work.  Honestly, I'm not sure there's any
substitute for just staring at the code and playing with parts of it.
Everything in the above code should be familiar.  Take the first
lambda expression above and play with it by itself - then consider
what input we are passing it.

Once you've got it I'd like you to make your own quine, based on the
one above (the one with (quote quote), not the one with printf).  The
only restriction is, your quine must contain the number 304 in it.  I
chose a number than a symbol because numbers are a lot less annoying
with quoting.

To help you, I have another handy function

    > (is-quine-string? "((lambda (f) (list f (list (quote quote) f))) (quote (lambda (f) (list f (list (quote quote) f)))))")
    #t
    
That's how I'll test.  It displays some helpful details on failure BTW.

Once you have your string, make the string return from the function
get-304-quine and run the test cases.

Quine links:

https://learningdaily.dev/quines-self-replicating-programs-46dfd7445cfd
https://en.wikipedia.org/wiki/Quine_%28computing%29 

For this and any of the "optional" problems - you're more than welcome
to ask for help: from me in person, on the message boards etc.  The
TAs might be able to help you too - but bear in mind most of these are
new and TAs may find them challenging as well.
