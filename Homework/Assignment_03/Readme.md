## Assignment 3

This is an individual assignment.  You can talk to anyone and get as much help as you need, but you should type in the code and do the debugging process, as well as the submission process.  You should never give or receive code for the individual assignments

*Restriction on Mutation continues.*  One of the main goals of the first few assignments is to introduce you to the functional style of programming, in which the values of variables are never modified.  Until further notice, you may not use set! or any other built-in procedure whose name ends in an exclamation point.  It will be best to not use any exclamation points at all in your code.  You will receive zero credit for a problem if any procedure that you write for that problem uses mutation or calls a procedure that mutates something.  

Assume valid inputs.  As in assignment 1, you do not have to check for illegal arguments to your procedures.  Note that in the set? problem, any Scheme list is a valid input.

Abbreviation for the textbooks:

EoPL - Essentials of Programming Languagges, 3rd Edition

TSPL - The Scheme Programming Language, 4th Edition

EoPL-1 - Essentials of Programming Languages, 1st Edition (small 4-up excerpt handed out in class, also on Moodle)

The first two problems refer to the definition of sets in Scheme from Assignment 2, which are repeated here.

We represent a set by a list of objects.  We say that such a list is a set if and only if it contains no duplicates.  By “no duplicates”, I mean that no two items in the list are equal?


## Q1 (10 points)

Write the procedure (intersection s1 s2) The intersection of two sets is the set containing all items in both sets (order does not matter)

**intersection** *Set* X *Set* -> *Set*

Examples:

    (intersection '(a f e h t b p) '(g c e a b)) -> (a e b) ;(or some permutation of it)
    (intersection '(2 3 4) '(1 a b))             -> ()

You may assume that each argument is a set; no need to test for that. Again, use equal? as your test for duplicate items


## Q2 (10 points)

A set X is a *subset* of the set Y is every member of X is also a member of Y. The procedure (subset? s1 s2) takes two sets as arguments and test whether s1 is a subset of s2. You may want to write a helper procedure. You may assume that both arguments are sets.

**subset?**: *Set* X *Set* -> *Boolean*

Examples: 

    (subset? '(c b) '(a c d b e)) -> #t
    (subset? '(c b) '(a d b e))   -> #f
    (subset? '() '(a d b e))      -> #t
    (subset? '(a d b e) '())      -> #f


## Q3 (15 points)

