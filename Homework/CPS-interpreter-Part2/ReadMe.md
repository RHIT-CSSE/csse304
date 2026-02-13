# Continuation Passing Interpreter - Part 2

This is a pair assignment.

The focus of this assignment are continuations and their use to
implement call/cc and an exit procedure. You will expand the language
of your interpreter. You must use datatyped continuations.

Continue to transform the CPS interpreter from part 1. You
do not have to modify the parser, syntax expander or
environment. We will test your code with the test cases, however, we will 
then check them by hand to verify that the code is indeed in CPS form. 

1. Add (to the parser and interpreter) a looping
mechanism not found in Racket: <tt>(while test-exp body1 body2 ...)</tt>  first
evaluates test-exp.  If the result is not #f, the bodies are evaluated
in order, and the test is repeated, just like a while loop in other
languages.  I do not care whether a value is returned, since while
should never be used in a context where a return value is expected.

2. Add <b>letrec</b> to your interpreter. Also add the primitive <tt>max</tt> to your interpreter.
It is required for one of our test cases.

3. Add <b>call/cc</b> to the interpreted language.
Please refer to the TSPL for more details. Recall that:
<tt>(call/cc receiver)</tt> obtains the current continuation and passes it to
receiver, which must be a procedure of one argument. As such we create
a binding of the continuation to the argument. Whether you implement
the continuation as a procedure or not does not matter.

4. Add <b>try-catch</b> to the interpreted language. (more to come)
</body>
</html>
