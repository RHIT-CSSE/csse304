# Assignment 2

This is an individual assignment.  You can talk to anyone and get as much help as you need, but you should type in the code and do the debugging process, as well as the submission process.  You should never give or receive code for the individual assignments

*Restriction on Mutation continues.*  One of the main goals of the first few assignments is to introduce you to the functional style of programming, in which the values of variables are never modified.  Until further notice, you may not use set! or any other built-in procedure whose name ends in an exclamation point.  It will be best to not use any exclamation points at all in your code.  You will receive zero credit for a problem if any procedure that you write for that problem uses mutation or calls a procedure that mutates something.  	
	
Assume valid inputs.  As in assignment 1, you do not have to check for illegal arguments to your procedures.  Note that in the set? problem, any Scheme list is a valid input.

## Q1 (5 points) 

(a) Copy the procedure (fact n) from Assignment 0, and call it from your choose procedure from part (b).

fact:  NonNegativeInteger -> Integer

Examples:

    (fact 0) ->     1
    (fact 1) ->     1
    (fact 5) -> 120

(b) (5) Write the procedure (choose n k) which returns the number of different subsets of k items that can be chosen from a set of n distinct items.  This is also known as the binomial coefficient.  If you’ve forgotten the formula for this, a Google search for “Binomial Coefficient” should be helpful.  

choose:  NonNegativeInteger x NonNegativeInteger -> NonNegativeInteger  (examples on next page)
 
Examples:

    (choose 0 0)  ->     1
    (choose 5 1)  ->     5
    (choose 10 5) -> 252 

## Q2 (5 points) 

Write a procedure (sum-of-squares lon) that takes a (single-level) list of numbers, lon, and returns the sum of the squares of the numbers in lon.

sum-of-squares:  Listof(Number) -> Number

Examples:

    (sum-of-squares '(1 3 5 7)) -> 84
    (sum-of-squares '())        -> 0


## Q3 (8 points) 

Write the procedure (range m n) that returns the ordered list of integers starting at the integer m and increasing by one until just before the integer n is reached (do not include n in the resulting list).  This is similar to Python's range function.  If n is less than or equal to m, range returns the empty list. 
  
range:  Integer x Integer -> Listof(Integer)

Examples:

    (range 5 10) ->  (5 6 7 8 9)
    (range 5 6)  -> (5)
    (range 5 5)  -> ( )
    (range 5 3)  -> ( )

## Q4 (10 points)

In mathematics, we informally define a set to be a collection of items with no duplicates.  In Scheme, we could represent a set by a (single-level) list.  We say that a list is a set if and only if it contains no duplicates.  We say that two objects o1 and o2 are duplicates if (equal? o1 o2).  Write the predicate (my-set? list), that takes any list as an argument and determines whether it is a set.

Do not use the built in set when solving this problem.

my-set? : list -> Boolean

Examples:

    (my-set? '())                              -> #t         ; empty set
    (my-set? '(1 (2 3) (3 2) 5))               -> #t         ; (2 3) and (3 2) are not equal?
    (my-set? '(r o s e - h u l m a n))         -> #t
    (mt-set? '(c o m p u t e r s c i e n c e)) -> #f         ; duplicates

## Q5 (5 points) 

The union of two sets is the set of all items that occur in either or both sets (the order of the items in the list does not matter).

union:  Set x Set -> Set

Examples:

    (union '(a f e h t b) '(g c e a b)) -> (a f e h t b g c)  ; (or some permutation of it)
    (union '(2 3 4) '(1 a b 2))         -> (2 3 4 1 a b)      ; (or some permutation of it)

## Q6 (5 points)

Write a procedure (more-positives? lon) that return true if the list has more positive numbers than non-positive numbers.

hint: you might need to write a recursive helper function with a
different return type or different parameters.  This one is
straightforward to solve with tail recursion, but we won't require
that.

more-positives: Listof(Integer) -> Boolean

Examples:

    (more-positives '(1 2 -1)) -> #t
    (more-positives '(10 -2 -1)) -> #f
    (more-positives '(10 0)) -> #f

## Q7 (10 points)

Write a procedure (nearest-pair lon) that returns a scheme Pair of the two integers from the list that are numerically closet to each other, in sorted order.  You can assume that that there is one unique closest pair (i.e. dont have to consider when there are two pairs with the same smallest distance).  You can assume the list has 2 elements at least.

hint: it might be handy to search racket's built in help for "sort" as part of solving this problem

nearest-pair: ListOf(Integer) -> Pair(Integer)

Examples:

    (nearest-pair '(10 20 22 30 40)) -> (20 . 22)
    (nearest-pair '(7 101 20 100 0)) -> (100 . 101)
