# Assignment 15

This is a small individual CPS conversion assignment. 

For all three problems: all calls to the *substantial* procedures must be in tail
position.  Each problem below says which procedures those are.  Each problem's
tests end with a 5 point group that checks this, and the graders look at your
code by hand as well.

Three things to know about the code file:

* The CPS procedures are declared with `define-cps-procedure` instead of
  `define`.  It behaves exactly like `define`; it also keeps enough of the code
  for the tail position checks to see where the procedure is called.  Declare
  the procedures you write the same way, and leave `apply-k` declared that way.
* The unconverted versions of the procedures are commented out, so a recursive
  call in your conversion cannot reach them by accident: writing
  `(slist-subst-orig ...)` inside `slist-subst-cps` reports `slist-subst-orig`
  as unbound instead of quietly calling the original.  If you uncomment one it
  becomes callable again, and calls to it are invisible to the tail position
  checks, because it is not a procedure declared with `define-cps-procedure`.
* Tracing rebinds a procedure to a wrapper, and the tail position checks look
  procedures up by identity, so a traced procedure cannot be found.  Trace while
  you work out a case, but leave `(trace ...)` out of the file you run the tests
  on.

## Sum Numbers (10 points, plus 5 for the tail position checks)

sum-numbers takes a list that contains both numbers and symbols, and adds up the
numbers in it, ignoring the symbols:

    (sum-numbers '(1 a 2 b 3)) => 6

Here is the code to convert:

    (define sum-numbers
      (lambda (lst)
        (cond [(null? lst) 0]
              [(symbol? (car lst)) (sum-numbers (cdr lst))]
              [else (+ (car lst) (sum-numbers (cdr lst)))])))

Convert this code as written.  Do not rewrite it into a fully tail recursive
version first and convert that instead - a version that carries the running total
in an accumulator is a different procedure, and converting this one is the point
of the problem.  (Notice that the accumulator version would pass the tail
position checks below, because it has no non-tail recursive call left to convert,
so those checks cannot tell whether you converted the right function.  This
problem is checked by hand as well.)

Two things to notice about the code: the symbol case's recursive call is already
in tail position, so it passes the continuation along unchanged, while the number
case's is not, because the + still has to add (car lst) to its result.  One clause
of each kind, and one continuation flavor that has to remember the number.

Add the flavor (or flavors) this problem needs to the same continuation datatype
and the cases to the same apply-k.

## Sublist Subst (14 points)

So in this problem we're going considering a slist-subst
slist-subst takes an slist old value and new value.  It returns a
new slist with all instances of of the old value replaced with the
new value.

    (slist-subst '((a b) a) 'a 'q) => '((q b) q)

Here is my solution for this problem:

    (define slist-subst-orig
     (lambda (slist old new)
       (cond [(null? slist) '()]
             [(symbol? (car slist))
              (cons (if (eqv? (car slist) old) new (car slist))
                    (slist-subst-orig (cdr slist) old new))]
             [else (cons (slist-subst-orig (car slist) old new)
                         (slist-subst-orig (cdr slist) old new))])))

Convert this code to continuation passing style, using the
define-datatype continuation type provided in the code file (of course
you'll need to add your own cases).  Please convert the code as
written - don't build a new algorithm yourself that is easier to
convert.

In this problem sublist-subst-cps (and apply-k) is the only procedure
that should be considered "substantial" -
i.e. sublist-subst-cps/apply-k can only be called in tail position,
other functions can be called wherever.

Note that your code should never create the init-k continuation
yourself (except in test cases) or create another type that just
returns the parameter v.  That is usually a sign that there is a a
substantial function call not in tail position.

## Free Vars (31 points)

Here is my solution to the free-vars problem from A10, along with some supporting procedures:

    ; this one you don't have to convert
    (define union ; s1 and s2 are sets of symbols.
        (lambda (s1 s2)
            (let loop ([s1 s1])
                (cond [(null? s1) s2]
	                [(memq (car s1) s2) (loop (cdr s1))]
	                [else (cons (car s1) (loop (cdr s1)))]))))

    ; convert this helper to cps
    (define remove ; removes the first occurrence of sym from los.
        (lambda (sym los)
            (cond [(null? los) '()]
	            [(eq? sym (car los)) (cdr los)]
	            [else (cons (car los) (remove sym (cdr los)))])))
 
    ; convert this helper to cps
    (define free-vars ; convert to CPS.  You should first convert remove
        (lambda (exp)
            (cond [(symbol? exp) (list exp)]
	            [(eq? (1st exp) 'lambda)       
	            (remove (car (2nd exp)) 
		            (free-vars (3rd exp)))]      
	            [else (union (free-vars (1st exp)	       
                            (free-vars (2nd exp)))])))

To do this, add additional flavors to the same continuation datatype you
used for the last problem, and have them use the same apply-k.  This
saves us the trouble of having to deal with having multiple
continuation types or apply k versions where is it very easy to
accidentally use the wrong one.

Only apply-k, free-vars-cps, and remove-cps need to be considered
substantial. Of course you should not use the non-cps version of
free-vars and remove and I encourage you not to put them in your code
as it makes accidentally calling them a very common bug.

A few examples:

    > (remove-cps 'a '(b c e a d a a ) (list-k))
    ((b c e d a a))
    > (remove-cps 'b '(b c e a d a a ) (list-k))
    ((c e a d a a))
    > (free-vars-cps '(a (b ((lambda (x) (c (d (lambda (y) ((x y) e))))) f)))
	    	      (init-k))
    (a b c d e f)

For this and all tail recursive problems, it can be useful to trace
your cps procedures and see if their indentation level increases (it
should not, if properly tail recursive).  If you do so, be sure to
trace helper functions like remove and apply-k too - calling them
should not increase the indent (if it seems like it ought to, ponder
it a bit and get help if the answer does not present itself).


Note that tracing isn't always 100% reliable because it only works if
the particular text case happens to drive the code down a
non-tail-recursive path.

## Tail Position Checks (5 points per problem)

Each problem's tests end with a tail position group of its own:

* `sum-numbers-tail-positions`, after the Problem 1 tests, checks
  `sum-numbers-cps` and `apply-k`, and is worth 5 points.
* `sublist-subst-tail-positions`, after the Problem 2 tests, checks
  `slist-subst-cps` and `apply-k`, and is worth 5 points.
* `free-vars-remove-tail-positions`, after the Problem 3 tests, checks
  `remove-cps`, `free-vars-cps` and `apply-k`, and is worth 5 points.

A group does automatically what used to be a by-hand check: for each of its
substantial procedures, it looks for calls to a substantial procedure from a
non-tail position.  Run one on its own with, say,
`(run-test sublist-subst-tail-positions)`.

On a correct conversion every check prints `Yours: ()`.  A failing check prints
the calls to move, for example

    Yours: (remove-cps)

Each name printed is a call whose result is used by the call it sits inside, so
that call needs its own continuation, exactly as step 3 does for a non-tail
recursive call.  Read a failure that way: it is not a technicality.  It means the
conversion of that procedure is not finished, and a conversion that is not in CPS
form is worth very little, however its answers happen to compare to the expected
ones.  Passing the ordinary tests is not the standard; never calling a
substantial procedure from a non-tail position is.  The two are independent --
answers can be right while a check fails, and a check can pass while answers are
wrong -- so both are scored.

`apply-k` belongs to every problem, since all three add cases to it, so its check
is in every group and a mistake in `apply-k` costs the points in every group.
Everywhere else the groups are separate: a mistake in one problem's procedure
costs only that problem's group, and a problem you have not started cannot cost
you the others.

The one thing that stops a check from finding a procedure is tracing it: `trace`
rebinds the name to a wrapper, and the check looks procedures up by identity.
That check then fails with a message saying the procedure was not declared with
`define-cps-procedure` or that its binding was replaced.  Comment out the
`(trace ...)` line and re-run.
