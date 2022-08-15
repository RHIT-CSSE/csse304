
# Critical Class Materials

* Traditional introduction is later, we focus on scheme in this class
* Syllabus & SCHEDULE PAGE are the 2 things you should read carefully
* WATCH videos 1-5.  All of this class's materials assume you know
  those basics.


# Procedure and Syntax

One of the unique things about scheme is that it has a very regular
structure.

    (cool-procedure 1 2 3) ; equivalent to cool-procedure(1, 2, 3) in Python or Java
    
But this means that things that are actually *syntax* might look like
they might be a procedure:

    (define say-hello (lambda () (display "hello")))
    
In python/java this would definitely *not* be a function call.

    def say_hello:
        print("hello")

But you can tell that easily because it looks different.  In scheme
you might wonder is there a procedure lambda, is there a procedure
define?

Answer: no, lambda & define are not procedures.

Almost always, you can tell if something is syntax by looking at its
arguments.  Before a procedure can be called, its arguments must be
evaluated.

It would not make sense to evaluate "say-hello" before the overall
define.  it would not make sense to evaluate (display "hello") before
the lambda.

Note that some really "core" stuff in scheme is nonetheless a
procedure.  For example plus which looks like this:

    (+ 1 2 3)
    
Obeys the normal rules of parameter evaluation, so is a procedure.

# Critical Review

    (cadr '(a b c)) => b
    
hint: always read the ds and as from right to left

    (cons 1 '(a b c)) => '(1 a b c)
    
This is actually a linked list (I'll draw it but not here in the
notes).  A single call to cons always produces 1 pair.  You *must*
fully have your head around the linked list representation that scheme
uses.

    (cons 1 2) => (1 . 2)
    
One cons produces 1 pair.  If the second element of a pair is not a
list or null, that pair is termed an improper list.  The "." here
signifies that we have an improper list.  If the "." was not there it
would be a list of 2 pairs (to make such a list, we'd need to call
cons twice).

    (eq? '(a b c) '(a b c)) => #f
    
Because these are two different lists in memory.  For this reason, 99%
of the time in this class you want equal?

    (let ([a 5][b 6]) (+ 3 a b)) => 14
    
Let is our way of defining local variables.  Note you can use square
brackets anywhere you can use ( ).  Often use to separate parts of
large syntax structures.

# Live Coding

    (define a '(3 4 5))

    (cdr a) => (4 5)
    (cddr a) => (5)
    (cdddr a) => () ; remember lists are terminated with the empty list
    (cddddr a) => ; incorrect list structure
    (cdddddr a) => ; cdddddr not bound (4 letters max built it)

How would you get b from

    (define f '((a (b (c))) d))
    
Try it yourself

## Max & Apply

Max and min are useful and work how you'd think

    (max 3 4 7 2) => 7
    (max 3) => 3
    
But this does not work

    (max a) => (3 4 5) is not a number
    
Instead use apply

    (apply max a)
    
Apply takes 2 parameters in this case.  1st is a function.  2nd is the
parameters you want to pass to that function.

Students often confuse apply with map, which we'll learn about later.
Apply really only has one purpose - passing a list of parameters to a
function that expects parameters not in a single list.

## Truthy

In scheme the rule is simple.  #f is the only falsey value.

    (if 0 1 2) => 1
    

## Void

Sometimes scheme functions appear to return nothing

    (if (> 1 100) 'wtf)
    
Actually it returns a value called void.  It becomes obvious if you do something like this:

    (list (if (> 1 100) 'wtf)) => (#<void>)
    
Things that shouldn't return anything useful like display return void
and the interpreter knows not to print the result.  You can generate
void yourself like this if you need to (void).

