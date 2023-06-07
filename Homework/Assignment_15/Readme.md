## Assignment 15

This is an individual assignment. You should continue working on interpreter milestones with your partner(s), but you should do this assignment yourself.  A15 does not depend on A14, and A16 does not depend on it, so you can work on this assignment at times when you are waiting on your partner to be able to get together to work on those assignments.

Problems 1 and 2 involve writing code in continuation-passing-style.  In Problem 1, you will represent continuations by Scheme procedures (as we did in the in-class live coding day 23 (winter, 2019-20).  In Problem 2, represent continuations by record structures, using define-datatype; this will be a warm-up for A18.


## Warm Up (Not for credit)

In a video I wrote intersection-cps.  For the non-null case we could call intersection-cps on the cdr first and place the call to memq-cps in its continuation, or we could call memq-cps first and place the call(s) to intersection-cps in its continuation.  In class I chose the first option.  It would be good practice for you to try the second option.


**For Problems 1 and 2, all calls to substantial procedures must be in tail position. If not, you will receive zero credit even if gradescope gives you all of the points. I suggest that you have a friend look over your code to see if they can spot any substantial calls that are not in tail position**


## Q1 (55 points)

Procedures to convert to continuation-passing style (CPS) using the “scheme procedure” representation of continuations.

*Important note:  apply-k is a substantial procedure that can only be called in tail position, make-k is not substantial.*

In this problem, you will write CPS procedures that use the “Scheme procedure” representation of the continuation ADT. To make the code as representation-independent as possible, you are required to call apply-k whenever you apply a continuation and call make-k whenever you make a continuation, even though this Scheme procedure representation would allow you to apply the continuation directly.  In the next problem, you will implement continuations as data structures, so the use of apply-k will be unavoidable.

*Don’t forget: any continuation to a CPS procedure must contain all of the information necessary to complete the entire original computation.*

In order to receive full credit for any part of this problem, these criteria must be met: 
- The procedure passes the grading program’s tests.
- Every application of a continuation must be done via the apply-k procedure, as in the class examples.  This will be checked by hand.
- Every continuation creation must be done via the make-k procedure applied to a procedure that can take one argument.
- A by-hand analysis by one of the graders shows that the required procedure and any non-primitive helper procedures that it calls actually are in CPS form.  I.e., answers are always passed to a continuation, and all calls to substantial procedures (including apply-continuation) are in tail position.

**Here are some clues that your program may not be in proper CPS form:**
1. The continuation that you pass into one of your recursive calls is the identity procedure:  (lambda (v) v).
2. You can trace procedures by using (require racket/trace) at the top of your code, and then using (trace procedure-name). If you trace all of your CPS procedures for one part of this problem and run it on non-trivial test cases, if you see the 
`> > >` 
indentation pattern when you run your test cases, that indicates tail-recursion is not in play here.  Note that there may be an occasional single level of indentation (or even two levels), but the maximum level should not depend on the size or complexity of the data that is passed to the procedure.

## (a) domain-cps and helpers (30 points)

Here is my solution to domain, an Assignment 3 exercise from a previous term:

    (define 1st car)

    (define set-of   ; removes duplicates to make a set
        (lambda (s)
            (cond [(null? s) '()]
	            [(member (car s) (cdr s))
	            (set-of (cdr s))]
	            [else (cons (car s)
		                (set-of (cdr s)))])))

    (define domain            ; finds the domain of a relation.
        (lambda (rel)
            (set-of (map 1st rel))))

You are to write domain-cps, which is a transformation-to-cps of the above code.  You will also need to write the following four cps procedures that domain-cps calls, and make sure that all calls to them are in tail position:

    (set-of-cps L k)
    (map-cps proc-cps L k)  ;  any procedure that map-cps takes as its first argument must be in CPS form.
    (1st-cps L k)                           ; A CPS version of 1st, so it can be used as an argument to map-cps.
    (member?-cps item L k)  ;  Is item an element of L?
    (set?-cps obj k)        ;  Is obj a set?                

    > (domain-cps '((1 2) (3 4) (1 3) (2 7) (1 6) (4 3) (3 8))
                  (make-k (lambda (answer) (format "domain is ~a" answer))))
    "domain is (2 1 4 3)"

## (b) make-cps (10 points)

Sometimes we may want to use a non-CPS procedure in a context where a CPS procedure is expected.  This is akin to the adapter pattern (http://en.wikipedia.org/wiki/Adapter_pattern) but applied to procedures instead of classes.  Write an adapter procedure called make-cps that takes a one-argument non-cps procedure and produces a corresponding two-argument procedure that can be called in a CPS context.  We will only apply make-cps to Scheme’s built-in procedures and other non-recursive procedures. (I.e. you are not allowed to apply make-cps to any recursive procedures that you write.)  This procedure may be helpful in a subsequent part of this problem.

Examples: 

    > (let ([car-cps (make-cps car)])
        (car-cps '(1 2 3) (make-k list)))
    (1)
    > (let ([count 0])
        (andmap-cps
         (make-cps (lambda (x)
	      	            (set! count (+ 1 count))
		                (positive? x)))
        '(4 3 9 0 1)
        (make-k (lambda (v) (list v count)))))
    (#f 4)

## (c) andmap-cps (15 points)

One of my tests for make-cps calls andmap-cps, and vice-versa.  
I used tests like that for the grading program also.  Thus you won't get full credit for either until you have written both.

**Form**: (andmap-cps pred-cps list continuation), where pred-cps is a cps version of a predicate.  Your andmap-cps must short-circuit.  

Examples: 

    > (andmap-cps (make-cps number?) '(2 3 4 5) (make-k list))
    (#t)
    > (andmap-cps (make-cps number?) '(2 3 a 5) (make-k list))
    (#f)
    > (andmap-cps (lambda (L k) (member?-cps 'a L k)) '((b a) (c b a)) (make-k list))
    (#t)
    > (andmap-cps (lambda (L k) (member?-cps 'a L k)) '((b a) (c b)) (make-k not))
    #t
    > (let* ([count 0]  ; check for short-circuit
             [check-and-increment-cps
               (lambda (x k)
                 (set! count (+ 1 count))
                (apply-k (number? x)))])
        (andmap-cps check-and-increment-cps
                    '(3 4 5 #f #t)
                    (make-k (lambda (v)
                              (cons count v)))))
    (4 . #f)

## (d) cps-snlist-recur (not required)

*This is a great problem.  But when I added  the “continuation as datatype” problem in Winter 2019-20,   I thought I should  keep the workload down by removing a problem.  I left the description here in case you want extra practice, but this problem is not required.*

cps-snlist-recur is not itself a CPS procedure, but it expects all of its arguments that are procedures to be cps procedures.  It produces a cps-procedure that does the snlist-recur recursion pattern.

You may start with my definition of sn-list-recur: 

    (define snlist-recur
        (lambda (seed item-proc list-proc)
            (letrec ([helper
                    (lambda (ls)
                        (if (null? ls)
                            seed
                            (let ([c (car ls)])
                                (if (or (pair? c) (null? c))
                                (list-proc (helper c) (helper (cdr ls)))
                                (item-proc c (helper (cdr ls)))))))])
            helper)))


Or with your own definition. For example, the solution might begin like this: 

    (define cps-snlist-recur
        (lambda (base-value item-proc-cps list-proc-cps)
            (letrec
                ([helper (lambda (ls k)
                        ; you fill in the details.
                ]))))

You may need to create cps versions of some "primitive" CPS procedures, for use with cps-snlist-recur.  For example:

    (define +-cps
        (lambda (a b k)
            (apply-k k (+ a b))))

You should only do this sort of thing with primitive procedures that are inherently non-recursive.  If you need a cps-version of a recursive procedure (such as length or append), you should do the recursion yourself in cps.

**How to use cps-snlist-recur to define a recursive function**:

    (define sn-list-sum-cps
        (cps-snlist-recur 0 +-cps +-cps))

Example of its use:

    > (sn-list-sum-cps '((1 (2 3 (()) 4) 5)) 
                    (make-k (lambda (x) (format "answer is ~s" x))))
    "answer is 15"

You are to define cps-snlist-recur, and then use it to define the following procedures (based on the similarly-named procedures from assignment 9).  Each of those takes an extra argument, which is a continuation.  As in the sn-list-recur assignment, all recursion in these procedures must come from cps-sn-list-recur, not from directly recursive calls in your code for the three procedures. 

    sn-list-reverse-cps
    sn-list-occur-cps
    sn-list-depth-cps

## Q2 (30 points)

CPS with data structures continuations.
You will want to refer to the live-in-class code (Winter 2020-21 it was day 24) on programming in CPS with ata Structures continuations.

You will need to expand the provided continuation datatype, beyond the init-k and list-k variants.  For this part, name your continuation-application procedure apply-k-ds so that it will not interfere with your apply-k procedure from the previous problem.

*Important note:  apply-k-ds is a substantial procedure that can only be called in tail position. The constructors for the various continuation variants are not substantial.*

(a) Here is my solution to the free-vars problem from A10, along with some supporting procedures:

    ; This is my solution to the free-vars problem from A10.
    ; It was for the original lambda-calculus expressions where lambdas
    ; have only one parameter and one body, and applications have only one operand.

    (define 1st car)
    (define 2nd cadr)
    (define 3rd caddr)

    ; This procedure is not needed for the given solution because memq is built-in.
    ; But you are required to call it from the CPS version of union.
    (define memq-cps
        (lambda (sym ls k)
            (cond [(null? ls)          
	             (apply-k-ds k #f)]
	            [(eq? (car ls) sym)
	             (apply-k-ds k #t)]
	            [else (memq-cps sym (cdr ls) k)])))

    (define union ; s1 and s2 are sets of symbols.
        (lambda (s1 s2)
            (let loop ([s1 s1])
                (cond [(null? s1) s2]
	                [(memq (car s1) s2) (loop (cdr s1))]
	                [else (cons (car s1) (loop (cdr s1)))]))))

    (define remove ; removes the first occurrence of sym from los.
        (lambda (sym los)
            (cond [(null? los) '()]
	            [(eq? sym (car los)) (cdr los)]
	            [else (cons (car los) (remove sym (cdr los)))])))
 
    (define free-vars ; convert to CPS.  You should first convert 
        (lambda (exp)   ; union and remove.
            (cond [(symbol? exp) (list exp)]
	            [(eq? (1st exp) 'lambda)       
	            (remove (car (2nd exp)) 
		            (free-vars (3rd exp)))]      
	            [else (union (free-vars (1st exp)	       
                            (free-vars (2nd exp)))])))

Write and test CPS versions of these procedures (and use the CPS version of the (substantial)  memq from the in-class code).

You may find the exp? procedure from the in-class code to be helpful in your define-datatype code.

A few test cases:

    > (union-cps '(a c e g r) '(b a g d t) (init-k))
    ( c e r b a g d t)
    > (remove-cps 'a '(b c e a d a a ) (list-k))
    ((b c e d a a))
    > (remove-cps 'b '(b c e a d a a ) (list-k))
    ((c e a d a a))
    > (free-vars-cps '(a (b ((lambda (x) (c (d (lambda (y) ((x y) e))))) f)))
	    	      (init-k))
    (a b c d e f)

## Q3 (40 points, including 15 for answering a question) 

Memoize. In class we saw a memoized version of Fibonacci.  It stores all function values that it has previously calculated, so that it does not have to recompute them later.  We can write a general memoize function that takes any function f and returns a function that takes the same arguments and  returns the same thing as f but also caches all previously-computed values so it does not have to recompute them.

    > (define (fib n)
    (if (< n 2)
        1
        (+ (fib (- n 1))
	        (fib (- n 2)))))
    > (define fib-memo (memoize fib)) ; the actual interface you are to use for memoize is described below
    > (fib-memo 12)
    233

It is hard to tell from the above transcript that fib-memo is any different than fib.  But a test that includes timing info may be able to tell.

(25 points) You are to write the memoize function.  Of course it should pass the grading program tests, but it will also be checked by hand.  Think about what kind of test the grading program might use to determine whether it is likely that your function does indeed create a memoized version of the function that is passed to it.

In order to make the memoized, function more efficient, you should use a hash table to store the previously computed values. Racket’s  make-custom-hash  constructor requires a hash function and an equivalence test as arguments, so a call to memoize will look like (memoize f hash equiv?), where the hash function is appropriate for the list of arguments passed to f.  Some command that might help: (make-custom-hash equiv? hash), (dict-set! hashtable key value), (dict-has-key? hashtable key), (dict-ref hashtable key). Read more in Racket’s documentation.

(15 points) In addition, answer the following question (put your answer in comments at the very beginning of your 15.ss code).  Why is the time savings (compared to fib) for the above definition of fib-memo less dramatic than the time savings for the definition of fib-memo in the PowerPoint slides?  Note that in the past many students have given a naïve and/or incorrect answer to this question. Take a few minutes to think about it.

*Caution: Chez Scheme has a function, make-hash-table, which is similar to the standard Scheme make-hashtable.  You probably want to use make-hashtable.*













