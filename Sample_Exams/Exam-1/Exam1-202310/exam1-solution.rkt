#lang racket
(require racket/trace)

(provide most-common-thing just-lists make-bst-iterator is-shadowed? make-stackable stack)

; QUESTION 1: Most Common Thing
;
; This function takes a list of a mix of symbols and numbers.
; If numbers are more common that symbols, the function returns
; 'numbers.  If symbols are more common, the function returns
; 'symbols.  If they are equally common, the function returns
; 'neither.
;
; (most-common-thing '(a 1 b)) => 'symbols

(define most-common-thing
  (lambda (lst)
    (let recurse ((sym 0) (num 0) (lst lst))
      (cond
        [(null? lst) (if (eq? sym num) 'neither (if (> sym num) 'symbols 'numbers))]
        [(symbol? (car lst)) (recurse (add1 sym) num (cdr lst))]
        [else (recurse sym (add1 num) (cdr lst))]))))

; QUESTION 2: Just lists
;
; This function takes in lists and values that can be nested
; to an arbitrary depth.  The function removes all values,
; keeping the nesting of the lists intact.
;
; (just-lists '((b) a (c))) => (()())

(define just-lists
  (lambda (lst)
    (cond
      [(null? lst) '()]
      [(list? (car lst)) (cons (just-lists (car lst)) (just-lists (cdr lst)))]
      [else (just-lists (cdr lst))])))

; QUESTION 3: BST Iterator
;
; This function is about creating an iterator for a Binary Search Tree.
; We'll use the definition of BST from earlier
;
; BST ::= () | (<number> <BST> <BST>)
;
; Our iterator mantains a position in our traversal of a BST, starting
; at the head.
;
; (define t1 (make-bst-iterator '(4 (2 () ()) (5 () ()))))
; (t1 'value) ; yields 4
; (t1 'left)  ; moves position, doesn't return anything
; (t1 'value) ; yields 2
;
; if value is called on any empty tree, it should return '()
;
; You don't have to worry about he behavior of left or right on an empty tree.
;
; For the first half of the points, you need to support
; operations 'value 'left and 'right.
;
; For the second half of the points, you need to support
; an operation 'up .  Up you will require you to store
; some extra data.  It is OK if the iterator potentially stores
; a lot more data than the original tree.
;
; (define t2 (make-bst-iterator '(4 (2 (1 () ()) ()) (5 () ()))))
; (t2 'left)
; (t2 'left)
; (t2 'value) ; yields 1
; (t2 'up)
; (t2 'up)
; (t2 'right)
; (t2 'value) ; yields 5
;
; You don't have to worry what will happen if you call 'up' on the original tree
(define make-bst-iterator
  (lambda (bst)
    (let ((ups '()))
      (lambda (command)
        (case command
          [(value) (if (null? bst) '() (first bst))]
          [(left)
           (set! ups (cons bst ups))
           (set! bst (second bst))]
          [(right)
           (set! ups (cons bst ups))
           (set! bst (third bst))]
          [(up)
           (set! bst (car ups))
           (set! ups (cdr ups))]
          )))))

(define t1 (make-bst-iterator '(4 (2 () ()) (5 () ())))) 
        
; QUESTION 4
;
; This question will use our definition of the lambda
; calculus.
;
; LcExp ::= <identifier> |
;           (lambda (<identifier>) LcExp) |
;           (LcExp LcExp)
;
; We'll define "shadowing" as occuring when a lambda
; expression uses a name that is already bound (or, more precisely
; the name used in the lambda would be considered "bound" if it
; occured as an identifier at that position in the expression).
;
; For example:
;
; (lambda (y) (lambda (x) y)) ; no shadowing
; (lambda (x) (lambda (x) y)) ; x shadows existing x
;
; the definition of x in the inner lambda "hides" or
; "shadows" the other meaning of x.
;
; In this case:
;
; ((lambda (x) y) (lambda (x) y))
;
; No shadowning occurs because although x is used in two
; places, in each case x would be free if it occured where
; the lambdas bind x.  Put another way, no definition of x
; occurs within the context of an existing definition of x.
;
; To make our idea of shadowing formal.  A variable x can
; be considered shadowed in an lc-exp iff:
;
; A.  If lc-exp is a variable expression x is not shadowed
; B.  If lc-exp is a abstraction expression (lambda (y) e')
;     x is shadowed if:
;     x is shadowed in e'
;     OR y matches x and an expression (lambda (x) e'') occurs
;        in some subexpression of e'
; C.  If lc-exp is a application expression (e1 e2)
;      x is shadowed if x is shadowed in e1
;                    OR x is shadowed in e2
      

(define is-shadowed?
  (lambda (var lc-exp)
    (let recurse ((lc-exp lc-exp) (bound #f))
      (cond [(symbol? lc-exp) #f]
            [(eqv? 'lambda (car lc-exp))
             (or (and bound
                      (eqv? (caadr lc-exp) var))
                 (and (eqv? (caadr lc-exp) var)
                      (recurse (caddr lc-exp) #t))
                 (recurse (caddr lc-exp) bound))]
            [else (or (recurse (first lc-exp) bound)
                      (recurse (second lc-exp) bound))]))))
            
                               
                 
; QUESTION 5
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
;
; You may find built in procedures stack and drop useful here.
;
; The next part of the problem is solvable without solving this
; one, if you get stuck.
(define make-stackable
  (lambda (proc param-num)
    (lambda (lst)
      (if (< (length lst) param-num)
          '((error))
          (cons (list (apply proc (take lst param-num)))
                (drop lst param-num))))))

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
; of stack is itself stackable, we can us stack multiple times
; to build big aggregate functions.

(define stack
  (lambda (f1 f2)
    (lambda (lst)
      (let* ([f1result (f1 lst)]
             [f2result (f2 (cdr f1result))])
        (cons (append (car f1result) (car f2result)) (cdr f2result))))))

(define st-add-pairs (stack st-plus st-plus))
        
        