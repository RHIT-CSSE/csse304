## Assingment 14

This is a team assignment. Same submission rules/process as for A13.
Don’t forget to include teammate’s usernames on submission page.

This problem has a harder variant (see details at the bottom) but it
changes the approach for the earlier part significantly.  So if you
think you might want to attempt it, be sure to read the document in
its entirety before you start coding.

To make your interpreter work with the test cases add this to your file:

    (provide add-macro-interpreter)
    (define add-macro-interpreter (lambda x (error "nyi")))
    (provide quasiquote-enabled?)
    (define quasiquote-enabled?
             (lambda () (error "nyi"))) ; make this return 'yes if you're trying quasiquote

## Programming problem (80 points)

**Summary** : The major features you are to add to the interpreted language (in addition to those you added in A13) are:
- The single variable lambda expression (e.g. (lambda args-list blah ...))
- One-armed if:  (if `<exp> <exp>`). This is similar to Racket’s when.
- Whatever additional primitive procedures are needed to handle the test cases I give you.  This requirement applies to subsequent interpreter assignments also.
- syntax-expand allows you (but not necessarily the user of your interpreter) to introduce new syntactic constructs without changing eval-exp. Write syntax-expand and use it to add some syntactic extensions (at least add begin, let*, and, or, cond). You do not have to implement “named let” until assignment 16.

Note that syntax-expand (as described below) is a REQUIREMENT of this milestone, and more importantly of later steps including Exam 2.  Do not come up with some alterative design that does syntax expansion as a side effect of parsing, especially do not call syntax expand from eval-exp.  Syntax expand should be a function that takes abstract syntax trees from parse-exp, transforms them into other abstract syntax trees that only include "core" forms, and then that result is passed to eval exp.

I suggest that you thoroughly test each added language feature before adding the next one.  Augmenting unparse-exp whenever you augment parse-exp is a good idea, to help you with debugging.  But be aware that after you have syntax-expanded an expression, unparse-exp will no longer give you back the original, unexpanded expression.  However, unparse-exp  can still be very useful for debugging.

**A more detailed description of what you are to do:**

Add the variations of lambda that allow the arguments to be a single symbol or an improper list of variables.  I suggest that you have a separate expression variant for the “non-fixed-arguments” lambdas.

