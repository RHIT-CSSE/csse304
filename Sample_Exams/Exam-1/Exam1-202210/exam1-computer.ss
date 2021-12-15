;; EXAM 1 202210 COMPUTER PART

;; You may use your notes, Chez Scheme, the three textbooks from the
;; course, The Chez Scheme Users' Guide, the PLC grading program, any
;; materials that I provided online for the course.  You may do
;; searches for built-in Scheme procedures, but not for the particular
;; problems that you are solving.  You may not use any other web or
;; network resources, or programs written by other (past or present)
;; students.  You are allowed to look at and use any Scheme code that
;; you have previously written.

;; You may assume that all of your procedures' input arguments have
;; the correct types and values; your code does not need to check for
;; illegal input data.  Mutation is not allowed, except for the bag
;; problem, which requires mutation.


;; QUESTION 1: set subtract (12 points)
;;
;; Write a procedure that takes two sets as parameters (sets as defined
;; in A2 & A3, basically lists of non-repeated symbols).  The function
;; returns the elements of the first set without any elements that are
;; contained in both sets.  For example:

;; > (set-subtract '(a b c) '(c a d))
;; (b)
;;
;; As with all these questions, you can see more examples in the test
;; cases.
;;
;; Note that although there are more efficient solutions possible,
;; I'll be satisfied with an O(n^2) algorithm here.
(define (set-subtract set subtractme)
  'nyi)


;; QUESTION 2: sublist (12 points)
;;
;; Write a procedure that takes two lists of numbers, which I call big
;; and little.  The function returns true if the little list occurs as
;; a consecutive subsequence within the big list.  Note that unlike an
;; ordinary subset relationship, order matters - the elements in the
;; both lists must be in the the same order, not just have the same
;; values somewhere in the list.
;;
;; Examples:
;; > (sublist? '(1 2 99 100 3 4) '(99 100))
;; #t
;; > (sublist? '(1 2 99 100 3 4) '(100 99))
;; #f
;; > (sublist? '(1 2 99 100 3 4) '())
;; #t

(define (sublist? big little)
  'nyi)

;; QUESTION 3: remove depth (12 points)
;;
;; Write a procedure that takes a integer depth and an slist.  The
;; function returns a new slist where all nodes of a given depth have
;; been "flattened" into their parent.  Nodes above/below the given
;; depth are not flattend.  Note that other than this flattening, the
;; slist remains in the same order it was.
;;
;; Examples:
;; > (remove-depth 2 '(a (b c) d))
;; (a b c d)
;; > (remove-depth 2 '(a (b (c)) d))
;; (a b (c) d)
;; > (remove-depth 3 '(a (b (c)) d))
;; (a (b c) d)
;;
;; Note that you can assume depth will always be >= 2 (hopefully on
;; consideration you'll realize that attempting to remove depth
;; 1 isn't possible)
(define (remove-depth depth slist)
  'nyi)

;; QUESTION 4: bag (12 points)
;;
;; Write a procedure make-bag that returns a "bag" object for symbols.
;; A bag is an unordered structure little bit like a set, but it
;; allows the same element to be inserted more than once.  It keeps
;; track of how many items are in the bag.
;;
;; There are 3 fundimental operations, but we only require you to implement 2:
;;
;; * add <symbol> - increases the count of the given symbol in the bag
;;
;; * count <symbol> - returns the count for the given symbol (which might be 0)
;;
;; * remove <symbol> - this one is not hard, but we're not requiring
;;   it due to exam time constraints
;;
;; The underlying data structure can be whatever you want - you don't
;; have to make the bag operations efficient
;;
;; You will need to use mutation to solve this problem
;;
;; Example:
;;
;; (let ((b1 (make-bag)))
;;   (b1 'add 'x)
;;   (b1 'add 'y)
;;   (b1 'add 'x)
;;   (b1 'count 'x)) ;; yields 2

(define (make-bag)
  'nyi)

;; QUESTION 5: swap-two-params (6 points)
;;
;; Sometimes we have a curried function but the parameters are not in
;; the correct order.  swap two params takes a two parameter curried
;; function and returns a new two parameter curried function where the
;; paramters are accepted in the reverse order.
;;
;; Example:
;;
;; ((curried-subtract 5) 3) ;; yields 2
;; (define swaped-subtract (swap-two-params curried-subtract))
;; ((swaped-subtract 5) 3) ;; yields -2
;;
;; ((curried-cons 3) '()) ;; yields (3)
;; (((swap-two-params curried-cons) 3) '()) ;; yields (() . 3)


;; hint: I've used the form of define that makes the lambda implicit
;; here, as in the other problems.  You might find it easier to use
;; the form of define that requires you to explicitly say lambda.
(define (swap-two-params cur-fun)
  'nyi)


;; QUESTION 6: add unused (6 points)
;;
;; Sometimes we have a curried function that expects a specific number
;; of parameters, but we're passing it into a context that expects
;; more parameters.  Write a procedure that takes a curried function
;; and an integer n and returns a curried function that takes n more
;; (unused) parameters but otherwise acts the same.
;;
;; Example:

;; > ((curried-add 2) 3) ;; normally takes 2 parameters
;; 5
;; > (((((add-unused curried-add 2) 15) 6) 20) 30) ;; now takes 2 extra
;; 50
;;
;; Note in the above example, the unused parameters are the first
;; parameters passed to the resultant function (i.e. we ignore 15 and
;; 6 and then add 20 and 30).

(define (add-unused curried-func num)
  'nyi)

