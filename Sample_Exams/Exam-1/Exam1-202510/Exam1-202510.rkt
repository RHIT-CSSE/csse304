#lang racket

(provide make-increasing expand-ranges expand-step adjustable-proc numerical-recur make-sneaky)

;; RECURSION 1 - 16 pts
;;
;; Write a function that given a list, removes all numbers that are
;; not increasing in value (i.e. removes a number if it is less than
;; any number encountered thus far).
;;
;; (make-increasing '(7 8 5 6 10)) yields '(7 8 10)
(define make-increasing
  (lambda (lst)
    'nyi))


;; RECURSION 2 - 14 pts
;;
;; Write a function that takes a series of ranges expressed as pairs
;; (e.g. (1 3) corresponds to (1 2 3)).  The function should return a
;; list of numbers where the ranges have been expanded into a list of
;; numbers in increasing order.
;;
;; (expand-ranges '((5 7) (8 10))) yields '(5 6 7 8 9 10)
(define expand-ranges
  (lambda (lst)
    'nyi))

;; OBJECT: PART 1 - 10 pts
;;
;; For our scheme "object" let's create an object that "wraps" a
;; procedure for some additional capability.
;;
;; Write a procedure adjustable-proc, that is constructed with a
;; procedure that returns a number.  It returns a procedure "object"
;; that takes 2 commands:
;;
;; adjust: This command updates an internal field adjustment, which is
;; initially zero
;;
;; run: When this command is called, it executes the original proc
;; with the provided arguments and adds the current adjustment value
;; to the result.
;;
;; For example:
;;
;; (define a+ (adjustable-proc +))
;; (a+ 'run 10 20 30) ;; yields 60
;; (a+ 'adjust 0.1)
;; (a+ 'run 10 20 30) ;; yields 60.1
;; (a+ 'run 10 5) ;; yields 15.1
;; (a+ 'adjust -0.5)
;; (a+ 'run 10 20 30) ;; yields 59.5


(define adjustable-proc
  (lambda (proc)
    (nyi)))

;; OBJECT: PART 2 - 4 points
;;
;; Adjustable proc is good, but an adjustable proc isn't
;; interchangable with a regular proc (because it can't be run
;; directly, instead you have to say 'run).  Write a procedure
;; make-sneaky, that wraps an adjustable proc so it can be called like
;; the original proc.  Note that although it won't be possible to
;; change the adjustment on a "sneaky" proc, you can simply adjust the
;; non-sneaky version and the sneaky will naturally get the change as
;; well.  This example continues from above:
;;
;;
;; (define a+2 (make-sneaky a+))
;;
;; (a+2 4 5 6) ; yields 14.5
;; (a+ 'adjust 0) 
;; (a+2 4 5 6) ; yields 15

(define make-sneaky
  (lambda (proc)
    (nyi)))

;; FOLLOW THE GRAMMAR - 14 pts
;;
;; So a Lindenmayer system is a set of characters and expansion rules
;; often used to describe fractals.  Here's a BNF for a well known
;; one:
;;
;;  <frac> ::= ({<frac-entry>}*)
;;  <frac-entry> ::= A | B | <frac>
;;
;; In this systems, input is repeateadly transformed using
;; these rules:
;;
;; A -> A A
;; B -> A (B) B
;; The transformation of a list is just a transformation of its contents
;; 
;;
;; So a list like '(A B) would be transformed into '(A A A (B) B).  In
;; a normal L system, this would then be transformed into '(A A A A A
;; A ( A (B) B) A (B) B) and so on, but our code will only do one step
;; at a time.
;;
;; Write a procedure to do one step of the transformation.

(define expand-step
  (lambda (exp)
    'nyi))

;; METAFUNCTIONS - 14 pts
;;
;; One common kind of recursion is a numerical recursion where n
;; depends on the result of n-1 and so on all the way to 0 where there
;; a base case.  Let's write a numerical-recur, similar to list recur,
;; which makes it easy to write this kind of procedure.
;;
;; Numerical recur should take 2 arguments, a base value that is used
;; when the input is zero and a combine-proc that takes a number and
;; the value computed thus far.  It returns a new procedure that takes
;; a number and recusively calculates the result (i.e. the procedure
;; that numerical-recur generates is recursive, the combine-proc is
;; not recursive).

;; Here's my solution for sum-of-squares (i.e. calculate 1^2 + 2^2 +
;; 3^2 ... + n^2 for a given n)
;;
;; (define sum-squares (numerical-recur 0 (lambda (n agg) (+ (* n n) agg))))
;;
;; To calculate sum-squares 3, the given proc is called 3 times:
;; one time with 1 and 0, yielding 1
;; one time with 2 and 1, yielding 5
;; one time with 3 and 5, yielding 14

(define numerical-recur
  (lambda (zero-value combine-proc)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
