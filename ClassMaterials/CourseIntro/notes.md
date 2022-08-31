### Recall

    (define (f n) (+ 3 2))

is the same as

    (define f (lambda (n) (+ 3 n)))
    
The second form makes the lambda explicit but it is always there even
if you don't see it.

# A few scheme details from the slides

Mostly self explanatory

# Fact Example

Lets do the tracing in factorial-trace.rkt and see the difference.

fact-acc is tail-recursive.  Once fact-acc calls itself it does not
need to do anything to the result - i.e. the result of the recursive
call to fact-acc is overall return of fact-acc.

This is important because it means that the language can re-use the
stack frame; the stack frame of the original call is transformed into
the stack frame of the recursive call.

If the language is smart enough the recognize a tail-recursive call,
it makes what is conceptually a function call much more similar to a
goto in terms of cost.  This allows languages that really like
recursion to use recursion without too much overhead (if you build
the functions you care about in a tail-recursive way).

Later in the course, we will even talk about tail recursive functions
as if they are gotos.

# Coding in groups exercise

See inclass.rkt

We'll talk about the solutions at the end of class if we have time
