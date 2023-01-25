#lang racket

(require "../chez-init.rkt")
(require racket/trace)
(provide myfor eval-one-exp init-k list-k slist-subst-datatype)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Question 1 - CPS Conversion (datatype)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; So in this problem we're going considering a slist-subst
;; slist-subst takes an slist old value and new value.  It returns a
;; new slist with all instances of of the old value replaced with the
;; new value.
;;
;; (slist-subst '((a b) a) 'a 'q) => '((q b) q)
;;
;; Here is my solution for this problem (not that you should need this
;; directly:
;;
;; (define slist-subst-orig
;;  (lambda (slist old new)
;;    (cond [(null? slist) '()]
;;          [(symbol? (car slist))
;;           (cons (if (eqv? (car slist) old) new (car slist))
;;                 (slist-subst-orig (cdr slist) old new))]
;;          [else (cons (slist-subst-orig (car slist) old new)
;;                      (slist-subst-orig (cdr slist) old new))])))
;;
;; Here's that code converted to lambda style cps:

(define apply-k-lam
  (lambda (k v)
    (k v)))

(define make-k    ; lambda is the "real" continuation 
  (lambda (v) v)) ; constructor here.

;; I'm leaving this code commented out so you don't accidentally call it.  But if you want to uncomment it, fine.
;;
;; (define slist-subst-cps
;;   (lambda (slist old new k)
;;     (cond [(null? slist) (apply-k-lam k '())]
;;           [(symbol? (car slist))
;;            (slist-subst-cps (cdr slist) old new (make-k
;;                                                  (lambda (recur-cdr)
;;                                                    (apply-k-lam k (cons (if (eqv? (car slist) old) new (car slist)) recur-cdr)))))]                
;;           [else (slist-subst-cps (car slist) old new (make-k
;;                                                        (lambda (recur-car)
;;                                                          (slist-subst-cps (cdr slist) old new (make-k (lambda (recur-cdr)
;;                                                                                                          (apply-k-lam k (cons recur-car recur-cdr))))))))])))
;;
;; Take this lambda style cps code and convert it to datastructure style cps code.
;;
;; To help you I've already started the continuation datatype and
;; apply-k.  You'll need to expand these provided functions but do no
;; modify what I've provided as they're used in the test cases.

(define-datatype continuation continuation?
  [init-k]
  [list-k]
  ;more types here
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
      [init-k () v]
      [list-k () (list v)]
      ;more cases here
      )))

(define slist-subst-datatype
  (lambda (slist old new k)
    'nyi))
                                                                  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Question 2 - Define syntax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use define syntax to implement scheme version of a for loop called myfor.
;;
;; It works like this:
;; (myfor i 1 to 3 (display i) (display "! ")) ; displays 1! 2! 3!  
;;
;; Guidelines:
;;
;; The first parameter to myfor is expected to be a variable name.
;; That variable is bound to the iteration number in the bodies of the
;; the loop.
;;
;; The X to Y part expects to 2 numbers.  Y is assumed to be larger
;; than X.  The range is inclusive (i.e. there will be a loop where
;; the variable equals Y).  The loop will start with the variable at X
;; and increase by one each iteration till the variable equals Y.
;;
;; The loop can have one or more bodies.  The bodies are executed in
;; sequence once for each value of the variable.
;;
;; I do not have a requirement for what a myfor expression returns
;; after the looping is done (my version happens to return the final
;; value of i).
;;
;; In implementing this do not use the build-in racket for loop (it
;; exists, but again don't use it) or any other weird scheme looping
;; construct we haven't discussed in class.  Hint: I suggest named
;; let.

; you will have to delete this to make the define syntax wrok
(define myfor
  (lambda args
  'nyi))

;(define-syntax myfor
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Question 3 - qlet (expand syntax question)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; So in this problem you'll implement something called quick let
;; (qlet).  It looks like this:

;; (qlet (qset x 1)
;;       (display "hello")
;;       (qset y 2)
;;       (+ x y))
;;
;; qlet works a lot like let* except the assignments and the values
;; can be intersperced.  The qset expressions that do the assignment
;; are only allowed to be directly under a qlet.  Something like this
;; is *not* legal: (qlet (if mybool (qset x 3) (qset x 4) x).  Its up
;; to you if you want to consider qsets to be another kind of
;; expression type or not.  One qset can only do one assignment -
;; variable name, initialization expression.  Variables bound by a
;; qset are only bound below their assignment (e.g. it would not be
;; legal to have (display y) instead of (display "hello") above.
;;
;; In a qlet, only qset has special meaning - any other subexpressions
;; are treated as bodies.  The value of the qlet is the value of its
;; last body.  You do not need to worry about what to do if a qlet
;; terminates with a qset.
;;
;; Modify your interpreter to add this feature.  This feature is able
;; to be implemnted entirely using expand syntax - please do not add
;; support for this feature in eval-exp.  Although this feature uses a
;; name qset, there are many solutions that do not require the use of
;; set!.  However, if your interpreter supports set! you can use it.

;; delete this eval-one-exp function and replace it with your interpreter
;; code. Note its  easier if you can make a single interpter support both
;; Q3 and Q4.  But if one solution doesn't work in a catastropic way but you still
;; want to submit it for partial credit, submit that as a seperate
;; file.

(define eval-one-exp
  (lambda (exp)
    'nyi))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Question 4 - var prefix (general interpreter question)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; NOTE WHEN I GAVE THIS EXAM THIS PROBLEM TURNED OUT TO BE A LITTLE TOO HARD
;; SO I PROBABLY WONT DO SOMETHING THIS HARD ON YOUR EXAM

;; So imagine we have a system for variables where long names indicate
;; something like libraries.  For example a function in library A
;; might be called LibraryA-coolfunc.  This might be good for various
;; reasons but obviously having a long names can be annoying.  So
;; hence the idea of a var-prefix.  var-prefix takes two parameters a
;; symbolic prefix name and an expression.

;; (let ((libraryA-coolfunc something)) (var-prefix libraryA- (coolfunc 1 2 3)))

;; Conceptually var-prefix takes all bindings that exist at the
;; var-prefix statement and remaps any that begin with the prefix to
;; also exist without the prefix.  That's conceptually how it works
;; but its not how you're required to implement it.

;; The expression within var prefix can be as complex as you want and
;; can use multiple prefixed variables and non-prefixed variables.

;; (let ((aax 1) (aay 2) (z 3)) (var-prefix aa (let ((w 4)) (+ x y z w))))

;; Note that var prefix does not affect variables within the prefix
;; expression, only those declared outside the expression (local or
;; global).
;;
;; (var-prefix aa (let ((aax 1)) x)) ; ERROR!

;; You can have multiple prefixes but they are not required to
;; interact with each other.
;;
;; This should work:

;; (let ((aax 1) (bby 2)) (var-prefix aa (var-prefix bb (+ x y))))

;; ...but if there was a mapping "aabbz" that would not need to be
;; mapped to "z".  Though it would be OK if it did.

;; To allow large number of possible solutions, I'm going to
;; completely ignore any sort of precidence behavior (i.e. what
;; happens if there is an x in scope and then var-prefix maps aax to x
;; as well).  None of the test cases use var-prefix in any context
;; where there are more that one variable with the same mapping.

;; To help you, here are two functions that maniplate symbols in ways you might find useful.

;; appends 2 symbols together into 1 symbol
(define append-sym
  (lambda (sym1 sym2)
    (string->symbol (string-append (symbol->string sym1) (symbol->string sym2)))))

;; determines if symbol is a prefix of another symbol (note argument order)
(define sym-prefix?
  (lambda (symbol possible-prefix-sym)
    (string-prefix? (symbol->string symbol) (symbol->string possible-prefix-sym))))


;; The test cases for this code occasioncally want to test code that
;; should produce unmapped variables.  To allow those test cases to be
;; simple, please modify your interpreter so that when a variable is
;; accessed but not mapped, it errors like this (raise 'missing-var).
;; So for example this expression should call (raise 'missing-var) to
;; signal x is not mapped: (let ((prefix-x 1)) x)).  Your interpreter
;; should only error in this way for unmapped variables.  Look in the
;; test cases for "expect-error" to see code that should fail in this
;; way.

