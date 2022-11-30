## Assignment 4

This is an individual assignment.  You can talk to anyone and get as much help as you need, but you should type in the code and do the debugging process, as well as the submission process.  You should never give or receive code for the individual assignments

*Restriction on Mutation continues.*  One of the main goals of the first few assignments is to introduce you to the functional style of programming, in which the values of variables are never modified.  Until further notice, you may not use set! or any other built-in procedure whose name ends in an exclamation point.  It will be best to not use any exclamation points at all in your code.  You will receive zero credit for a problem if any procedure that you write for that problem uses mutation or calls a procedure that mutates something.  

Assume valid inputs.  As in assignment 1, you do not have to check for illegal arguments to your procedures.  Note that in the set? problem, any Scheme list is a valid input.

Abbreviation for the textbooks:

EoPL - Essentials of Programming Languagges, 3rd Edition

TSPL - The Scheme Programming Language, 4th Edition

EoPL-1 - Essentials of Programming Languages, 1st Edition (small 4-up excerpt handed out in class, also on Moodle)

## Q1 (3 points)

A *matrix* is a rectangular grid of numbers.  We can represent a matrix in Scheme by a list of lists (the inner lists must all have the same length).  For example, we represent the matrix:

    1   2   3   4   5
    4   3   2   1   5
    5   4   3   2   1

by the list of lists ((1 2 3 4 5) (4 3 2 1 5) (5 4 3 2 1)) .   We say that this matrix has 3 rows and 5 columns or (more concisely) that it is a 3×5 matrix.  **A matrix must have at least one row and one column**.

Write a Scheme procedure (matrix-ref m row col), where m is a matrix, and row and col are integers.  Like every similar structure in modern programming languages, the index numbers begin with 0 for the first row or column.  This procedure returns the value that is in row row and column col of the matrix m.  Your code does not have to check for illegal inputs or out-of-bounds issues.  You can use list-ref in your implementation.

**matrix-ref** : *Listof(Listof(Integer))* X *Integer* X *Integer* -> *Integer* (assume that the first argument actually is a matrix)

Examples:

if *m* is the above matrix,
    (matrix-ref m 0 0) -> 1
    (matrix-ref m 1 2) -> 2


## Q2 (15 points)

The predicate (matrix? obj)should return #t if the Scheme object obj is a matrix (a nonempty list of nonempty lists of numbers, with all sublists having the same length), and return #f otherwise.  In this problem, you may not assume that the argument to the procedure has the correct type.  The point of this problem is to test to see whether the argument has the correct type.

**matrix?**: *SchemeObject* -> *Boolean*

Examples:

    (matrix? 5)  	                    -> #f
    (matrix? "matrix")  	            -> #f
    (matrix? '(1 2 3))  	            -> #f
    (matrix? '((1 2 3)(4 5 6)))  	    -> #t
    (matrix? '#((1 2 3)(4 5 6)))  	    -> #f
    (matrix? '((1 2 3)(4 5 6)(7 8)))	-> #f
    (matrix? '((1)))  	                -> #t
    (matrix? '(()()()))  	            -> #f


## Q3 (10 points)

Each row of (matrix-transpose m) is a column of m and vice-versa. 

**matrix-transpose**: *Listof(Listof(Integer))* -> *Listof(Listof(Integer))*  (assume that the argument actually is a matrix)

Examples:

    (matrix-transpose '((1 2 3) (4 5 6))) -> ((1 4) (2 5) (3 6))
    (matrix-transpose '((1 2 3)))         -> ((1) (2) (3))
    (matrix-transpose '((1) (2) (3)))     -> ((1 2 3))


## Q4 (10 points)

Write (filter-in pred? lst)  where the type of each element of the list  lst is appropriate for an application of the predicate pred?.  It returns a list (in their original order) of all elements of lst for which pred? returns a true value.  **Do not use a built-in procedure that does the whole thing**.

**filter-in**: *Procedure* X *List* -> *List*

Examples:

    (filter-in positive? '(-1 2 0 3 -6 5))        -> (2 3 5)
    (filter-in null? '(() (1 2) (3 4) () ()))     -> (() () ())
    (filter-in list? '(() (1 2) (3 . 4) #2(4 5))) -> (() (1 2))
    (filter-in pair? '(() (1 2) (3 . 4) #2(4 5))) -> ((1 2) (3 . 4))
    (filter-in null? '())                         -> ()


## Q5 (10 points)

invert EoPL 1.16, page 26 [Note that this is EoPL, not EoPL-1]


## Q6 (20 points)

pascal-triangle.  If you are not familiar with Pascal’s triangle, see this page: http://en.wikipedia.org/wiki/Pascal_triangle .  The first recursive formula that appears on that page will be especially helpful for this problem.  
Write a Scheme procedure (pascal-triangle n) that takes an integer n, and returns a “list of lists” representation of the first n+1 rows of Pascal’s triangle.  The required format should be apparent from the examples below (note that line-breaks are insignificant; it’s just the way Scheme’s pretty-printer displays the output in a narrow window)  **Don't forget: no mutation!**

**pascal-triangle**: *Integer* -> *Listof(Listof(Integer))*

Examples:

    (pascal-triangle 4)
    ((1 4 6 4 1) (1 3 3 1) (1 2 1) (1 1) (1))

    (pascal-triangle 12)
    ((1 12 66 220 495 792 924 792 495 220 66 12 1)
    (1 11 55 165 330 462 462 330 165 55 11 1)
    (1 10 45 120 210 252 210 120 45 10 1)
    (1 9 36 84 126 126 84 36 9 1)
    (1 8 28 56 70 56 28 8 1)
    (1 7 21 35 35 21 7 1)
    (1 6 15 20 15 6 1)
    (1 5 10 10 5 1)
    (1 4 6 4 1)
    (1 3 3 1)
    (1 2 1)
    (1 1)
    (1))

    (pascal-triangle 0)
    ((1))

    (pascal-triangle -3) ; if argument is negative, return the empty list
    ()

You should seek to do this simply and efficiently.  You may need more than one helper procedure.  If your collection of procedures for this problem starts creeping over 25 lines of code, perhaps you are making it too complicated.  There is a straightforward solution that is considerably shorter than that.

A challenge for the Pascal Triangle problem (efficiency)
My challenges will not affect your score for the problem.
A simple way to do this problem is to use call the choose procedure from a previous homework.  But on the average (choose n k) has Θ(n)  running time, so producing only the largest row of (pascal-triangle n) will be Θ(n2).  This means that the entire call to (pascal-triangle n) will be Θ(n3).  
Your first challenge is to reduce that to Θ(n2).  This will require that every number in the triangle be calculated in constant time and that list operations you do will also be constant time for each number in the triangle).
Second challenge:  Multiplication is slower than addition.  Can you meet the above constraints without doing any multiplications or divisions? 











    









    