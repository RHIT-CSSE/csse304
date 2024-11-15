#lang racket

(require "../chez-init.rkt")

(provide myloop eval-one-exp letset-type)

;---------------------|
;                     |
; Macro  25 points    |
;                     |
;---------------------|

;; Write a macro "myloop" which is a regular loop with a conditional,
;; when true, leaves the loop by invoking a continuation.  The syntax
;; of "myloop" is as follows: (myloop termination-exp terminal-exp
;; continuation bodies) where when the termination-exp is true, the
;; terminal-exp is passed to the continutation. The termination-exp
;; condition is evaluated first. If the terminal condition is not true
;; then the bodies are evaluated.
;;
;;
;; Here's a example of the basic idea:
;;
;;  (call/cc (lambda (k)
;;             (let ((loop-count 0))
;;               (myloop (= loop-count 3) ; <- the test we run on every loop
;;                       (+ loop-count 100); <- code we'll run and pass to the continuation on finish
;;                       k ; <- the continuation to call on finish, you can assume its a basic variable
;;                       (printf "hello ~s of 3~n" loop-count) ; <- loop bodies begin here
;;                       (set! loop-count (add1 loop-count)))
;;               (printf "does not print because myloop applys k when finished~n"))))
;;
;; This code evalutes to 103 after printing hello 3 times.
;;
;; Below are some more examples of how we will test this code:
;;  
;; (call/cc (lambda (k) (myloop #t 42 k 7)))  -> 42
;; (call/cc (lambda (k) (let ([n 3]) (myloop (= n 0) n k (set! n (- n 1))))))  -> 0
;;
;; More examples in the test cases
;;
;; Hint: you could use continuations to make the loop work, but it's
;; not necessary.  You may use named let, letrec, but not any looping
;; constructs we did not discuss in the course.
;;
;; Macro questions have a tendency to cause the whole file to fail if
;; they are buggy.  If your solution ends up like this please leave it
;; commented out and use the starting code so that the other tests can
;; run.  We will consider your commented out code for partial credit.
;;
;; Copy of the starting code in case you need to revert to it
;;
;;  (define-syntax (myloop stx)
;;    (syntax-case stx ()
;;      ; this case below is not one you wanna use
;;      ; it's here to prevent the tests from crashing
;;      [(myloop _ ...) #'(quote nyi)]
;;      ))


(define-syntax (myloop stx)
  (syntax-case stx ()
    ; this case below is not one you wanna use
    ; it's here to prevent the tests from crashing
    [(myloop _ ...) #'(quote nyi)]
    ))


;---------------------|
;                     |
; Typing  25 points   |
;                     |
;---------------------|


;; Consider this small subset of scheme:
;;
;; letset-exp  := <boolean> |
;;                <number> |
;;                <symbol> |
;;                (set! <symbol> <letset-exp>)
;;                (let ({(<symbol> <letset-exp>)}+) {<letset-exp>}+)
;;
;; The symbol variant is a var expression.  The var expression's type
;; is the type of the variable's initialiazation.
;;
;; The let expression acts as normal in scheme (note that it supports
;; multiple variables and multiple bodies).  It cannot be used for
;; recursion (i.e. it acts like a regular let, not a letrec).  A let
;; expressions type is the type of its final body expression.
;;
;; The set! expression acts as normal in scheme except it respects the
;; type constraints noted below.  A set expression returns void which
;; is of void type.
;;
;; There are 3 types in this language 'bool 'num and 'void.
;;
;; In this language variables are implicitly given a type when they
;; are initialized in a let (e.g. a variable initialized with a
;; boolean expression is a boolean).  Once initialized their type is
;; fixed.  If they are later set! with an inappripiate type, the
;; typechecker should error with (raise 'bad-set).  For
;; example:
;;  
;;  (let ((x #f) (y 1))
;;    (set! y 3) ; fine, y is a number variable
;;    (set! x 3) ; error, x is a boolean variable
;;    x) 
;;  
;; Note that there can be distinct variables with the same name in
;; different lets, and these same-named variables can have different
;; types.
;;  
;;  (let ((x #f))
;;    (let ((x 3))
;;      (set! x 5)) ; fine
;;    (set! x #t) ; also fine
;;    x) ; overall expression type bool
;;  
;; The only other typecheck error supported is (raise
;; 'unknown-variable) when a variable is used with no enclosing let.
;; For example:
;;  
;;  (let ((x 3))
;;    (let ((y 4))
;;      y)
;;    y) ; error!
;;
;; Write letset-type which returns the type of a given letset
;; expression or errors if there is a typecheck error.  NOTE: you need
;; to represent a type envrionemnt to solve this problem.  Feel free
;; to repurpose one from your interpreter (but be sure to give it a
;; new datatype name otherwise you'll get conflicts in the final
;; question) or some other prior work.

(define letset-type
  (lambda (exp)
    'nyi))

;-----------------------|
;                       |
; Interpreter 25 points |
;                       |
;-----------------------|


;; For this problem, we're going to implement a simple dictionary in
;; our scheme (also called HashMaps, associative arrays, many other
;; things).  In this case, you make a dictionary like this:

;; (make-dict (a 1) (b (+ 2 10)))

;; This makes a dictionary that associates the value a with 1 and b
;; with 12.  Any number of key/values are allowed.  The keys are
;; always ordinary symbols and the keys are not repeated.  The values
;; can be arbitrary expressions (that are evalued when make-dict is
;; evaluated).  The exact type that is returned from make-dict is up
;; to you - it is not tested directly.  If you'd like it to be racket
;; Hash Tables or some object of your own design that is fine.
;;
;; To read the value of a particular dictionary key you use get-dict:
;;
;; (get-dict (make-dict (a 1) (b 2)) b) ; yields 2
;;
;; The first parameter of make-dict can be any expression that results
;; in a dictionary.  The second parameter is always a symbol.
;;
;; To write the value of a dictionary key use set-dict!
;;
;; (let ((d (make-dict (a 1) (b 2))))
;;   (set-dict! d b 3)
;;   (get-dict d b)) ; yields 3
;;
;; set-dict!'s first parameter is a expression that results in a
;; dictionary.  Second is a symbol.  Third is an expression for the
;; value to be stored.  set-dict! only works with a symbol that
;; already exists in the dictionary (i.e. it can't add new keys) but
;; your implementation is not required to enforce this rule.
;; set-dict! should return void.

;; paste your interpreter here
(define eval-one-exp
  (lambda (x) 'nyi))

      
  
