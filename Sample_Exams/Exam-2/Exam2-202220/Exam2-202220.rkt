#lang racket

(require "../chez-init.rkt")

(provide combine-consec combine-consec-helper-cps or= eval-one-exp)

;; QUESTION 1 CPS

;; Below I've provided my solution to combine-conseq.  Most of the work
;; is actually done in a helper function - combine-consec-helper.  Convert
;; the helper to continuation passing style using the lambda style of
;; continuations.

;; To remind you, here's the description of combine-conseq

;; ;; combine-consec takes a *sorted* list of integers and combines them
;; ;; into a series of ranges.  It compresses sequences of consecutive
;; ;; numbers into ranges - so for example the list (1 2 3 4) becomes ((1
;; ;; 4)) representing the single range 1-4.  However, when numbers are
;; ;; missing then there must be multiple ranges - e.g. (1 2 3 6 7 8)
;; ;; becomes ((1 3) (6 8)) representing 1-3,6-8.  If a number is by
;; ;; itself (i.e. it is not consecutive with either its successor or
;; ;; predecessor) it can be in a range by itself so (1 2 4 7) becomes
;; ;; ((1 2) (4 4) (7 7)).

;-----------------------------------------------
; CONTINUATIONS REPRESENTED BY SCHEME PROCEDURES
;-----------------------------------------------

(define apply-k
  (lambda (k v)
    (k v)))

(define make-k    ; lambda is the "real" continuation 
  (lambda (v) v)) ; constructor here.


(define (combine-consec-helper-old first last lst)
  (cond [(null? lst) (list (list first last))]
        [(= (add1 last) (car lst))
         (combine-consec-helper-old first (add1 last) (cdr lst))]
        [else (cons (list first last) (combine-consec-helper-old (car lst) (car lst) (cdr lst)))]))

(define (combine-consec-old lst)
  (if (null? lst) '() (combine-consec-helper-old (car lst) (car lst) (cdr lst))))

;; this function is not in CPS but it invokes the cps helper you'll write
;; You don't need to convert it to CPS
(define (combine-consec lst)
  (if (null? lst) '() (combine-consec-helper-cps (car lst) (car lst) (cdr lst) (lambda (x) x))))

;; null? list car add1 = cons cdr make-k can be considered to be non-substantial
;; combine-consec-helper-cps and apply-k are substantial

(define (combine-consec-helper-cps first last lst k)
  (nyi))


;; QUESTION 2 or=
;;
;; Define a new syntax or=.  or= tests one value against a set of
;; other values and returns true if the first value matches any of
;; the second.  For example:
;;
;; (define somevar ?????)
;; (or= somevar 1 2 3) returns #t if somevar is 1 2 or 3 #f otherwise
;;
;; A few requirements:
;;
;; A.
;; or= must use short circuting.  That is it must stop testing if it finds
;; a match.  So this:
;; 
;; (or= 1 1 (display "hello") 2) does not display hello
;; but (or= 2 1 (display "hello") 2) does display hello
;;
;; This means this feature can only be accomplished with define-syntax and
;; not a function call.
;;
;; B.
;; Any of the expressions in or= can be complex
;; (or= (+ 1 2) (+ 3 4) (+ 5 6)) is legal
;;
;; However, you can safely repeatedly execute the first expression (e.g. (+ 1 2) can
;; be evaluated more than once)
;;
;; C. Compare the values with eq?

; I have created this little define for or= so that the tests can run initially
; however, delete this and replace it with (define-syntax or= *your code*)
(define or=
  (lambda q (nyi)))

    
;; QUESTION 3 myforeach

;; This is a problem that requires you to modify your interpreter.
;;
;; cut and paste your interpreter code at the bottom of this file

;; Use syntax-expand to implement a command called myforeach that acts
;; a little like map, but a bit more convenient to use
;;
;; (let ((mylist '(1 2 3))) (myforeach val mylist (+ 1 val))) => (2 3 4)
;;
;; The first parameter of myforeach is a symbol called varname.
;; The second is a scheme expression that evaluates to a list.  The third
;; is a scheme expression called body that uses varname as a var-exp.
;;
;; myforeach should execute the body n times, where n is the number of the
;; elements in the list.  Each time it executes the body, varname should be
;; mapped to a particular value in the list.  The result of the expression
;; is a new list, which each element being the result of evaluating the
;; body.
;;
;; This is most easily accomplished by expanding the given syntax into an
;; expression that uses map and lambda.
;;
;; (myforeach x '(1 2) (+ x 1)) => (map (lambda (x) (+ x 1)) '(1 2))
;;
;; You are required to implement this problem using syntax-expand (and parse-exp).
;; You should not need to make any changes to eval-exp to get this feature to work.
;;
;; HINT: This may be a little obvious but it is usually wrong to eval-exp from within
;; syntax-expand.  Syntax expansion should procceed evaluation.

; I've included this little function to make the test cases pass initially.
; delete it once your paste in your interpreter.
(define eval-one-exp
  (lambda (x) (nyi)))

;; QUESTION 4 outer
;;
;; So when a new binding re-binds an existing variable, in standard scheme
;; there is no way to recover the old binding.  For example:
;;
;; (let ((x 'coolval)) (let ((x 7)) code)) ; there's no way to discover coolval from code
;;
;; Let's fix that.  Add a new scheme syntax outer that allows you to get an outer
;; variable mapping.
;;
;; (let ((x 'coolval)) (let ((x 7)) (outer x))) ; evalutes to coolval
;;
;; We'll even make it possible to get more outer mappings by saying outer more times
;;
;; (let ((x 1)) (let ((x 2)) (let ((x 3)) (outer outer x)))) ; yields 1
;;
;; HINT: because we don't have to worry about invalid inputs you can look at the
;; length of the outer expression to determine how many outers there are
;;
;; So the number of outer corresponds to to the number of bindings not the number
;; of environments
;;
;; (let ((x 1)) (let ((x 2)) (let ((y 3)) (outer x))))
;;   ; yields 1, because x is not bound in innermost environment
;;
;; Outer should also work with global mappings:
;; (let ((+ *)) ((outer +) 1 5))) ; yields 6
;;
;; Outer should error if the variable is not mapped that deeply
;; (let ((x 'coolval)) (let ((x 7)) (outer outer x)))
;; test cases do not test for this however

;; Notes:
;; This does not need to work with letrec, if your interpreter supports letrec
;;
;; This does not need to work with set! if your interpreter supports it



;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
