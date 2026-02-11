# Continuation Passing Interpreter - Part 1

This is a pair assignment.

The focus of this assignment are continuations and their use in the interpreter. You must use datatyped continuations.

You do not have to modify the parser, syntax expander and environment. We will test your code with the test cases available through the grading server, however, we will then check them by hand to verify that the code is indeed in CPS form. You need to modify your own interpreter. Notice that we only test items that should be in the interpreter proper, everything else ought to be syntax expanded. Finally, notice that while we make some code available, it is for quidance only. You may use it to modify your own code. You may not turn it in as your own code.

## Specifications

1. Add (), #t, and #f to the interpreted language. Also add string literals and vectors. You do not need to add any string-manipulation procedures, but it will be nice to at least be able to use strings for output messages.
2. Add quote to your interpreter.
3. Add several primitive procedures including +, -, *, /, add1, sub1, zero?, not, =, and < (and the other comparison operators). Also add the primitive procedures cons, car, cdr, list, null?, eq?, equal?, atom?, length, list->vector, list?, pair?, procedure?, vector->list, vector, make-vector, vector-ref, vector?, number?, symbol?, vector-set! to your interpreter. Add the c**r and c***r procedures where each "*" stands for an "a" or "d". Also add the following primitive procedures: map, apply, assq, assv, append.
4. Add if-expressions to the interpreter.

5. Add <b>set!</b> for local and global variables.

6. Add top-level <b>define</b>, including definitions of recursive procedures. 

7. Add an <b>break</b> procedure to the interpreted
language. Calling (break obj1 . . . ) at any point in the
user's code causes the pending call to eval-top-level to immediately
return a list that contains the values of the arguments to "break."
For testing purposes, this procedure behaves like "exit." In other words,
it terminates the computation, whether called in (rep) or by top-level-eval.
In this context, it leaves the (rep) loop.

For example,

> (eval-one-exp  '(+ 4 (- 7 (break 3 5))))
(3 5)

> (eval-one-exp '(+ 3 ((lambda (x) (break (list x (list x)))) 5)))
((5 (5)))

> (rep)

--> (+ 3 (break 5))

(5)

--> (+ 4 (break 5 (break 6 7)))

(6 7)