A *relation* is defined in mathematics to be a set of ordered pairs. The set of all items that appear as the first member of one of the ordered pairs is called the *domain* of the relation. The set of all items that appear as the second member of one of the ordered pairs is called the range of the relation. In Scheme, we can represent a relation as a list of 2-lists (a 2-list is a list of length 2). For example ((2 3) (3 4) (-1 3)) represents a relation with domain (2 3 –1) and range (3 4).Write the procedure (relation? obj) that takes any Scheme object as an argument and determines whether or not it represents a relation.  You will probably want to use set? from a previous assignment  in your definition of relation?.  [Note that because you were just getting started on Scheme, the previous test cases for set? did not include any values that were not lists.  Now you may want to go back and "beef up" your set? procedure so it returns #f  if its argument is not a list.   Note that you may use list? in your set? code if you wish.]

**relation?**: *Scheme-object -> *Boolean*

Examples:

    (relation? 5)                          -> #f
    (relation? '())                        -> #t
    (relation? '((a b) (b c)))             -> #t
    (relation? '((a b) (b a) (b b) (a a))) -> #t
    (relation? '((a b) (b c d)))           -> #f
    (relation? '((a b) (c d) (a b)))       -> #f
    (relation? '((a b) (c d) "5"))         -> #f
    (relation? '((a b) . (b c)))           -> #f


## Q4 (10 points)

Write a procedure (domain r) that returns the set that is the domain of the given relation.  Recall that the domain of a relation is the set of all elements that occur as the first element of an ordered pair in the relation.

**domain**: *Relation* -> *Set*

Examples:

    (domain '((1 2) (3 4) (1 3) (1 6)))  -> (1 3) ;or some permutation of it
    (domain '())                         -> ()
    (domain '((a b) (b d) (a e) (c e)))  -> (a b c) ; or some permutation of it                   


## Q5 (15 points) 

A relation is reflexive if every element of the domain and range is related to itself.  I.e., if (a b) is in the relation, so are (a a) and (b b).  The procedure (reflexive? r) returns #t if relation r is reflexive and #f otherwise.  You may assume that r is a relation; your code does not have to check for that.

Note that this problem is more challenging than most of the other problems in assignments 1-3.

**reflexive?** : *Relation* -> *Boolean*

Examples:

    (reflexive? '((a b) (b a) (b b) (a a))) -> #t
    (reflexive? '((a b) (b c) (a c)))       -> #f
    (reflexive? '((a b) (b c) (a a) (b b) (c c))) -> #t


**Background for problems 6-7:**

A *set* is a list of items that has no duplicates.  In a *multi-set*, duplicates are allowed, and we keep track of how many of each element are present in the multi-set.  For problems in this course, we will assume that each element of a multi-set is a symbol.  We represent a multi-set as a list of 2-lists.  Each 2-list contains a symbol as its first element and a positive integer as its second element.  So the multi-set that contains one a, three bs and two cs might be represented by ((b 3) (a 1) (c 2))  or by ((a 1) (c 2) (b 3))  


## Q6 (11 points)

Write a Scheme procedure (multi-set? obj) that returns #t if obj is a representation of a multi-set, and #f otherwise. In this problem, you may not assume that the argument to the procedure has the correct type.  The point of this problem is to test to see whether the argument has the correct type.

**multi-set?**: *scheme-object* -> *Boolean*

Examples:

    (multi-set? '())                   -> #t
    (multi-set? '(a b))                -> #f
    (multi-set? '((a 2)))              -> #t
    (multi-set? '((a 0)))              -> #f
    (multi-set? '((a 2) (b 3)))        -> #t
    (multi-set? '((a 2) (a 3)))        -> #f
    (multi-set? '((a 3) b))            -> #f
    (multi-set? 5)                     -> #f
    (multi-set? (list (cons 'a 2)))    -> #f
    (multi-set? '((a e) (b 3) (a 1)))  -> #f
    (multi-set? '((a 3.7)))            -> #f


## Q7 (6 points)

Write a Scheme procedure (ms-size ms) that returns the total number of elements in the multi-set ms. (suggested, but not required) Can you do this with very short code that uses map and apply?

**ms-size** : *multi-set* -> *integer*

Examples:

    (ms-size '())            -> 0
    (ms-size '((a 2)))       -> 2
    (ms-size '((a 2)(b 3)))  -> 5

## Q8 (3 points)

Write a recursive Scheme procedure (last ls) which takes a list of elements and returns the last element of that list. This procedure is in some sense the opposite of car. You may assume that your procedure will always be applied to a non-empty proper list. You are not allowed to reverse the list or to use list-tail.  [**Something to think about** (not directly related to doing this problem):  Note that car is a constant-time operation.  What about last? ]

**last** : *Listof(SchemeObject)* -> *SchemeObject*

Examples:

    (last '(1 5 2 4))	-> 4
    (last '(c))         -> c


## Q9 (5 points)

Write a recursive Scheme procedure (all-but-last lst) which returns a list containing all of lst’s elements but the last one, in their original order. In a sense, this procedure is the opposite of cdr.  You may assume that the procedure is always applied to a valid argument. You may not reverse the list.  You may assume lst is a nonempty proper list.   [**Something to think about** (not directly related to doing this problem):  cdr is a constant-time operation.  What about all-but-last? ]

**all-but-last** : *Listof(SchemeObject)* -> *Listof(SchemeObject)*

Examples:

    (all-but-last '(1 5 2 4))  -> (1 5 2)
    (all-but-last '(c))        -> ()







