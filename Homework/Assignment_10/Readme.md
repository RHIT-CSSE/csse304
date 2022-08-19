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
Your code only needs to process the simple lambda-calculus expressions
from the grammar from EoPL, not the extended expressions from problem
3 and 4 of this assignment.  By set, we mean a list of symbols with no
duplicates, as in previous assignments.  The order of the symbols in
the return value does not matter.

    > (free-vars   '((lambda (x) (x y)) (z (lambda (y) (z y)))))
    (y z)
    > (bound-vars '((lambda (x) (x y)) (z (lambda (y) (z z)))))
    (x)


#2 (40 points)

One of the repeated themes of this course is going to be that we can -
and often want to - translate code between different kinds of
languages.  Consider this modification of LcExp I call LcExprMultiP
(MultiP for multiple parameters) - notice the use of plus:

    <LcExprMultiP> ::= <identifier> |
                 (lambda (<identifier>+) <LcExpr>MultiP) |
                 ( <LcExprMultiP> <LcExprMultiP>+ )

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
to build nice to have features like let* without making things too
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
                 ( <IfExpr> <IfExpr>+ ) |
                 #f | #t |
                 (if <IfExpr> <IfExpr> <IfExpr>)

For those of you concerned with ambiguity edge cases, lets add the
stipulation that lambda, if, #f, #t are not valid identifiers in this
language.

Note that this if is a function-style if - it does not have short
circuiting.  Instead, it merely returns the value of either the 2nd or
3rd expression, depending on the value of the first.  The first
expression must evaluate to either #t or #f otherwise the program is
invalid.  This is sufficient in a language like LcExp but it wouldn't
be in a language like Scheme - feel free to come by office hours and
ask why if you're curious.

So you may have already guessed that IfExp is not more powerful than
LcExprMultiP but you may not have figured out how to do the
conversion.  The trick rests on choosing very special values for #f
and #t.

    #t => (lambda (thenval elseval) thenval)
    #f => (lambda (thenval elseval) elseval)
    (if x y z) => (lambda (boollambda thenval elseval) (boollambda thenval elseval))
    
Play with this in your head a bit and try to figure out why mapping
things in this particular way lets LcExprMultiP correctly implement
the if semantics.  It should feel pretty wild - here we have a
language with nothing but lambda (like literally no other constructs
but lambda) and we can build our own if statements.  I won't show you
how but hopefully can see how from there things like not and or are
very straightforward.


Ok now write a function (convert-ifs IfExp) that converts an
expression in IfExp to LcExprMultiP.


    > (convert-ifs '(lambda (input) (if input #f #t)))
    '(lambda (input) (input (lambda (thenval elseval) elseval) (lambda (thenval elseval) thenval)))


#3 (40 points) Expand occurs-free? and occurs-bound?  (written in class and in the textbook for basic lambda-calculus expressions) to incorporate the following language features into your code.  You can find the original occurs-free? and occurs-bound? from the textbook at

http://www.rose-hulman.edu/class/csse/csse304/202110/Resources/Code-from-Textbook/1.scm

a) Scheme lambda expressions (abstractions) may now have more than one (or zero) parameters, and Scheme procedure calls (applications) may have more than one (or zero) arguments.  Modify the formal definitions of occurs-free? and occurs-bound? to allow lambda expressions with any number of parameters and procedure calls with any number of arguments.  Then modify the procedures occurs-free? and occurs-bound? to include these new definitions. 

b) Extend the formal definitions of occurs-free? and occurs-bound? to include if expressions, and implement these in your code.  You are only required to handle “two-armed” if expressions that have both a "then" part and an "else" part.

c) Extend the formal definitions of occurs-free? and occurs-bound? to include Scheme let and let* expressions (you are not required to do “named let”), and implement these in your code.

d) Extend the formal definitions of occurs-free? and occurs-bound? to include Scheme set! expressions, and implement these in your code.  Note that set! does not bind any variables.

    (occurs-bound? 'x '(lambda (y) (set! x y)))  	      ==> #f
    (occurs-free?  'y '(lambda (x a b) y))       	==> #t
    (occurs-free? 'b '(let* ((y a) (x b)) ((x y) z))) 	==> #t
    (occurs-free? 'set! '(lambda (x) (set! x y)))	==> #f  ; set! is Scheme syntax, not a variable
    (occurs-bound? 'z '(lambda () (let* ((x a) (y x)) (if (y z) (lambda () x) (lambda () y))))) ==> #f


See the test cases for additional examples.

#4 (30 points).  lexical-address.  Write a procedure lexical-address that takes an expression like those from the previous problem (except that you are not required to do let* expressions for this problem) and returns a copy of the expression with every bound occurrence of a variable v replaced by a list (: d p).  The two numbers d and p are the lexical depth and position of that variable occurrence.  If the variable occurrence v is free, produce the following list instead: (: free xyz) To produce the symbols : and free, use the code  ': and 'free.

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

#4 (30 points). un-lexical-address.  Its input will be in the form of the output from lexical-address, as described in the previous problem. In the test-cases, we will evaluate 
   (un-lexical-address (lexical-address <some-expression>)) 
and test whether this returns something that is equal? to the original expression.  You cannot get any credit for this problem unless you also get a significant number of the points for lexical-address.  

[For example, someone who defines both lexical-address and un-lexical-address to be the identity procedure will trick the grading program into giving them full credit for un-lexical-address, but we will assign zero points as their actual grade for both problems after we look at the code by hand.]

Note: lexical-address is harder than un-lexical-address; if there are errors in your lexical-address code, they will most likely be discovered when you test un-lexical-address.



