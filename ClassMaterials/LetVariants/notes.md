# From last class

I ended up not having enough time to the in class coding tail recursion 
problems from last class, so I had the students do that work in the first 
10 minutes instead of insertion sort.

# Live coding

We'll start with live coding insertion sort (see the solution if you
are so inclined).

# let

Sometimes we use let to make our code clearer

Other times we are looking to save time but not calculating the same
function call twice

# Slides on let not being a core form

Be aware that because of the lambda translation, you cannot use
variables from the let within the other parts of the let.

    (let ((a 1)
          (b (+ a 1))) 
      (+ a b)) ; ERROR!
    
    ; ... because its equivalent to this
    ((lambda (a b) (+ a b)) 1 (+ a 1))
    
We do a translation like this on the board as part of the "more on
let" slide.

# Abe Lincoln Problem

For this problem we use the code in abe_lincoln.rkt

In Claude's version of this class, we stop using slides and henceforth
everything is live coding.

We have a way of doing recursion but it always relies on the global
state to make things happen.  This can lead to some unexpected
behavior.  Look at the code thru

     (f 1860)
     
 And understand why it fails.  We'd like to fix it like this:
 
    (define fact2
     (let ([fact-tail2 (lambda (n accum)
                        (if (zero? n)
                            accum
                            (fact-tail2 (- n 1) (* n accum))))])
       (lambda (n) (fact-tail2 n 1))))

But this does not work because let can not handle self referential stuff.

Letrec will do the job however:

    (define fact3 
      (letrec ([fact-tail3 
                (lambda (n prod)
                  (if (zero? n)
                      prod
                      (fact-tail3 (sub1 n) 
                             (* n prod))))])
        (lambda (n)  (fact-tail3 n 1))))

Here's another example of letrec:

    (define odd?
      (letrec ([odd? (lambda (n) 
    		   (if (zero? n) 
    		       #f 
    		       (even? (sub1 n))))]
               [even? (lambda (n) 
                         (if (zero? n) 
                             #t 
                             (odd? (sub1 n))))])
        (lambda (n) ; NOTE this could be rewritten as just odd?
          (odd? n))))

### Trace lambda

Very useful for non-global tracing

    (require racket/trace)
    
    
    (let (my-local-func (trace-lambda (some vars) code))
    
Acts exactly like lambda, but when it runs it also prints

# Named Let

    (define fact4
      (lambda (n)
        (let fact-tail4 ([x n] [prod 1])
          (if (zero? x)
    	  prod
    	  (fact-tail4 (sub1 x) (* prod x))))))

Which is equivalent to

    (define fact5
      (lambda (n)
        (letrec ([fact-tail5
                  (lambda (x prod)
    		(if (zero? x)
                        prod
                        (fact-tail5 (sub1 x) 
                                       (* x prod))))])
           (fact-tail5 n 1))))
           
Note that this doesn't really act much like let at all, and does weird
stuff like implicitly create a lambda.

Basically named let is "implictly create a recursive function and run
it with these values".
