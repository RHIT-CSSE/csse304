#lang racket
(provide eval-one-exp)

;; So in this question, we're going to add a new type to your scheme that represents
;; a point (i.e. something with an x and y coordinate).
;;
;; Points will be created like this (make-point 1 2).  A point will be an abstract
;; data type insofar as I leave it up to you how to represent them internally and
;; I won't mandate what they display like if they are the result of an expression.
;;
;; However, we will access them through a special syntax.  If a point is in a
;; variable, you can access them with a "dot" notation.
;;
;; (let ((p (make-point 1 2))) p.x)) ; returns 1
;; (let ((p (make-point 1 2))) p.y)) ; returns 2
;;
;; Note that p.x is a ordinary symbol in standard scheme, but in our scheme
;; symbols of this sort will have a special meanings.  Your scheme is no
;; longer required to support ordinary symbols with dots anymore - instead
;; any dots appearing in symbols will be assumed to be indicating these
;; special point notation expressions.

;; To help with that I've implemented 3 functions for you (below)
;;
;; has-dot? - returns true if a given symbol has a dot
;; pre-dot - returns a symbol that represents the part of the symbol before a dot
;; post-dot - returns a symbol that represents the part of the symbol after a dot
;;
;; For example (pre-dot 'foo.x) yields the symbol 'x


;; Note that the dot notation only applies to variables, it can't be used by itself.
;;
;; (make-point 1 2).x   ; THIS IS ILLEGAL
;;
;; Points must be stored in variables to access their members (if this was a feature
;; we were actually going to use post exam we might add other ways to do it, but
;; for now I'm keeping it simple).  Of course point objects can be stored in vectors
;; lists - anyplace ordinary scheme values can be stored.  But before you can access
;; their x y coordinates, the requirement is you use let (or lambda) to make a
;; variable expression that has the point you want to access in it.  For example:

;; (let ((point-list (list (make-point 1 2) (make-point 3 4))))
;;  ...maybe some other code here...
;;  (let (p1 ((car point-list)))
;;    (display p1.x)) ; can't get the x without storing the car in a variable

;; This should be enough for the first group of tests.

;; You are also required to make the point notation work with set!
;;
;; (let ((p (make-point 1 2))) (set! p.x 99) p.x) ; returns 99
;;
;; Again, the point must always be in a variable before it can be set.
;;
;; Also, the meaning of this set operation is more like set-car! set-cdr!
;; than normal set!.  Our set will modify the internals the point meaning
;; that this:
;;
;; (let ((p (make-point 1 2))) (let ((p2 p)) (set! p2.y 300) p.y)))
;;
;; returns 300
;;
;; Setting points should work with both local bindings and global bindings.
;;
;; This should work for the second set of tests.

(define has-dot?
  (lambda (sym)
    (member #\. (string->list (symbol->string sym)))))

(define dottedsym->pair
  (lambda (sym)
    (let ((lst (string->list (symbol->string sym)))
          (list->symbol (lambda (lst) (string->symbol (list->string lst)))))
      (let loop ((pre-dot '()) (post-dot lst))
        (if (eq? (car post-dot) #\.)
            (cons (list->symbol (reverse pre-dot))
                  (list->symbol (cdr post-dot)))
            (loop  (cons (car post-dot) pre-dot) (cdr post-dot)))))))
          
(define pre-dot
  (lambda (sym)
    (car (dottedsym->pair sym))))

(define post-dot
  (lambda (sym)
    (cdr (dottedsym->pair sym))))


(define eval-one-exp
  (lambda (exp)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))

