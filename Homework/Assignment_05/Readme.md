## Assignment 5

**Assume that all arguments have the correct format. Restrictions on Mutation continues.**


Problem 1 uses the definitions and representations of *intervals* that are described in assignment 1


## Q1 (20 points)

Write a Scheme procedure (minimize-interval-list ls) that takes a nonempty list (not necessarily a set) of intervals and returns a  set of intervals that has smallest cardinality among all sets of intervals whose unions are the same as the union of  the list of intervals ls. In other words, combine as many intervals as possible.  

**minimize-interval-list**: *IntervalList* -> *IntervalList*

Examples: 

    (minimize-interval-list '((1 3) (2 3))) 			   -> ((1 3))
    (minimize-interval-list '((1 2) (3 4))) 			   -> ((1 2) (3 4))
    (minimize-interval-list '((1 3) (8 10) (2 4) (9 11)))  -> ((1 4) (8 11))
    (minimize-interval-list '((2 5) (1 7) (6 10) (10 11))) -> ((1 11))
    (minimize-interval-list '((1 2) (4 7) (1 2)))          -> ((1 2) (4 7))


**Hint. One possible approach**: Sort the list first, sorting by the first number in each interval. What do we gain by sorting?  Notice that if the first interval in the list can be merged with any other interval in the list, it can be merged with the second interval.  So once the list is sorted, a straightforward recursive algorithm will produce the merged list in O(N) time.  Of course, the sort itself is not O(N).

How to do the sorting? You can use Racket's sort, which takes as arguments
(a) the list to be sorted
(b) the predicate to use for comparing intervals


## Q2 (5 points)

Write the procedure (exists? pred ls) that returns #t if  pred applied to any element of ls returns #t, #f otherwise.  It should short-circuit; i.e., if it finds an element of ls for which pred returns #t, it should immediately return without looking at the rest of the list.  You may assume that pred actually is a predicate, and that each element of ls is in the domain of pred.  There is a built-in procedure in Chez Scheme (actually two of them) that does this exact thing.  Of course you should write this yourself instead of using one of those.

**exists?**: *predicate* X *relation* -> *Boolean*

Examples:

    (exists? number? '(a b 3 c d)) -> #t
    (exists? number? '(a b c d e)) -> #f


## Q4 (10 points)

Write (best proc lst) where the type of each element of the list lst
is appropriate for an application of the rating function.  The rating
function returns an integer rating for each input.  The function
returns the value for which the rating is the highest.  If multiple
values have the highest rating it returns the earliest in the list.
You can assume the list has at least one element.

**best**: *Procedure* X *List* -> *List Element Type*

Examples:

    (best (lambda (x) x)  '(-1 2 0 3 -6 5)) -> 5
    (best abs '(-1 2 0 3 -6 5)) -> -6
    (best length '((1) (3 4) (5))) -> (3 4)
    (best length '((1) (3) (5))) -> (1)

## Q4 (10 points)

Write the procedure (product set1 set2) that returns a list of 2-lists
that represents the Cartesian product of the two sets.  The 2-lists
may appear in any order, but each 2-list must be in the correct order.

Helper functions, named lets, or even careful use of map and apply can
be useful in this problem.  Any approach is allowed - just stay off
stack overflow.

**product**: *set* X *set* -> *set of 2-lists*

Examples:

    (product '(a b c) '(x y))) -> ((a x) (a y) (b x) (b y) (c x) (c y))


## Q5 (15 points) 

Write a recursive Scheme procedure (remove-last element ls) which takes a symbol and a simple list of symbols. It returns a list that contains (in the original order) everything in ls except  the last occurrence of element.  If element is not in ls, the returned list contains all of the elements of the original list.  In every case, the original list is unchanged.

Examples: 

    (remove-last 'b '(a b c b d))  -> (a b c d)
    (remove-last 'b '(a c d))	   -> (a c d)
    (remove-last 'b '(a c b d))	   -> (a c d) 




