# Assignment 15

This is a small individual CPS conversion assignment. 

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
