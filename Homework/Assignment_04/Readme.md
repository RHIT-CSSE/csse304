## Assignment 4

This is an individual assignment.  You can talk to anyone and get as much help as you need, but you should type in the code and do the debugging process, as well as the submission process.  You should never give or receive code for the individual assignments

*Restriction on Mutation continues.*  One of the main goals of the first few assignments is to introduce you to the functional style of programming, in which the values of variables are never modified.  Until further notice, you may not use set! or any other built-in procedure whose name ends in an exclamation point.  It will be best to not use any exclamation points at all in your code.  You will receive zero credit for a problem if any procedure that you write for that problem uses mutation or calls a procedure that mutates something.  

Assume valid inputs.  As in assignment 1, you do not have to check for illegal arguments to your procedures.

## Q1 (20 points)

I wanted to have you do a nice mutually recursive function to practice
letrec - sadly mutually recursive algorithms don't come up so often.
But they do work well to model state machines!

Consider this simplification of pop songs.  There's a few rules:

1.  The pop song must start with a verse
2.  Once started verses and refrains must alternate...except
3.  The song must end with the refrain played twice.
4.  Any number of guitar solos can occur at any time, except at the
    start and after the final 2 refrains at the end.  When a guitar
    solo occurs, it doesn't change the alternation between verses and
    refrains.  Solos can occur between the 2 ending refrains.
    
Write a procedure pop-song? which determines if something is a pop
song according to this algorithm.  Examples:

    '(verse refrain verse refrain refrain) => #t
    '(verse guitar-solo refrain refrain) => #t
    '(verse guitar-solo refrain guitar-solo refrain) => #t
    '(verse guitar-solo refrain verse guitar-solo guitar-solo refrain refrain) => #t
    
    '(verse verse refrain refrain) => #f ; not alternating
    '(guitar-solo verse refrain refrain) => #f ; cant start with solo
    '(verse refrain verse refrain) => #f ; does not end correctly
    '(verse refrain verse refrain refrain refrain) => #f ; does not end correctly

Now that we've got the idea, how can we use mutual recursion to model
this nicely?  In my solution, there are 3 states - the starting state,
the state we're in when we've just finished a verse, and the state
we're in when we've just finished a refrain.  Each of these states
becomes a recursive function (i.e. lambda) in my letrec that takes a
list as a parameter.  Each of these lambdas look at the car of the
list and then do one of 3 choices:

1.  Returns #f because the combination of symbol and state indicates a
    rule has been violated
2.  Determines which state ought to be next and call that state
    function on the cdr
3.  Realizes we're finished and returns true if there are no more
    symbols in the input
    
Give it a shot using letrec.

## Q2 (10 points)

A function that takes in a list of numbers and returns a list
where element 1 is unchanged, element 2 is sum of e1+e2, element
3 is e1+e2+e3 etc.

    (running-sum '(1 10 300)) -> (1 11 311)

This can be solved simply with the use of named let which I encourage
you to use (although there are other viable approaches too).

## Q3 (10 points)

Write a procedure (invert lst) , where lst is a list of 2-lists (lists
of length 2), returns a list with each 2 list reversed.

* Credit to the EoPL for this question and many of the small questions
  in these early problem sets.
  
Example:

    (invert '((a 1) (a 2) (1 b))) -> ((1 a) (2 a) (b 1))

## Q4 (20 points)

combine-consec takes a *sorted* list of integers and combines them
into a series of ranges.  It compresses sequences of consecutive
numbers into ranges - so for example the list (1 2 3 4) becomes ((1
4)) representing the single range 1-4.  However, when numbers are
missing then there must be multiple ranges - e.g. (1 2 3 6 7 8)
becomes ((1 3) (6 8)) representing 1-3,6-8.  If a number is by itself
(i.e. it is not consecutive with either its successor or predecessor)
it can be in a range by itself so (1 2 4 7) becomes ((1 2) (4 4) (7
7)).

I used a recursive helper procedure for this problem - a named let
would work too.

Examples:

    (combine-consec '(1 2 4 7 8 9)) -> ((1 2) (4 4) (7 9))
    











    









    
