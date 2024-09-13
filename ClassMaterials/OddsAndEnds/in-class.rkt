
; simple
(define make-adder
  (lambda (n)
    (lambda (input)
      (+ n input))))

(define add2 (make-adder 2))
(define add3 (make-adder 3))

; Variation - adder or subtracter
;
; Write a function make-mather.  make-mather takes two parameters, an
; n and a boolean.  If the boolean is true, the produced procedure
; acts just like make-adder.  If the boolean is false, the produced
; function should subtract instead of adding.  HOWEVER the check to
; determine whether to add or subtract needs to happen when the
; function is created, not when the function is subsequently run.

(define make-mather
  (lambda (n bool)
    'nyi))

(define add4 (make-mather 4 #t))
(define sub4 (make-mather 4 #f))



; a little trickier
(define loudify-func
  (lambda (name func)
    (lambda arg-list
      (let ((result (apply func arg-list)))
        (display (list name " returns " result))
        result))))

(define loud+ (loudify-func "loud+" +))
      

; a list cleaner in a function that removes particular value
; from a list.  make-list-cleaner makes a cleaner for the given
; value  Hint: easiest with filter.

; (define remove-zeros (make-list-cleaner 0))
; (remove-zeros '(1 0 2 0 3)) => '(1 2 3)


(define make-list-cleaner
  (lambda (value-to-clean)
    'nyi))

(define remove-zeros (make-list-cleaner 0))
(define remove-qs (make-list-cleaner 'q))

; I find students occasionally pass an unreasonable number
; of parameters to functions.

; So I want to make new versions of functions that enforce
; limits.
;
; Write a function that given another function, returns a new
; function that acts like the original but returns 'unreasonable if
; more than 3 paramters are passed.
;
; (define limited+ (make-limited +))
; (limited+ 1 2) => 3
; (limited+ 10 20 30) => 60
; (limited+ 1 2 3 4) => 'unreasonable

(define make-limited
  (lambda (proc)
    'nyi))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Slightly more involved problem - stackable functions
;
;
; "stackable" functions operate on a single list and always
; return a pair.  Stackable functions expect to operate on lists
; of fixed size.
; 
; If the input list  is too small, they return '((error)).
;
; If the list is too large, they operate on the first however
; many elements they expect, and the return a pair with the result
; *as a list* in the car and the unused elements in the cdr.  
;
; If the list is  the perfect size, they return a pair with the
; result as list in the car and the empty list as the cdr.
;
; Here's an implementation of stackable plus, which expects lists
; of size 2.

(define st-plus
  (lambda (lst)
    (if (< (length lst) 2)
        '((error))
        (cons (list (+ (first lst) (second lst)) ) (cddr lst) ))))

; I suggest you play with st-plus a bit before you go forward
; to understand correct stackable function behavior
;
; (st-plus '(1 2)) => ((3))
; (st-plus '(1 2 3 4)) => ((3) 3 4)
; (st-plus '(1)) => ((error))

; Hand coding stackable functions is annoying.
; Write a function make-stackable which takes a ordinary
; function and a number of expected parameters, and returns
; a stackable version that expects those inputs as part of
; a list and returns the value according to the stackable
; rules above.
;
; Because there's no guarentee the function we're transforming
; returns a list, your transformer should wrap the result of your
; function call in a list.  This might be a little counter
; intuitive with functions like list that return a list.
;
; ((make-stackable list 2) '(1 2 3 4)) => (((1 2)) 3 4)
;
; You may find built in procedures take and drop useful here.
;                                        
; https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Flist..rkt%29._take%29%29
;                                         
; The next part of the problem is solvable without solving this
; one, if you get stuck.
(define make-stackable
  (lambda (proc param-num)
    'nyi))

;(define my-st-plus (make-stackable + 2)) ; uncomment this for hand testing if you like

; The stackable functions are built in the way they are so
; they can be easily combined (stacked).
;
; (stack f1 f2) where f1 and f2 are two stackable functions
; with sizes n and m will return a new stackable function
; with size n + m.
;
; applying this stackable function to a list will apply
; the first function the first n elements.  It will apply the
; second stackable function to the second m elments.  It will
; then append those results and that is the result of the overall
; function (goes in the car).  Any unused elements go in the cdr
; as usual.

; The cool part of these stackable functions is because the result
; of stack is itself stackable, we can use stack multiple times
; to build big aggregate functions.
;
;; ((stack st-plus st-plus) '(1 2 3 4 5)) => ((3 7) 5)
;; ((stack st-plus (stack st-plus st-plus)) '(1 2 3 4 5 6)) => ((3 7 11))
;;
;; One small edge case is errors.  Aggregate stack functions produce
;; multiple errors, one for each basic stack function.  If your implementation
;; is similar to mine, this will not require any special work
;;
;; ((stack st-plus (stack st-plus st-plus)) '(1 2 3)) => ((3 error error)) 

(define stack
  (lambda (f1 f2)
    'nyi))