Add one-armed if.  You may find Racket’s void procedure useful in this implementation. Below is an example of how I’d like one-armed if to work:

    > (void)
	> (list (void))
	(#<void>)
    > (if #f 1)
	> (list (if #f 1))
	(#<void>)

Add the primitive procedures that are necessary to handle the assignment's test cases. Implementation of the  map and apply procedures may be slightly more interesting than most of the primitive procedures from the previous assignment. 

**Add syntax-expand.**

So here's a bit from my expand syntax.  Note that as your parse tree
may be slightly different from mine, this code might not work directly
for you but the basic idea should be very similar.

    (define syntax-expand
        (lambda (exp)
            (cases expression exp
                [var-exp (symbol) exp] ;; do nothing
                [lit-exp (literal) exp] ;; do nothing
                [and-exp (exps)
                        (cond [(null? exps) (lit-exp #t)]
                              [(null? (cdr exps)) (syntax-expand (car exps))]
                              [else (if-exp (syntax-expand (car exps))
                                            (syntax-expand (and-exp (cdr exps)))
                                            (lit-exp #f))])]
        ;; so many more cases go here

There are many constructs in our language that don't have to be
treated as a core expression and implemented in eval-exp.  "let" can be
implemented in terms of lambda, "and" can be implemented in terms of
nested-ifs etc.  But how can we avoid implementing them?

We'll write a procedure syntax-expand that replaces each non-core
expression in the abstract syntax tree by the equivalent in "core"
syntax (e.g. let becomes lambdas etc.).  One benefit of using
syntax-expand rather than interpreting let directly is that this and
future versions of eval-exp need not have cases for let, let*, and,
etc., so writing eval-exp should be simpler.

Look closely at my implementation of and-exp above and note two things:

1.  Syntax-expand will need to expand subexpressions of an expression
    as well, because those subexpressions may also contain syntactic
    extensions such as let.  So you can see I call syntax expand on
    the car of my expression list before I use it, ensuring that any
    further expansion that needs to be done there will happen.

2.  When we talked about scheme macros, it was fairly common to have
    expansions that expanded recusively (e.g. and expanded into and if
    plus an and expression).  Our syntax expand will only run one
    time, so we can't do it like Scheme's macro expand which re-runs
    macros until they can't expand further.  But if we want recursion
    it's not hard - just create the small and-exp we want and then
    explicitly call syntax expand on it:
    
        (syntax-expand (and-exp (cdr exps)))
        

You will need to modify eval-one-exp (and perhaps rep as well) to include syntax-expand in the interpretation process. For example, you may have something like:

    (define eval-one-exp
 	   (lambda (exp) 
           (top-level-eval (syntax-expand (parse-exp exp)))))


Look at Flow.png

More sophisticated expansions might "mix up" parsing and syntax expansion (having parse-exp call syntax-expand and vice-versa), but I am going to require that you do not use this approach.  First parse the code, then syntax expand, then evaluate. 

*Aside: Think about what the code for syntax-expand would be like if it were written as a pre-processor to the parser, rather than a post-processor as in the above code.  This will increase your appreciation for having the interpreter use abstract syntax trees instead of raw, unparsed expressions!*

Modify your parser and syntax-expand to allow some other syntactic forms, including begin, cond, and, or, let*.  The basic goal here is that your interpreter now should be able to interpret almost any non-recursive Scheme code (if it doesn't require define or set!) from the early part of the course.  

Your version of cond does not need to handle the clauses with the =>  or the clauses with only a test (described in Section 5.3 of TSPL); you only have to interpret clauses of the forms 
(test exp1 exp2 …) or (else exp1 exp2 …) as described in the same section.  These are the only kinds of cond clauses that I have used in class examples.

# Macros (1 point)

Scheme can't be scheme without the ability to be expanded right?  So
instead of syntax expansion hard coded into a function like expand
syntax, we want syntax expansion as a feature we can provide to our
interepreter's users.  Of course, we can use this same mechanism to
implement let, and, and all the stuff that outherwise would be in Part 1.
Diving into the workings of macros will be rewarding; just take
care - and make sure you have sufficient free time before you attempt
this.

This optional assignment is tricky.  How tricky?  Let me put it this
way: if you do it, don't just take your 1 point.  Come by my (Buffalo)
office or show me after class.  I will reward you with a card that
says you are a cool person.  Note that you must actually interact with
me to get your card!

We won't implement the syntax system you're familiar with in Racket.
Racket Scheme's syntax expansion system is powerful and cool, but we
can get 90% of the power with a lot less.  Our macros are going to
instead be macros like in Scheme's predecessor LISP - a macro is a
function that takes scheme code (i.e. lists of symbols and numbers
unparsed) and returns scheme code.  So a macro call

    (my-macro a (b c) 3)
    
Invokes the macro function passing '(my-macro a (b c) 3) as the single
parameter.  Whatever that function returns is inserted into the code
replacing the original macro call.  In our interpreters, this will
happen at *parse time* i.e. the macro invocation will be discovered,
the function will be invoked, and the parse-exp will take the result
and parse it as if the macro result had always been then there.

This is going to mean that our macro functions will need to be parsed
and evaluated before anything else.  This can get very complicated
indeed, but I'm gonna keep it very simple:

1.  All macros will be required to be created before the first
    evaluation of "regular" code

2.  The content of each macro will be evaluated completely
    independently with no possibility of (say) creating helper
    functions that many macros call or shared variables that multiple
    macros use.
    
Once you have this system, all the syntax expansions from part 1 will
be very easy to implement through this system.  So if you feel
ambitious, start here and if you finish part 1 might be easy.  If you
feel less ambitious, do part 1 and then see how late it is.  It's a
bit of a long road, and we need to start in an odd place...

## Quasiquoting

Before we get to modifying our parser in a significant way, there is
an additional Scheme language feature that will make this kind of
macro much more understandable.  Consider this implementation of and,
using the raw form of the macro system I've described:

    (define-syntax-interpreter and
      (lambda (stx)
        (cond [(null? (cdr stx)) #t]
              [(null? (cddr stx)) (cadr stx)]
              [else
               (list 'if (cadr stx) (cons 'and (cddr stx)) #f)])))

The last line is hard to read.  It's building an if structure, but the
problem is that it has to be built manually with list and cons.  It'd
be nicer if we could use quote:

    '(if XXX (and YYYY ...) #f)
    
But of course XXX would just be the symbols XXX when it needs to be
(cadr stx).  But not the symbols (cadr stx) but the value of that
inserted into our mostly quoted list.

Quasiquote will let us do this:

    (define-syntax-interpreter and2
      (lambda (stx)
        (cond [(null? (cdr stx)) #t]
              [(null? (cddr stx)) (cadr stx)]
              [else
               `(if ,(cadr stx) (and ,@(cddr stx)) #f)])))

This won't be quite as hard as it seems because just like quote, these
symbols are embedded into scheme's interpretation at a very
fundamental level.

The \` is quasiquote.  The , is unquote.  The ,@ is unquote-splicing.
So if you evaluate this '\`(if ,(cadr stx) (and ,@(cddr stx)) #f) the structure
that comes out is this:

    (quasiquote (if (unquote (cadr stx)) (and (unquote-splicing (cddr stx))) #f))
    
So if your interpreter can interpret that, it'll handle the symbolic
version just as well.

To understand the meaning take a look at Racket's help: https://docs.racket-lang.org/guide/qq.html

Pay particular attention to unquote-splicing - very useful for macros.

You should implement quasiquoting in your interpreter.  You could
actually implement as a macro rather than a core feature - but take it
from me - that's painful.

Your implementation though, will actually be mostly a macroy approach.
The work for quasiquote will happen in parse-exp - don't add new
entries in your abstract syntax tree type.  OR if you built syntax
expand in Part 1, you could implement it there (but you will have to
have ast type entries then).

When you come across quasiquote it in your parse-exp, expand it into
literal expressions, applications of the list, cons, and append
functions, and occasionally arbitrary code you just call syntax-expand
on.

I'll give you a few small hints:

1.  Doing this will be easier IMO if you have an parse-quasiquote
    function which will sometimes be recursive and sometimes mutually
    recursive with parse-exp.  It doesn't need any complicated
    stuff like named let looping or similar.
2.  unquote-splicing is the hardest to do.  First figure out the basic
    approach with quasiquote and unquote.
3.  To implement unquote-splicing note this: it's
    not nearly so annoying when it occurs as the first element of
    the list. e.g. (\`(,@ (list 1 2) 3) seems easier than \`(0 ,@
    (list 1 2) 3) - but can the hard case be turned into the easy
    case?
4.  You may be tempted to save it for evaluation time and then call
    parse-exp from within eval-exp.  DO NOT DO THIS.  It will make
    things in the future much harder I assure you.
    
Don't try to do it all at once - test as you go!  I've built a few
unit tests for you too.

## Making the macros (just for you)

The next thing to add is this feature, not for external users yet but
for yourself.  We want a scheme function called add-macro-interpreter.
Here's an example:

    (add-macro-interpreter 'varpair '(lambda (stx) `(list (quote ,(cadr stx)) ,(cadr stx))))
    
It takes two symbols as parameters.  The first is a name - the second
is (basically always) a lambda expression - but this second symbol is
code in your interpreted language not Racket Scheme.

Calling add-macro-interpreter modifies something in the global state
(which I give you permission to use and modify).  It should go ahead
and call eval-one-exp to precalculate the closure.

Now modify your parse-exp.  Before resolving something as an
application expression, check its symbol against the global state.  If
it matches a macro, use your stored closure to get the appropriate
transformed system.  Then parse the result.

Note that this means macros cannot be overriden by the local namespace
(e.g. I can't use let or similar to make "and" a procedure instead of
syntax).  If we cared, we could make this possible but it's not
required.

Now you should pass half of the add-macro-interpreter testcases, and
if you want you can safely go forward and implement Part 1.  I
personally found it helpful to build a little Racket scheme macro that
makes declaring interpreter macros easier:

    (define-syntax-rule (define-syntax-interpreter name code)
        (add-macro-interpreter (quote name) (quote code)))
        
## Making the macros (for everyone)

The only difficult aspect of this part is going to enforcing the
constraint that macro definitions occur before any other regular code.
Here's what our final stuff will look like:

    (begin
      (define-syntax varpair3 (lambda (stx) `(list (quote ,(cadr stx)) ,(cadr stx))))
      (define-syntax let3 (lambda (stx) `((lambda ,(map car (cadr stx)) ,@(cddr stx)) ,@(map cadr (cadr stx)))))
      (let3 ((y 4))
            (varpair3 y)))
            
The key is that ordinary code can only occur as the last entry in this
special begin list.  To do this, we're not going to call parse-exp or
eval-exp until we get to the last entry. Because macro processing
occurs in the parse-exp phase, calling it before that to figure out
what define-syntax evaluates into is hard-to-do-correctly at best.

If we really wanted to go whole-hog, we could have a 2 phase parse
with 2 different flavors of abstract syntax tree.  A first parse would
parse the begin define-syntax stuff, and then the final line would be
parsed as just a big blob of symbols (random-scheme-exp?).  We would
have an eval-phase1-exp.  The last line of that would run the real
parse-exp on the contents of random-scheme-exp and the eval-phase2-exp
on that.

This is kind overkill though.  We can parse and evaluate the "phase 1
stuff" in a single go - I implemented it all in top-level-eval (which
incidentally now takes code as input and calls the parser internally).

There are now 3 cases:

1.  A begin expression, which means top level eval recursively calls
    itself.  Real code is only allowed in the last expression of the
    outermost begin - you are not required to enforce that rule
    though, but if its violated your code is allowed to break.

2.  Handling a define-syntax expression will invoke add-macro-interpreter.

3.  Ordinary scheme code in its one allowed spot, indicating we can
    call parse and eval-exp

The only thing to be careful of is that now, your parser calls
eval-exp (or one of its subfunctions).  For reasons that will become
clear at the end of the class, your life will be much harder if
eval-exp calls the parser.  So the preferred design is that
top-level-eval handles all the define-syntax stuff, top-level-eval
calls itself sometimes, and then when everything else is done,
top-level-eval calls parse-exp, then eval-exp and henceforth parse-exp
is never called again.

That's it!  I hope you found this interesting.  You should be able to
pass all the tests and submit.




