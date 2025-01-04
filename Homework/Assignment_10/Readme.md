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

#2 (30 points).  lexical-address.

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

#3 (25 points). un-lexical-address.  Its input will be in the form of the output from lexical-address, as described in the previous problem. In the test-cases, we will evaluate 
   (un-lexical-address (lexical-address <some-expression>)) 
and test whether this returns something that is equal? to the original expression.  You cannot get any credit for this problem unless you also get a significant number of the points for lexical-address.  

[For example, someone who defines both lexical-address and un-lexical-address to be the identity procedure will trick the grading program into giving them full credit for un-lexical-address, but we will assign zero points as their actual grade for both problems after we look at the code by hand.]

Note: lexical-address is harder than un-lexical-address; if there are errors in your lexical-address code, they will most likely be discovered when you test un-lexical-address.



