For this portion of the interpreter, please add the following functionality:
1. Ensure you have a separate gobal environment and that you call eval-expression with an empty environment.
2. Ensure your regular environment consists of lists of symbols and vectors of values.
3. Ensure your global environment uses a hashtable.
4. Add a global define expression. Define adds variables and values to the global environment. If the define
   expression is issued more than once on the same variable, then the old value will be overwritten.
6. Add a set! expression. This expression changes the values of local and global variables. 
7. Add a letrec expression. This expression only has to work for recursive procedures but does not have to
   implement the let* like behavior of the Racket letrec expression.
