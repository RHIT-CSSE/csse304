## Assingment 14

This is a team assignment. Same submission rules/process as for A13.
Don’t forget to include teammate’s usernames on submission page.

This problem has a harder variant (see details at the bottom) but it
changes the approach for the earlier part significantly.  So if you
think you might want to attempt it, be sure to read the document in
its entirety before you start coding.

## Programming problem (100 points)

**Summary** : The major features you are to add to the interpreted language (in addition to those you added in A13) are:
- All of the kinds of arguments (proper list, single variable, improper list) to lambda expressions.
- One-armed if:  (if `<exp> <exp>`). This is similar to Racket’s when.
- Whatever additional primitive procedures are needed to handle the test cases I give you.  This requirement applies to subsequent interpreter assignments also.
- syntax-expand allows you (but not necessarily the user of your interpreter) to introduce new syntactic constructs without changing eval-exp. Write syntax-expand and use it to add some syntactic extensions (at least add begin, let*, and, or, cond). 

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

Add syntax-expand.  It isn't really necessary for the interpreter to treat let as a core expression, since it can be implemented as an application of lambda. After an expression has been parsed, pass the parsed expression to a new procedure (you must write it) called syntax-expand that replaces each parsed let expression in the abstract syntax tree by the equivalent application of a lambda expression (the idea is similar to let->application from a previous assignment, but this time it is recursive).  You should write syntax-expand in such a way that you can add other expansions later (hint: use cases). One benefit of using syntax-expand rather than interpreting let directly is that this and future versions of eval-exp need not have cases for let, let*, and, etc., so writing eval-exp should be simpler.  Don't forget that syntax-expand will need to expand subexpressions of an expression as well, if those subexpressions also contain syntactic extensions such as let.  You do not have to implement “named let” until assignment 16.

You will need to modify eval-one-exp (and perhaps rep as well) to include syntax-expand in the interpretation process. For example, you may have something like:

    (define eval-one-exp
 	   (lambda (exp) 
           (top-level-eval (syntax-expand (parse-exp exp)))))


Look at Flow.png

Note that it is acceptable, and perhaps more efficient, to "mix up" parsing and syntax expansion (having parse-exp call syntax-expand and vice-versa), but this can make debugging harder, so I do not recommend it.  First parse the code, then syntax expand, then evaluate.  This is a suggestion, not a requirement.

*Aside: Think about what the code for syntax-expand would be like if it were written as a pre-processor to the parser, rather than a post-processor as in the above code.  This will increase your appreciation for having the interpreter use abstract syntax trees instead of raw, unparsed expressions!*

Modify your parser and syntax-expand to allow some other syntactic forms, including begin, cond, and, or, let*.  The basic goal here is that your interpreter now should be able to interpret almost any non-recursive Scheme code (if it doesn't require define or set!) from the early part of the course.  

Your version of cond does not need to handle the clauses with the =>  or the clauses with only a test (described in Section 5.3 of TSPL); you only have to interpret clauses of the forms 
(test exp1 exp2 …) or (else exp1 exp2 …) as described in the same section.  These are the only kinds of cond clauses that I have used in class examples.

Add (to the parser and interpreter) a looping mechanism that is not found in Scheme: 
       (while test-exp body1 body2 ...)
first evaluates test-exp.  If the result is not #f, the bodies are evaluated in order, and the test is repeated, just like a while loop in other languages.  We do not care whether while returns a value, since while should never be used in a context where a return value is expected.   For now, you will most likely need to add while as a core form in your eval-exp procedure.

# Macros (1 point)

...that is the ability for the user to add new syntax to our
interpreted language.  Scheme can't be scheme without the ability to
be expanded right?  Diving into the workings of macros will be
rewarding.  Just take care - and make sure you have sufficient free
time before you attempt this.

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
    macros use.  Although macros can't call each other like functions,
    they will still be able to expand into code that then is further
    expanded by later macros.
    
Once you have this system though, all the syntax expansions from part
1 will be very easy to implement through this system.  So if you feel
ambitious, start here and if you finish part 1 might be easy.  If you
feel less ambitious, do part 1 and then see how late it is.  It's a
bit of a long road, and we need to start in an odd place...

## Quasiquoting

Before we get to the meat of it, there is an additional language
feature that will make this kind of macro much more understandable.
Consider this implementation of and, which doesn't use quasi-quoting

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

The ` is quasiquote.  The , is unquote.  The ,@ is unquote splicing.  So if you

Evaluate this '`(if ,(cadr stx) (and ,@(cddr stx)) #f) the structure
that comes out is this:

    (quasiquote (if (unquote (cadr stx)) (and (unquote-splicing (cddr stx))) #f))
    
So if your interpreter can interpret that, it'll handle the symbolic
version just as well.

To understand the meaning take a look at Racket's help: https://docs.racket-lang.org/guide/qq.html

Pay particular attention to unquote-splicing - very useful for macros.

You should implement quasiquoting in your interpreter.  You could
actually implement as a macro rather than a core feature - but take it
from me - that's painful.  I'll give you a few small hints:

1.  The work for quasiquote will happen in syntax-expand.  You
    shouldn't need to have entries for its stuff in your abstract
    syntax tree types.  Instead, when you come across it in your
    parser, expand it into literal expressions, applications of the
    list, cons, and append functions, and occasionally arbitrary code
    you just call syntax-expand on.
2.  Doing #1 will be much easier if you have an parse-quasiquote
    function which will sometimes be recursive.
3.  unquote-splicing might initially seem daunting.  Note this: it's
    not nearly so impossible when it occurs as the first element of
    the list. e.g. (\`(,@ (list 1 2) 3) seems easier than \`(0 ,@
    (list 1 2) 3) - but can the hard case be turned into the easy
    case?
4.  You may be tempted to save it for evaluation time and then call
    parse-exp from within eval-exp.  DO NOT DO THIS.  It will make
    things in the future much harder I assure you.
    
Don't try to do it all at once - test as you go!  I've built a few
unit tests for you too.
