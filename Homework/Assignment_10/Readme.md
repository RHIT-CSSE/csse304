# CSSE 304 Assignment 10

No input error-checking is required.  You may assume that all arguments have the correct form.
Abbreviations for the textbook: EoPL - Essentials of Programming Languages, 3rd Edition.
Section 1.2.4 is especially relevant to this assignment.
			
Mutation is not allowed for this assignment.

#1 (10 points) 

This question will use our definition of the lambda calculus.

     LcExp ::= <identifier> |
                 (lambda (<identifier>) LcExp) |
                 (LcExp LcExp)

We'll define "shadowing" as occuring when a lambda
expression uses a name that is already bound (or, more precisely
the name used in the lambda would be considered "bound" if it
occured as an identifier at that position in the expression).

For example:

    (lambda (y) (lambda (x) y)) ; no shadowing
    (lambda (x) (lambda (x) y)) ; x shadows existing x

the definition of x in the inner lambda "hides" or
"shadows" the other meaning of x.

In this case:

   ((lambda (x) y) (lambda (x) y))

No shadowning occurs because although x is used in two
places, in each case x would be free if it occured where
the lambdas bind x.  Put another way, no definition of x
occurs within the context of an existing definition of x.

To make our idea of shadowing formal.  A variable x can
be considered shadowed in an lc-exp iff:

A.  If lc-exp is a variable expression x is not shadowed
B.  If lc-exp is a abstraction expression (lambda (y) e')
    x is shadowed if:
    x is shadowed in e'
    OR y matches x and an expression (lambda (x) e'') occurs
       in some subexpression of e'
C.  If lc-exp is a application expression (e1 e2)
     x is shadowed if x is shadowed in e1
                   OR x is shadowed in e2

Write is-shadowed which determines if a variable var is shadowed
within an expression exp.

#2 (40 points)

One of the repeated themes of this course is going to be that we can -
and often want to - translate code between different kinds of
languages.  Consider this modification of LcExp I call LcExprMultiP
(MultiP for multiple parameters) - notice the use of {}+:

    <LcExprMultiP> ::= <identifier> |
                 (lambda ({<identifier>}+) <LcExpr>MultiP) |
                 ( <LcExprMultiP> {<LcExprMultiP>}+ )

Basically this is just the lambda calculus but with multi parameter
lambdas (e.g. (lambda (x y z) x) ) and calling (e.g. (myfunc p1 p2 p3)
).  Turns out this new feature doesn't really make the lambda calculus
more powerful as a programming language.  Anything we might want to do
with multiparamter functions, we could just use currying to accomplish
in LcExpr:

    (lambda (x y z) x) => (lambda (x) (lambda (y) (lambda (z) x)))
    (coolfun p1 p2 p3) => (((coolfun p1) p2) p3)

But not more powerful doesn't make our new language bad.  Actually
code in LcExprMultiP is way easier to understand.  And because its not
more powerful, we can write our code in LcExprMultiP and then easily
convert it to LcExp.  You'll do this a lot on the interpreter project
to build nice-to-have features like let* without making things too
complex.

What I'd like you to do in this problem is write a converter that
takes in LcExprMultiP and outputs the equivalent program in LcExp.  Or
almost.

Write a function *convert-multip-calls* that takes LcExprMultiP
program with calls of arbitrary size and converts it to an LcExpr
program that has the equivalent curried form.  However, this function
does not need to accept lambda expressions with more than one
parameter.

    > (convert-multip-calls '(coolfun p1 p2 p3))
    '(((coolfun p1) p2) p3)

Write a function *conver-multip-lambdas* that takes LcExprMultiP
program with lambdas of arbitrary parameters and converts it to a
LcExpr program that has the equivalent curried form.  However, this
function does not need to accept calls with more than one parameter.

    > (convert-multip-lambdas '(lambda (x y) x))
    '(lambda (x) (lambda (y) x))

From there, I think you'll be able to easily see how to write a
version that does both conversions at once.  But the code is a little
uglier so I'm not demanding you do that.

#3

Continuing with the idea of translating languages, let's consider an
extension to LcExprMultiP.  To avoid making a name that is even more
silly (LcExprMultopAndIfToo?), let's call this one IfExp:

    <IfExp> ::= <identifier> |
                 (lambda (<identifier>+) <IfExpr>) |
                 ( <IfExpr> {<IfExpr>}+ ) |
                 #f | #t |
                 (if <IfExpr> <IfExpr> <IfExpr>)

For those of you concerned with ambiguity edge cases, lets add the
stipulation that lambda, if, #f, #t are not valid identifiers in this
language.

This if is a function-style if - it does not have short circuiting.
Instead, it merely returns the value of either the 2nd or 3rd
expression, depending on the value of the first.  The first expression
must evaluate to either #t or #f otherwise the program is invalid.

So you may have already guessed that IfExp is not more powerful than
LcExprMultiP but you may not have figured out how to do the
conversion.  The trick rests on choosing very special values for #f
and #t.

    #t => (lambda (thenval elseval) thenval)
    #f => (lambda (thenval elseval) elseval)
    (if x y z) => (x y z)
    
Play with this in your head a bit and try to figure out why mapping
things in this particular way lets LcExprMultiP correctly implement
the if semantics.  It should feel pretty wild - here we have a
language with nothing but lambda (like literally no other constructs
but lambda) and we can build our own if statements.  I won't show you
how but hopefully can see how other boolean functions (e.g. and or)
are possible once if exists.


Ok now write a function (convert-ifs IfExp) that converts an
expression in IfExp to LcExprMultiP.  Note that we're specifically
*not* augmenting your solution from the previous step, your output
should have multi-parameter functions.


    > (convert-ifs '(lambda (input) (if input #f #t)))
    '(lambda (input) (input (lambda (thenval elseval) elseval) (lambda (thenval elseval) thenval)))


