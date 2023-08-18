## Assignment 7

Your code must not mutate (unless a particular problem calls for it), read, or write anything.  Assume arguments have correct form unless problem says otherwise.
Abbreviations for the textbooks: 	
    EoPL	-   Essentials of Programming Languages, 3rd Edition
	TSPL	-  The Scheme Programming Language, 4rd Edition
	EoPL-1	-  Essentials of Programming Languages, 1st Edition (handout)


Note Assignment 7a is problems 1-3.  7b is 4-6.

## Q1 (10 points)

(group-by-two ls) takes a list ls.  It returns a list of lists: the elements of ls in groups of two.  If ls has an *odd number of elements, the last sublist of the return value will have one element*.

**group-by-two**: *List* -> *ListOf*(*List*)

Examples: 

    > (group-by-two '())
    ()
    > (group-by-two '(a))
     ((a))
    > (group-by-two '(a b))
    ((a b))
    > (group-by-two '(a b c))
    ((a b) (c))
    > (group-by-two '(a b c d e f g))
    ((a b) (c d) (e f) (g))
    > (group-by-two '(a b c d e f g h))
    ((a b) (c d) (e f) (g h))


## Q2 (20 points)

group-by-n ls n) takes a list ls and an integer n (you may assume that n≥2).  Returns a list of lists: the elements of ls in groups of n.  If ls has a number of elements that is not a multiple of n, the length of the last sublist of the return value will be less than n.  **For full credit, your code must run in time O(length (ls)). In particular, this means that no recursive procedure in your code can call (length ls).**

**group-by-n**: *List* -> *ListOf*(*List*)

Examples:

    > (group-by-n '() 3)
    ()
    > (group-by-n '(a b c d e f g) 3)
    ((a b c) (d e f) (g))
    > (group-by-n '(a b c d e f g) 4)
    ((a b c d) (e f g))
    > (group-by-n '(a b c d e f g h) 4)
    ((a b c d) (e f g h))
    > (group-by-n '(a b c d e f g h i j k l m n o) 7)
    ((a b c d e f g) (h i j k l m n) (o))
    > (group-by-n '(a b c d e f g h) 17)
    ((a b c d e f g h))
    > (group-by-n '(a b c d e f g h i j k l m n o p q r s t) 17)
    ((a b c d e f g h i j k l m n o p q) (r s t))


## Q3 (57 points)

Consider the following syntax definition from page 9 of EoPL:
         `  <bintree> ::= <integer>  | ( <symbol> <bintree> <bintree> )`

Note that this representation is quite different than the BST representation in Assignment 6.

Write the following procedures:

- (bt-leaf-sum T) finds the sum of all of the numbers in the leaves of the bintree T.
- (bt-inorder-list T) creates a list of the symbols from the interior nodes of T, in the order that they would be visited by an inorder traversal of the binary tree.
- (bt-max T) returns the largest integer in the tree.
- (bt-max-interior T) takes a binary tree with at least one interior node, and returns (in O(N) time, where N is the number of nodes) the symbol associated with an interior node whose subtree has a maximal leaf sum (at least as large as the sum from any other interior  node in the tree). If multiple nodes in the tree have the same maximal leaf-sum, return the symbol associated with the leftmost (as it appears in the tree’s printed representation) maximal node. 

**The bt-max-interior procedure is trickier than it looks at first!**

- You may not use mutation.  
- You may not traverse any subtree twice (such as by calling bt-leaf-sum on every interior node). 
- You may not create any additional size-Ω(N) data structures that you then traverse to get the answer.  
- Think about how to return enough info from each recursive call to solve this without doing another traversal.  

 **Note**:  We will revisit this linear-time bt-max-interior problem several times during this course.  If you do not get this version, the later versions will be harder for you, so you should do what it takes to get this one.


## Q4 (50 points)

These s-list procedures have a lot in common with the s-list procedures that we wrote during our Session 8 class.  Recall the extended BNF grammar for s-lists:

    <s-list>       ::= ( {<s-expression>}* )
    <s-expression> ::=  <symbol> | <s-list>

**FOLLOW THE GRAMMAR!**

(a)	(slist-map proc slist) applies proc to each element of slist.
          **slist-map**:  *procedure* x *Slist* -> *NestedListOfThingsThatAreInTheRangeOfProcedure*

      (slist-map symbol? '((a (()) b) c () (d e)))        ->  ((#t (()) #t) #t () (#t #t))
                (slist-map (lambda (x) 
                    (let ([s (symbol→string x)]) 
                           (string→symbol (string-append s s)))) 
                  '((b (c) d) e ((a)) () e))               ->      ((bb (cc) dd) ee ((aa)) () ee)

(b)	(slist-reverse slist) reverses slist and all of its sublists.
          *slist-reverse*:  *Slist* -> *Slist*
	
       (slist-reverse '(a (b c) ( ) (d (e f)))) -> (((f e) d) ( ) (c b) a)

(c)	(slist-paren-count slist) counts the number of parentheses required to produce the printed representation of  slist.  You must do this by traversing the structure, not by having Scheme give you a string representation of the list and counting parenthesis characters. You can get this count by looking at cars and cdrs of slist).

**slist-paren-count**:  *Slist* -> *Integer*


        (slist-paren-count '())                   -> 2	      
        (slist-paren-count '(a (b c) d))          -> 4			
        (slist-paren-count '(a (b) (c () ((d))))) -> 12	

**Note** : s-lists are always *proper* list

(d) (slist-depth slist) finds the maximum nesting-level of parentheses in the printed representation of slist. You must do this by traversing the structure, and not by having Scheme give you a string representation of the list and counting the maximum nesting of parenthesis characters.

**slist-depth**:  *Slist* -> *Integer*

    (slist-depth '())                               -> 1
    (slist-depth '(a b c))                          -> 1
    (slist-depth '(a (b c) d))                      -> 2
    (slist-depth '(a (b (c)) (a b)))                -> 3
    (slist-depth '(((a) (( )) b) (c d) e))          -> 4 

(e) (slist-symbols-at-depth slist d)returns a list of the symbols from slist whose depth is the positive integer d.  They should appear in the same order in the return list as in the original s-list.  This one has the basic pattern of the other s-list procedures, but when writing the solution, I found it easier to use a slight variation on that pattern.

**slist-symbols-at-depth**:  *Slist* x *PositiveInteger* -> *ListOf*(*Symbol*)

    (slist-symbols-at-depth '(a (b c) d) 2)  -> (b c)
    (slist-symbols-at-depth '(a (b c) d) 1)  -> (a d)
    (slist-symbols-at-depth '(a (b c) d) 3)  -> ()


## Q5 (10 points)

(path-to slist sym) produces a list of cars and cdrs that (when read left-to-right) take us to the position of the leftmost occurrence of sym in the s-list slist.  Notice that the returned list contains the symbols 'car and 'cdr, not the *car* and *cdr* procedures.  Return #f if sym is not in slist.   Only traverse as much of slist as is necessary to find sym if it is there.

    > (path-to '(a b) 'a)
    (car)
    > (path-to '(c a b) 'a)
    (cdr car)
    > (path-to '(c () ((a b))) 'a)
    (cdr cdr car car car)
    > (path-to '((d (f ((b a)) g))) 'a)
    (car cdr car cdr car car cdr car)
    > (path-to '((d (f ((b a)) g))) 'c)
    #f


## Q6 (15 points)

Predefined Scheme procedures like cadr and cdadr are compositions of up to four cars and cdrs.  You are to write a generalization called make-c...r, which does the composition of any number of cars and cdrs.  It takes one argument, a string of a's and d's, which are used like the a's and d's in the names of the pre-defined c…r functions.  For example, (make-c...r "adddd") is equivalent to (compose car cdr cdr cdr cdr).

    > (define caddddr (make-c...r "adddd"))
    > (caddddr '(a (b) (c) (d) (e) (f)))
    (e)
    > ((make-c...r "") '(a b c))
    (a b c)
    > ((make-c...r "a") '(a b c))
    a
    > ((make-c...r "ddaddd") '(a b c ((d e f g) h i j)))
    (i j)
    > ((make-c...r "addddddddddd") '(a b c d e f g h i j k l m))
    l

[compose](https://docs.racket-lang.org/reference/procedures.html#%28def._%28%28lib._racket%2Fprivate%2Flist..rkt%29._compose%29%29)
is a key utility in functional style.  It combines any number of
(usually) one argument functions into a single function.  BTW, another
really useful one we won't really talk about in class is curry (I
encourage you to [check it
out](https://docs.racket-lang.org/reference/procedures.html#%28def._%28%28lib._racket%2Ffunction..rkt%29._curry%29%29).

I require you to use compose to solve this problem - do NOT build your
own solution from scratch that calls car and cdr.  The idea is pretty
simple - compose together the cdr and car functions needed depending
on the input string (BTW string->list is the way to get the individual
characters out of the list).  A simple recursion can do it - map makes
it even easier.

**Note:** some versions of this assignment suggested using eval.
Don't use eval - it's unnecessary.
