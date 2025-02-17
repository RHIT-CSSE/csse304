# Continuation Passing Interpreter - Part 2

This is a pair assignment.

The focus of this assignment are continuations and their use to
implement call/cc and an exit procedure. You will expand the language
of your interpreter. You must use datatyped continuations.

For convenience of testing Add <b>display</b> and <b>newline</b> as
primitive procedures in your interpreted language.  You may implement
them using the corresponding Racket procedures.  You only need to
implement the zero-argument version of newline and the one-argument
version of display.

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

2. Add <b>set!</b> for local and global variables.

3. Add top-level <b>define</b>, including definitions of recursive procedures. 

4. Add <b>letrec</b> to your interpreter. Also add the primitive <tt>max</tt> to your interpreter.
It is required for one of our test cases.

5. Add an <b>break</b> procedure to the interpreted
language. Calling (break obj1 . . . ) at any point in the
user's code causes the pending call to eval-top-level to immediately
return a list that contains the values of the arguments to "break."
It does not exit the read-eval-print-loop when the code is run
interactively.  It simply returns the list of its arguments to be
printed before the r-e-p loop prompts for the next value.

6. Add <b>call/cc</b> to the interpreted language.
Please refer to the TSPL for more details. Recall that:
<tt>(call/cc receiver)</tt> obtains the current continuation and passes it to
receiver, which must be a procedure of one argument. As such we create
a binding of the continuation to the argument. Whether you implement
the continuation as a procedure or not does not matter.


</ul>

<p>For example,

<pre>
> (eval-one-exp  '(+ 4 (- 7 (break 3 5))))
(3 5)

> (eval-one-exp '(+ 3 ((lambda (x) (break (list x (list x)))) 5)))
((5 (5)))

> (rep)

--> (+ 3 (break 5))

(5)

--> (+ 4 (break 5 (break 6 7)))

(6 7)


</pre>

</ul>
</body>
</html>
