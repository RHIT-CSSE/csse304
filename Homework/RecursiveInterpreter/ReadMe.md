For this portion of the interpreter, please add the following functionality:
1. Ensure you have a separate gobal environment and that you call eval-expression with an empty environment.
2. Ensure your regular environment consists of lists of symbols and vectors of values. You may use the
   datatyped environment.
3. Ensure your global environment uses a hashtable.
4. Add a global define expression. Define adds variables and values to the global environment. If the define
   expression is issued more than once on the same variable, then the old value will be overwritten.
5. Add a set! expression. This expression changes the values of local and global variables. 
6. Add a letrec expression. This expression should 
   implement the let* like behavior of the Racket letrec expression.
7. The single variable lambda expression, e.g. (lambda arg-list <bodies>)
8. One armed if: (if <exp> <exp>)
9. reset-global-env: This is a regular Racket procedure (not something interpreted by your interpreter). It resets the global environment to what it was when you first started your interpreter. In other words, it removes all items added through "define".

This is an individual assignment.
