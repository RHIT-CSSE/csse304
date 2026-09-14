
## Assignment 6

Individual assignment.  Comments at beginning, before each problem, when you do anything non-obvious. Submit to server (test offline first). Mutation not allowed.

Assignments 6a (problems 1-7) and 6b (problems 8-12) are due on different days.

Reading Assignment: See the schedule page.   Have you been keeping up with the reading?

The first four problems are different than problems on previous assignments, in that I want you to read the EoPL-1 material and do related problems without first discussing the material in class.  Of course, you are allowed to get help from other students, from the TAs, and from me. 

Some of the problems deal with *currying*.  http://en.wikipedia.org/wiki/Currying describes this as:  
In mathematics and computer science, currying (schönfinkeling) is the technique of transforming a function that takes multiple arguments (or a tuple of arguments) in such a way that it can be called as a chain of functions, each with a single argument (partial application). It was originated by Moses Schönfinkel and later worked out by Haskell Curry.  

**Optional, not required knowledge for this course**:  An interesting discussion of the advantages of currying (the language of discourse is Haskell, but I think you can still follow much of the discussion):
http://www.reddit.com/r/programming/comments/181y2a/what_is_the_advantage_of_currying/ 
Some simple examples of currying appear on pages 26 (last sentence) through 28 of EoPL-1.  The first two turnin-problems are from that section, and I recommend that you also think about problem 1.3.6.

Reminder:  EoPL-1 is the first edition of EoPL.  An excerpt was handed out on the first day of class.  It is also available on Moodle.

### AI Usage

For this assignment, you may use AI in one specific way.

1.  If you get stuck on 1 problem / problem set, you may use AI to help you.

2.  By help - you can ask AI to explain approach to problems, to help
    you debug your code.  You may not use AI to write your code.
    
3.  You must note in comments that you used AI for the problem you
    used it, and what prompts you used.


## Q1 (10 points)

curry2. This is EoPL-1 Exercise 1.3.4, page 28.   Examples are on that page.

**curry2**: ((*SchemeObject* X *SchemeObject*) -> *SchemeObject*) - > (*SchemeObject* -> (*SchemeObject* -> *SchemeObject*))


## Q2 (10 points)

EoPL-1 Exercise 1.3.5, page 28.  Call your procedure curried-compose.

Examples: 

(((curried-compose car) cdr) '(a b c))   ->   b

**curried-compose**: (*SchemeObject* -> *SchemeObject*) -> ((*SchemeObject* -> *SchemeObject*) -> ( *SchemeObject* -> *SchemeObject*))


## Q3 (10 points)

compose.  EoPL-1 Exercise 1.3.7, page 29.  This one will most likely begin
        (define compose
            (lambda list-of-functions           ; notice the lack of parentheses around the argument name.

**compose**: *ListOf*(*SchemeObject* -> *SchemeObject*) -> (*SchemeObject* -> *SchemeObject*)

Examples: 

((compose list list) 'abc)             ->   ((abc))

((compose car cdr cdr) '(a b c d))     -> c


## Q4 (10 points)

Write the procedure  make-list-c that is a curried version of make-list.
(Note that the original  make-list is described in TSPL Exercise 2.8.3

**make-list-c**: *Integer* -> (*SchemeObject* -> *ListOf*(*SchemeObject*))

Examples: 

    ((make-list-c 3) 'xyz)                       ->   (xyz xyz xyz)
    (let ([triple (make-list-c 3)])
        (triple "cat"))                                    ->   ("cat" "cat" "cat")


## Q5 (10 points)

Write (reverse-it lst) that takes a single-level list lst and returns a new list that has the elements of lst in reverse order. The original list should not be changed. Can you do this in O(n) time? [this is not a requirement].  You probably cannot do it in O(N) time if you use append.  Can you see why? Obviously, you should not use Scheme's reverse procedure in your implementation.


## Q6 (10 points)

Write (map-by-position fn-list arg-list) where:
- fn-list and arg-list have the same length
- each element of the list fn-list is a procedure that can take one argument
- each element of the list arg-list has a type that is appropriate to be an argument of the corresponding element of fn-list.  
map-by-position returns a list (in their original order) of the results of applying each function from fn-list to the corresponding value from arg-list. **You must use map to solve this problem; no explicit recursion is allowed**.

Examples:

    (map-by-position (list cadr - length (lambda(x)(- x 3))) 
                 '((1 2) -2 (3 4) 5))                     -> (2 2 2 2)                


## Q7 (45 points)

**Examples are in the test cases**. A Binary Search Tree (BST) datatype is defined on page 10 of  EoPL.  Note that, as the book describes, the grammar alone is not sufficient to completely describe what constitutes a BST.  We also need the "smaller values in left subtree, larger in right subtree" property, which cannot be descibed using a context-free grammar.  Write the following procedures.  Remember, no mutation of lists is allowed !  If you cheat by representing a BST as a single-level sorted list or some other simpler structure, you will get 0 points, even if your code passes  a lot of the test cases.

1.	(empty-BST) takes no arguments and creates an empty tree, which is represented by an empty list.
2.	(empty-BST? obj) takes a Scheme object obj. It returns #t if obj is an empty BST and #f otherwise.
3.	(BST-insert num bst) returns a BST result.  If num is already in bst, result is structurally equivalent to bst.  If num is not already in bst, result adds num in its proper place relative to the other nodes in a tree whose shape is the same as the original.  Like any BST insertion, this should have a worst-case running time that is O(height(bst)).  
4.	(BST-inorder bst) (can you do it in O(N) time?) produces an ordered list of the values in bst.
5.	(BST? obj) returns #t if Scheme object obj is a BST and #f otherwise.
6.	BST-element, BST-left, BST-right.  Accessor procedures for the parts of a node.
7.	(BST-insert-nodes bst nums)starts with tree bst and inserts each integer from the list  nums, in the given order, returning the tree that includes all of the inserted nodes.  The original tree is not changed, and this procedure does no mutation.
8.	(BST-contains? bst num)  determines, in time that is O(height(bst)), whether num is in bst. 
9.	(BST-height bst) returns the height of the BST bst.

Examples: 

    (BST-height '())  -> -1
    (BST-height '(3 () ())) -> 0
    (BST-height '(2 ()(6 (4 () ()) ()))) -> 2









