# Racket Macros

This is an individual assignment. In it, you will create syntactic extensions of Racket. You will NOT use your interpreter to implement this code. For all problems, you must use "syntax-rules" and only "syntax-rules" to implement the macros. Any other means of implementing the macros will receive zero points.

## A Warning About Submitting

Macro code, when implemented incorrectly, has a tendency to crash the grading scripts.  Please do not submit macro code that crashes on gradescope, then email myself or the TAs asking to hand comment out individual testcases so you can get an individual point here or there.  The policy is if your macro crashes gradescope, you do not get partial credit for that macro. Hence, there is no advantage to submitting a crashing macro implementation - if your macro does not work, replace it with the original NYI version from the repo and submit a version that does not require hand grading.

## init

This macro defines the variable names passed to it and initializes them to zero.

    (begin (init a b c) (list a b c))  returns '(0 0 0)

## all-equal

Implement the operation all-equal which is a boolean operation that
returns true if all the expressions are equal to each other (in terms
of equal? equality).

    (all-equal (+ 1 2) 3 (- 103 100)) yields #t
    (all-equal 1 1 1 3) yields #f

all-equal uses "short circuiting" i.e. if two earlier values are
unequal, later expressions will not be evaluated.  For example:

    (all-equal 7 (display "I print") (display "I dont print"))

This short circuiting behavior means all-equal cannot be implemented
as a function - it must be a macro.

Note that the smallest all-equal expression is with 2
terms. (i.e. (all-equal 3) or (all-equal) have no defined meaning).

For full credit, each subexpression in the all equal should only be
evaluated once.  For example:

    (all-equal (display "a") (display "b") (display "c") (display "d"))

each letter should only print once. 

## begin-unless

Implement the operation begin-unless.  Here's how it looks:

    (let ((myvar #f))
        (begin-unless myvar
            (display "prints")
            (display "also prints")
            (set! myvar 17)
            (display "does not print"))) ; returns 17

begin-unless takes a single variable and then a list of bodies.
Before execuiting each body, it checks to see if the variable is true.
If the variable is a true value, begin-unless stops executing bodies
and the begin-unless expression ends.  If the variable is false, the
next body is executed.  The return result of the whole expression is
the value of the variable.


## Range cases

Range cases is a switch statement for a single numerical variable
where different ranges have different behavior.  Example:

    (define get-grade
      (lambda (grade)
        (range-cases grade
                     (< 65 "F")
                     (< 70 "D")
                     (< 80 "C")
                     (< 90 "B")
                     (else "A"))))


Or general form:

    (range-cases value-exp
                 (< cutoff-exp1 body-exp1)
                 (< cutoff-exp2 body-exp2)
                 ...
                 (else else-body-exp))

As with a cond only one body-exp is executed.  For simplictly only 1 body expression is permitted per case. 
The cutoffs can be assumed to be in increasing order. The value-exp is executed only once. The else expression must
always be present. Please notice that the "<" symbol and the "else" token are keywords. 

## For-loop

Implement a for loop as specified below. 

(for (< init-exp > : < test-exp > : < update-exps >) < body >)

Example:

    (let ([sum 0][i 0])
      (for ((begin (set! sum 0) (set! i 1)) : (< i 10) : (set! i (+ i 1)))
           (set! sum (+ i sum)))
     sum)
    
returns 45.
