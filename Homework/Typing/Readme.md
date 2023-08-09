# Typing Assignment

In this assignment you'll implement type checking (i.e. determining
the type of an expression) for a very simple scheme like language with
explicit type declaration.

# The Language

This is a variation of the lambda calculus with some useful features
and types where required.

Note that you do not need to implement an interpreter for this
language as part of this assignment (moreover, doing so is incorrect
as you should not have to eval the expressions to determine their
types).  A parser for this language has been written for you.

## Literal Expressions

There are only 2 kinds of literals numbers (type num) and #t/#f (type
bool).

## Variable Expressions

Variable expressions work as normal in the lambda calculus.  Note that
you'll probably want a type environment similar to the variable
environments of your interpreter to track the types of variables.
Variables can be of any type.

## Lambda Expressions

    (lambda bool (x) 7)
    
A lambda expression in this language always has 1 parameter.  The type
name that follows lambda indicates the type of that parameter.

The type of a lambda expression is a procedure type.  A procedure type
includes the type of the parameter and the type of the return.  A
procedure can take and return any valid type including procedure
types.  The type of the above expression is "(bool -> num)".

A procedure's return type always matches the type of its body.  Note
that this is not explicitly declared (as it is in say Java) - instead
whatever the body evaluates to is presumed to be the intended return
type of the procedure (except with letrecs, described below).

## Application Expressions

    ((lambda bool (x) 7) #f)
    ((- 10) 3)
    
Application expressions always have 1 operator expression and 1
operand expression.  The operator expression must always be of a
procedure type.  The operand can be any type, but it must match the
parameter type of the operator's procedure type.  The type of the
application expression as a whole is the return type of the operator's
procedure.

There are 2 "built-in" procedures in this language.  iszero? which has
a type of (num -> bool).  And a curried style minus which has a type
(num -> (num -> num)).  You'll want to create your initial type
environment with these pre-set.


## if Expressions

    (if #t 1 2)

If expressions always have a test expression a then-expression and an
else expression.  The test expression must have a bool type.  The then
and else expressions are required to have the *same* type (but it can
be anything), which is the type of the overall if expression.

## letrec expression

    (letrec bool f (lambda num (n) (if (zero? n) #f (f ((- n ) 1)))) (f 3))

Letrec in this language can only have 1 recursive variable declared.
It also is required that this variable be initialized with a lambda
expression.  The type that follows letrec is the return type of
variable's procedure.  So in the example above, the type of f is
declared to be (num -> bool).

Letrec is recursive - i.e. f can be used in the body of its lambda and
when used it should have its declared type.

The type of the letrec variable's lambda body should match the
declared type expressed in the letrec.

The final expression of the letrec is the letrec body.  The declared
procedure can be used in the body.  The type of the letrec expression
is the type of the body.

# The goal

The main procedure is typecheck, which given a particular expression
returns its type.

    (typecheck 1) => 'num
    (typecheck '(lambda num (n) #t)) => '(num -> bool)
    (typecheck '((lambda num (n) (if (iszero? n) 8 9)) 1)) => 'num

Returning the type should not require evaluating the expression
i.e. we should be able to calculate that the final example above
returns a num without having an implementation of iszero?.
Calculating the type should be less expensive than evaluating, because
there should be no need to do aribrary time things like evaluate a
recursive function multiple types.

# Given code

* datatypes for expressions and types (called expression and type)

* a parser that parses expressions into the expression datatype and a
  parser that parses type expressions.  Note that parsed expressions
  use the parsed version of the type (i.e. they contain (number-t) not
  'num).  The parsers will error if you pass various kinds of
  malformed expressions but the tests always pass parsable code (maybe
  with type errors).

* an type unparser for types that converse parsed type into the symbol
  representation e.g. (proc-t (number-t) (boolean-t)) becomes '(num ->
  bool).
  
* a procedure typecheck with starting code (you will need to modify
  it).  This is what the tests call.  Typecheck takes an unparsed
  expression and returns a symbol type representation indicating the
  expressions type.
  
* a procedure called typecheck-exp where 90% of the code you write
  will go.  This takes a parsed exprssion type (and will probably need
  some more parameters as you go) and returns a parsed type - much
  more suitable for recursive calling that invoking typecheck directly.
  
You are free to add your own functions/datatypes as you go.

# Type errors

The primary reasons we typecheck is to detect errors.  Hence your code
is required to detect various kinds of error.  When you discover an
error:

    (raise 'symbol-indicatiung-the-kind-of-error)

Raise will terminate everything - there's no need to worry about what
will be returned after raise evaluates.

Here's the various kinds of errors the test cases test for:

| symbol to raise  | description of error                                                                            |
|------------------|-------------------------------------------------------------------------------------------------|
| unbound-var      | a variable is used in a context where it is not bound                                           |
| bad-procedure    | an application is attempted on something that is not a procedure type                           |
| bad-parameter    | an application is attempted but the given parameter does not match the procedure's stated type  |
| bad-if-test      | an if whos test expression is not a bool type                                                   |
| bad-if-branches  | an if whos then and else expressions do not have the same type                                  |
| bad-letrec-types | a letrec variable whos declared return type does match the type of its lambda expression's body |

Look for expect-error in the testcases to see examples of what should cause these errors.

# That's it!

Use the given testcases to exercise your typecheck.
