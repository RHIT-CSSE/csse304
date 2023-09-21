#lang racket

(provide running-sum sublists snl-type two-stream fib-stream alternate-stream prepend-stream make-queue)

;;  A function that takes in a list of numbers and returns a list
;;  where element 1 is unchanged, element 2 is sum of e1+e2, element
;;  3 is e1+e2+e3 etc.
;;  
;;  (running-sum '(1 10 300)) => (1 11 311)

(define running-sum
  (lambda (ls)
    (nyi)))

;;  Returns a list of the 2^n sublists of a given list of numbers.  A sublist
;;  is a list that contains some elements of the original list - as
;;  few as 0 or as many as them all.  For example:
;;  
;;      > (sublists '(1))
;;      '(() (1))
;;      > (sublists '(1 2 3))
;;      '(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))
;;  
;;  The order the sublists are returned does not matter, and to make
;;  it easier the order of the items within each sub list does not
;;  matter (though you can see my solution keeps the elements in
;;  their original order).  You are required to have the right
;;  number of sublists (i.e. your solution should not have duplicates).
;;
;;  There is a built in racket function combinations that is this problem.
;;  Do not use combinations (or similar) in your solution.
(define sublists
  (lambda (ls)
    (nyi)))

;; You may use mutation to solve this problem
;;
;; Implement a simple first-in first-out queue.  You should support
;; the operations enqueue, dequeue and empty?  Here's an example:
;;
;;  > (define q (make-queue))
;;  > (q 'enqueue 1)
;;  > (q 'enqueue 2)
;;  > (q empty?)
;;  > (q 'empty?)
;;  #f
;;  > (q 'dequeue)
;;  1
;;  > (q 'dequeue)
;;  2
;;
;; For 10 points implement it any way you wish (hint - I like using reverse an excessive amount)
;;
;; For 20 points use modifiable pairs (mcons, mcar, mcdr, set-mcar!, set-mcdr!) to implement
;; a queue where all the operations are O(1).  I reccomend you get it working the basic
;; way first before you try this.


(define make-queue
  (lambda ()
    (nyi)))


;; Consider a simple language I call snl (for symbol number list).
;; 
;; snl ::=   <number>
;;           | <symbol>
;;           | ( { <snl> }+ )
;; 
;; Some examples of snl are
;; 
;; a 1 (2 a) ((3 4) (4 6))
;; 
;; Given this, a subset of of snls have what I'll call an snl-type.
;; This is simply a type that describes the value or list *if it
;; is consistent*.  Here's some snls and their types
;; 
;; 1 - number
;; q - symbol
;; (7 2 3)  - (number)
;; ((1 2) (3 4) (5)) - ((number))
;; (((a) (z c)) ((d))) - (((symbol)))  
;; 
;; Read (number) as list of number and ((number)) as list of list of
;; number etc.
;; 
;; Other snls do not have a consistent type and I consider that to be of
;; "error" type.  If any part of the snl type is an error, then the whole
;; thing is an error (e.g. ((error)) is not a valid type).
;; 
;; (1 a) - error
;; ((1 a) (b 3 4)) - error
;; (1 2 (3) 4) - error
;; (((a) (b c)) (d)) - error
;; 
;; Write a procedure that given an snl returns the snl-type or error.
;; 
;; Note that for an snl (as contrasted with an slist) '() is not a
;; valid list (note the + in the above grammar) so you cases will
;; probably include 1 element lists rather than null?.

(define snl-type
  (lambda (lst)
    (nyi)))

;;  Infinite streams
;;  
;;  Stream are a general thing in computer science, where we
;;  repeatedly get values from some sort of source - frequently a
;;  file or web page.  Sometimes it's useful to have a stream that
;;  represents an infinite mathematical sequence as well.  We'll build
;;  some of these as simple functions, a little bit like the counter
;;  we talked about in class.  Here's an example of a stream I call
;;  two stream, that when invoked returns increasing powers of two:
;;  
;;      > (define s (two-stream))
;;      > (s)
;;      2
;;      > (s)
;;      4
;;      > (s)
;;      8
;;
;;  You may use mutation for all the question in this part.
;;
;;  Build two-stream.  Be sure to build it in a way that that I can
;;  have multiple streams existing at once each with their own stream
;;  state (see the test cases for an example).
;;  
;;  fib-stream represents the fibonacci number sequences that goes
;;  like 1 1 2 3 5 8 where every n equals the sum of the prior two.
;;  For ease of implementation reasons though, our fib stream will
;;  start with 2 (i.e. 2 3 5 8 etc).  Build fib-stream.
;;  
;;  Once we have streams we can combine them interestingly.  Write a
;;  function alternate streams which gets two streams and produces a
;;  new stream that alternates their values.  For example:
;;  
;;      > (let ((s (alternate-stream (fib-stream) (two-stream)) )) (list (s) (s) (s) (s) (s) (s) ))
;;      '(2 2 3 4 5 8)
;;  
;;  We can even combine infinite and non-infinite streams.  Write a
;;  function prepend stream that takes a list and a stream and
;;  produces a stream which initially returns the value of the the
;;  list and afterward returns the value of the stream.
;;  
;;      > (let ((s (prepend-stream '(1 1) (fib-stream)) )) (list (s) (s) (s) (s) (s) (s) ))
;;      '(1 1 2 3 5 8)


(define two-stream
  (lambda ()
    (nyi)))

(define fib-stream
  (lambda ()
    (nyi)))

(define alternate-stream
  (lambda (s1 s2)
    (nyi)))

(define prepend-stream
  (lambda (lst s1)
    (nyi)))


;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))