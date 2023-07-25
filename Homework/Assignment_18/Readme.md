# Assignment 18

*You are not required to implement reference parameters or
lexical-address in A18.  You can (and should) start with your “basic”
interpreter from A17a.*

This assignment is adding an implementation of call/cc in your
interpreter.  The main difficulty of doing so will be to convert your
interpreter itself into CPS style without which call/cc can't be
implemented.  This term we've reduced the focus on CPS conversions in
the course - meaning an assignment that used to be a major "capstone"
is now still interesting topic but not critical to the learning
objectives.

For this reason, I've reduced the point value of this assignment
greatly.  If you're interpreter code is relatively clean and you feel
good about CPS, I think you will find this rewarding.  If not, I
wanted you to be able to skip this assignment without greatly harming
your score in the overall course.

## Instructions

Transform your interpreter to Continuation-Passing Style (CPS).  It
can be (and preferably should be) based on your A17 interpreter before
you added reference parameters and lexical-address.  The parser and
syntax expander do not need to be in CPS, unless they are called by
top-level-eval or something that it calls.

Which procedures need to be transformed to CPS?  Most or all procedures that 
    (a) are called (directly or indirectly) by eval-exp, and 
    (b) can also call (directly or indirectly) eval-exp
The bottom line is that your interpreter should correctly interpret call/cc and exit-list.  

We're requiring you represent your continuation as a define-datatype
type.  This is the only representation we've talked about in class -
so that should be what you are thinking anyway.  But if you remember
the old lambda representation we covered in previous terms - not
allowed for A18.

## Testing your CPS conversion

As you convert particular eval branches to CPS (e.g. literals, if
expressions, etc.) test your CPS conversion by invoking those features
in the eval print loop.  You'll want to verify the functionality step
by step before you even attempt call/cc code.

Once you've finished the conversion, I've included a suite of tests
from previous milestones (but obviously these tests are not worth many
points).  Do make sure your code passes these before you go on to the
call/cc tests.

## Adding Call/cc

Add call/cc to the interpreted language.  You only need to do the version we have discussed in class, where continuations always expect a single argument (in the presence of call-with-values and values, Scheme continuations sometimes expect multiple arguments or return multiple values, but you don't have to do this in your interpreter).  

**Obvious restriction**: You may not use Scheme's call/cc (or anything
that is built on top of Scheme’s call/cc) in your interpreter
implementation.

## One more little feature

Add an exit-list procedure to the interpreted language. It is not
quite the same as Chez Scheme's exit; it is more like (escaper list).
Calling (exit-list obj1 . . . ) at any point in the user's code causes
the pending call to eval-top-level to immediately return (as the final
result of the current evaluation) a list that contains the values of
the arguments to exit-list.  The call to exit-list does not exit the
read-eval-print-loop when the code is run interactively.  It simply
returns the list of its arguments, which will be printed before the
repl prompts for the next value.  You may not use Scheme’s exit or
call/cc procedures in the implementation of exit-list in your
interpreter.

For example:

    > (eval-one-exp '(+ 4 (- 7 (exit-list 3 5))))
    (3 5) 
    > (eval-one-exp '(+ 3 ((lambda (x) 
                            (exit-list (list x (list x)))) 5)))
    ((5 (5)))
    > (rep)
    --> (+ 3 (exit-list 5))
    (5)
    --> (+ 4 (exit-list 5 (exit-list 6 7)))                                                     
    (6 7)
    -->

## That's it!

Submit as normal
