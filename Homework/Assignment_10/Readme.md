# CSSE 304 Assignment 10

No input error-checking is required.  You may assume that all arguments have the correct form.
Abbreviations for the textbook: EoPL - Essentials of Programming Languages, 3rd Edition.
Section 1.2.4 is especially relevant to this assignment.
			
Mutation is not allowed for this assignment.

#1 (15 points) free-vars,  bound-vars.  LcExp is defined by this grammar, as we have discussed in class:

    <LcExpr> ::= <identifier> |
                 (lambda (<identifier>) <LcExpr>) |
                 ( <LcExpr> <LcExpr> )

We will take *identifier* in this case to be any alphabetic scheme
symbol.  You do not need to worry about the edge case of lambda being
an identifier (i.e. something like (lambda lambda) is technically a
valid LcExp but will confuse most student parsers).

Given a LcExp e, (free-vars e) returns the set of all variables that
occur free in e.  bound-vars is similar.  Write these procedures
directly; do not use occurs-free or occurs-bound in your definitions.
The order of the symbols in the return value does not matter.

    > (free-vars   '((lambda (x) (x y)) (z (lambda (y) (z y)))))
    (y z)
    > (bound-vars '((lambda (x) (x y)) (z (lambda (y) (z z)))))
    (x)


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
expression in IfExp to LcExprMultiP.


    > (convert-ifs '(lambda (input) (if input #f #t)))
    '(lambda (input) (input (lambda (thenval elseval) elseval) (lambda (thenval elseval) thenval)))


#4 (30 points).  lexical-address.

Lets further expand our language, getting it kinda close to regular scheme

    <SchemeliteExpr> ::= <identifier> |
                 (lambda (<identifier>+) <SchemeliteExp>) |
                 ( <SchemeliteExp> {<SchemeliteExp>}+ ) |
                 #f | #t |
                 (if <SchemeliteExp> <SchemeliteExp> <SchemeliteExp>) |
                 (let ({(<identifier <SchemeliteExp>)}+) <SchemeliteExp>)



Write a procedure lexical-address that takes an expression as above and returns a copy of the expression with every bound occurrence of a variable v replaced by a list (: d p).  The two numbers d and p are the lexical depth and position of that variable occurrence.  If the variable occurrence v is free, produce the following list instead: (: free xyz) To produce the symbols : and free, use the code  ': and 'free.

Hint:  It may be easiest to do this with a recursive helper procedure that keeps track of bound variables and their levels as it descends into various levels of the expression.  Note that this is very similar to the depth variable that we used in writing the notate-depth procedure during the live coding on Day 8.

Examples:
            
    (lexical-address '(lambda (a b c)
                        (if (eq? b c)
                            ((lambda (c)
                               (cons a c))
                             a)
                            b)))                ==>
    (lambda (a b c)
      (if ((: free eq?) (: 0 1) (: 0 2))
          ((lambda (c) ((: free cons) (: 1 0) (: 0 0)))
           (: 0 0))
          (: 0 1)))
    
    
    
    (lexical-address
     '((lambda (x y)
         (((lambda (z)
             (lambda (w y)
               (+ x z w y)))
           (list w x y z))
          (+ x y z)))
       (y z)))           ==>
    
    ((lambda (x y)
       (((lambda (z)
           (lambda (w y)
             ((: free +) (: 2 0) (: 1 0) (: 0 0) (: 0 1))))
         ((: free list) (: free w) (: 0 0) (: 0 1) (: free z)))
        ((: free +) (: 0 0) (: 0 1) (: free z))))
     ((: free y) (: free z)))
    
    (lexical-address 
     '(lambda (a b c) 
        (if (eq? b c) 
            ((lambda (c) (cons a c)) 
             a)           
            b)))      ==>
    
    (lambda (a b c) 
      (if ((: free eq?)(: 0 1) (: 0 2)) 
          ((lambda (c) ((: free cons) (: 1 0) (: 0 0))) 
           (: 0 0)) 
          (: 0 1)))
    
    
    (lexical-address
      '(let ([a 3] [b 4])
        (let ([a (+ b 2)] [c a])
          (+ a b c))))   ==>
    
    (let ((a 3) (b 4))
      (let ((a ((: free +) (: 0 1) 2)) 
            (c (: 0 0)))
        ((: free +) (: 0 0) (: 1 1) (: 0 1))))

#4 (25 points). un-lexical-address.  Its input will be in the form of the output from lexical-address, as described in the previous problem. In the test-cases, we will evaluate 
   (un-lexical-address (lexical-address <some-expression>)) 
and test whether this returns something that is equal? to the original expression.  You cannot get any credit for this problem unless you also get a significant number of the points for lexical-address.  

[For example, someone who defines both lexical-address and un-lexical-address to be the identity procedure will trick the grading program into giving them full credit for un-lexical-address, but we will assign zero points as their actual grade for both problems after we look at the code by hand.]

Note: lexical-address is harder than un-lexical-address; if there are errors in your lexical-address code, they will most likely be discovered when you test un-lexical-address.



