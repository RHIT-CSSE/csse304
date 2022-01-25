;; CSSE 304 Exam #2  Oct 27, 2021

;; You may use your notes, Chez Scheme, the three textbooks from the
;; course, The Chez Scheme Users' Guide, documentation for any other
;; Scheme interpreter, any materials that I provided online for the
;; course.  You may do internet searches for built-in Scheme procedures,
;; but not for the particular problems that you are solving.  You may not
;; use any other web or network resources, or programs written by
;; other (past or present) students.  You are allowed use any code that
;; you have previously written. You may assume that all of your
;; procedures' input arguments have the correct types and values, your
;; code does not need to check for illegal input data.

;; Mutation is not allowed unless I state otherwise for a particular
;; problem.  Efficiency and elegance will not affect your score as long
;; as you do what the problem specifies.  Be careful not to use so much
;; time on one problem that you do not get to work on other problems

;; Tests for this code are provided in exam2-tests.ss.  Please check
;; the tests if you'd like additional examples of how the given
;; features function.

;; -------------------------------------------------------------------

;; C1. (20 points) remove depth cps

;; -------------------------------------------------------------------

;; I have provided a solution to the Exam 1 computer problem
;; remove-depth.  To refresh your memory, here is the definition of
;; remove depth from Exam 1:

;; ;; Write a procedure that takes a integer depth and an slist.  The
;; ;; function returns a new slist where all nodes of a given depth have
;; ;; been "flattened" into their parent.  Nodes above/below the given
;; ;; depth are not flattend.  Note that other than this flattening, the
;; ;; slist remains in the same order it was.
;; ;;
;; ;; Examples:
;; ;; > (remove-depth 2 '(a (b c) d))
;; ;; (a b c d)
;; ;; > (remove-depth 2 '(a (b (c)) d))
;; ;; (a b (c) d)
;; ;; > (remove-depth 3 '(a (b (c)) d))
;; ;; (a (b c) d)

;; Convert this solution to contiuation passing style, using the scheme
;; procedure representation of continations.  Please use make-k and
;; apply-k in your solution to make your creation and invokation of
;; continations explicit.

;; I have provded a cps version of append that you should use.  You may
;; assume that null? car symbol? = cons make-k sub1 and cdr are not
;; substantial.  Calls to apply-k append-cps and remove-depth-cps
;; should (of course) be considered substantial.

(define apply-k
  (lambda (k v)
    (k v)))

(define make-k    ; lambda is the "real" continuation 
  (lambda (v) v)) ; constructor here.

;; my functioning CPS version of append
;; only works for 2 parameters but that's all we need here
(define (append-cps l1 l2 k)
  (if (null? l1)
      (apply-k k l2)
      (append-cps (cdr l1) l2 (make-k (lambda (appended-cdr)
                                        (apply-k k (cons (car l1) appended-cdr)))))))


;; my solution for remove depth.  You are required to convert this
;; function - not a different solution of your own design.
;;
;; I've named this remove-depth-example so hopefully you will not accidentally call it
;; from you CPS solution - of course that would be wrong.
(define (remove-depth-example depth slist)
  (if (null? slist)
      '()
      (let ((recurse (remove-depth-example depth (cdr slist))))
        (if (symbol? (car slist))
            (cons (car slist) recurse)
            (if (= depth 2)
                (append (car slist) recurse)
                (cons (remove-depth-example (sub1 depth) (car slist)) recurse))))))


(define remove-depth-cps
  (lambda (depth slist k)
    'your-solution-here))


;; -------------------------------------------------------------------

;; C2. (20 points) swap!

;; -------------------------------------------------------------------

;; Use define-syntax to create a scheme syntax called swap!.  swap!
;; takes two scheme variables (could be local definitions created with
;; let or global definitions created with define) and swaps their values.

;; Mutation is allowed.

;; Example:

;; (let ((x 1) (y 2)) (swap! x y) (list x y)) ; yields (2 1)


;; This is an obscure point but just in case you are worried - you don't
;; need to be concered that variable bindings created within your syntax
;; will shadow variables outside it.  

;; put your call to define syntax here

;; be aware that if you change your define syntax, you must reload the
;; test cases for your changes to take effect.

;; -------------------------------------------------------------------

;; C3. (20 points) simplecase

;; -------------------------------------------------------------------

;; I'd like you to add a new syntax to your 304 scheme interprerter.
;; You can use A15 or A16 as your starting point.  It is called
;; simplecase and here is an example:

;; (simplecase my-symbol
;;             (a 1)
;;             (b (+ 0 2))
;;             (c 3))

;; if my-symbol is 'a the expression evalutes to 1, etc.

;; Abstractly:

;; (simplecase *test-exp*
;;             (*symbol1* *body1*)
;;             (*symbol2* *body2*)
;;             ...
;;             (*symboln* *bodyn*))

;; test-exp is a expression that should evaluate to a symbol.  The
;; symbol1-symboln are symbols (NOTE how that they are implicitly symbols
;; - no use of quote is required here).  If the test-exp symbol matches
;; one of the symbols in the list, the corresponding body is
;; executed (note: only 1 body expression is allowed, not multiple
;; bodies).  If no symbol matches, the expression returns void (i.e. like
;; a single-tailed if that evalutes to false).  Symbols should be
;; compared with eqv?.

;; You are required to add this feature strictly through
;; syntax-expansion (i.e. it should be parsed in parsed-exp but then it
;; should not be in eval-exp, because it is replaced with core syntax in
;; your expand-exp).

;; Note that you do not have to worry about the behavior if the *test-exp*
;; has some sort of side effect.  You can safely execute that expression
;; once for each comparsion you need to do.

;; -------------------------------------------------------------------

;; C4. (20 points) namespaces

;; -------------------------------------------------------------------

;; I'd like you to add new syntax to your 304 interpreter.  You can
;; use A15 or A16 as your starting point so long as lets function
;; correctly.  You are not required to make this functionality work
;; correctly in conjunction with define and set!.  You also don't need
;; to include the functionality of C3 - but these are pretty unrelated
;; problems so it probably wouldn't matter.  This feature will require
;; changes in eval-exp (among other places).

;; This syntax has two structures, make-namespace and use-namespace.
;;
;; Here's an example -- this example returns 1:

;;	      (let ((a 99)
;;                  (ns1 (make-namespace ((a 1))))
;;                  (ns2 (make-namespace ((a 10) (b 20)))))
;;                (use-namespace ns1 a))

;; make-namespace is structurally sort of like let (without the
;; bodies) but it doesn't bind values.  Insteads it creates "namespace
;; object".  This object can be anything you want - users are required
;; to treat it as an abstract datatype (i.e. they shouldn't use it
;; except through use-namespace) but the object can be stored as an
;; ordinary value.  Later, a created namespace object can be used as
;; the first parameter of use-namespace.  The first expression of a
;; use-namespace command should always produce a namespace object.
;; This "maps" that particular namespace within the "body" of the
;; use-namespace (i.e. the 2nd expression).

;; In the 2nd expression of use-namespace, the values of the namespace
;; are mapped to what was set at the time the namespace was created:
;; they are added to the local environment as if set in a let.  Hence
;; they can override other variables in the local environment (and be
;; overidden if the 2nd expression itself contains lets or similar
;; features).
;;
;; Note that for your convenience, use-namespace only has a single
;; body expression (not an arbitrary number of bodies).
