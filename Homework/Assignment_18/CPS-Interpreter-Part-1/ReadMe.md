# Continuation Passing Interpreter - Part 1

This is a pair assignment.

The focus of this assignment are continuations and their use in the interpreter.

You do not have to modify the parser, syntax expander and environment. We will test your code with the test cases available through the grading server, however, we will then check them by hand to verify that the code is indeed in CPS form. You need to modify your own interpreter. Notice that we only test items that should be in the interpreter proper, everything else ought to be syntax expanded. Finally, notice that while we make some code available, it is for quidance only. You may use it to modify your own code. You may not turn it in as your own code.

## Specifications

1. (5 pts) Add (), #t, and #f to the interpreted language. Also add string literals and vectors. You do not need to add any string-manipulation procedures, but it will be nice to at least be able to use strings for output messages.
2. (5 pts) Add quote to your interpreter.
3. (15 pts) Add several primitive procedures including +, -, *, /, add1, sub1, zero?, not, =, and < (and the other comparison operators). Also add the primitive procedures cons, car, cdr, list, null?, eq?, equal?, atom?, length, list->vector, list?, pair?, procedure?, vector->list, vector, make-vector, vector-ref, vector?, number?, symbol?, vector-set! to your interpreter. Add the c**r and c***r procedures where each "*" stands for an "a" or "d". Also add the following primitive procedures: map, apply, assq, assv, append.
4. (5 pts) Add if-expressions to the interpreter.
5. (15 pts) Add lambda expressions of the form (lambda (var ...) body1 body2 ...) or (lambda var body1 body2 ...) or (lambda (var1 var2 ... . varn) body1 body2 ...)
6. (15 pts) Add application expressions that correspond to the lambda expressions of the prior item.
