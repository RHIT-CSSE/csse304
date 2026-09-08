## Assignment 6

Individual assignment.  Comments at beginning, before each problem, when you do anything non-obvious. Submit to server (test offline first). Mutation not allowed.

Assignments 6a (problems 1-7) and 6b (problems 8-12) are due on different days.

Reading Assignment: See the schedule page.   Have you been keeping up with the reading?


## Q1 (10 points)

Write let->application  which takes a let expression (represented as a list) and returns the equivalent expression (also represented as a list) that represents an application of a procedure created by a lambda expression. Your solution should not change the body of the let expression. This procedure's output list replaces only the top-level let by an equivalent application of a lambda expression. You do not have to find and replace any non-top-level lets.  You may assume that the let expression has the proper form; your procedure does not have to check for this. Furthermore, you may assume that the let expression is not a named let.  

**let->application**: *SchemeCode* -> *SchemeCode*

Examples:

    (let->application '(let ((x 4) (y 3))
                            (let ((z 5))
                               (+ x (+ y z))))) ->
      ((lambda (x y)
         (let ((z 5))
           (+ x (+ y z))))
       4 3)


## Q2 (10 points) 

Write let*->let which takes a let* expression (represented as a list) and returns the equivalent  nested let expression. This procedure replaces only the top-level let* by an equivalent nested let expression.  You may assume that the let* expression has the proper form.

<b> let*->let:</b>  *SchemeCode* -> *SchemeCode*

Example:

	(let*->let '(let* ([a 3] [b (+ a 4)]) b )) ->
           
       (let ([a 3]) 
     	   (let ([b (+ a 4)])
        	b))


## Q3 (20 points)

(qsort pred ls) is a Scheme procedure  that you will write whose arguments are
	a predicate  (total ordering) which takes two arguments x and y, and returns #t if x is "less than" y, #f otherwise.
	a list whose items can be compared using this predicate. 
qsort should produce the sorted list using a QuickSort  algorithm (write your own; do not use Scheme’s sort procedure).  

Examples:

    (qsort <= '(4 2 4 3 2 4 1 8 2 1 3 4)) -> (1 1 2 2 2 3 3 4 4 4 4 8)

    (qsort (lambda (x y) (<= (abs (- x 10)) (abs (- y 10)))) 
       '(5 1 10 8 16 17 23 -1))
     -> (10 8 5 16 17 1 -1 23)

If you do not remember how QuickSort works, see http://en.wikipedia.org/wiki/Quicksort or Chapter 7 of the Weiss book used for CSSE230.  There are quicksort algorithms that do fancy things when choosing the pivot in order to attempt to avoid the worst case.  You do not need to do any of those things here; you can simply use the car of the list as the pivot.  Since mutation is not allowed, your algorithm cannot do the sort in-place.  Furthermore, you are not allowed to copy the list elements to a vector, then sort the vector and copy back to a list.  All of your work should be done with lists.


## Q4 (15 points)

Write a Scheme procedure (sort-list-of-symbols los) which takes a list of symbols and returns a list of the same symbols sorted as if they were strings. You will probably find the following procedures to be useful:  
       symbol->string, map, string<?, sort (you can look them up in the Racket guide).  Note that we have not covered specifics related to this problem,  It is time for you to read some documentation and figure out how to use things.  You'll have the Racket Guide to help you on exams.
**sort-list-of-symbols**: *ListOf*(*Symbol*) -> *ListOf*(*Symbol*)

Exmaples:

(sort-list-of-symbols '(b c d g ab f b r m)) ->  (ab b b c d f g m r)







