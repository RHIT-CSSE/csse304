#lang racket
(require "../chez-init.rkt")
(require racket/trace)

(provide list-k combine-to-target-cps init-k all-equal eval-one-exp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; QUESTION 1 CPS CONVERSION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Below is my solution to combine-to-target from Exam1.  To remind
;; you of this problem, here's the description:
;;
;;     Write a procedure that determines if some combination of prefixes
;;     and suffixes can produce a target list.  You will be given a list
;;     called target, and two lists of lists called prefixes and suffixes.
;;     If a combination of one prefix list and one suffix list can produce
;;     the target list, you should return the prefix list.  If no
;;     combination of prefix list and suffix list can produce the larget,
;;     you should return #f.  Here's an example:
;;     
;;     Target: '(1 2 3 4)
;;     Prefixes: '((1) (1 2 3) (7) (3))
;;     Suffixes: '((4 3) (3 4) (4))
;;
;;     The function should return '(1 2 3) because '(1 2 3) + (4) yields the
;;     target.  If they target was '(7 3) however, the function should
;;     return #f because no combination of prefix and suffix can yield that
;;     list.
;;
;; Convert my given solution to CPS - do not use your own algorithm
;; and convert that.
;;

(define combine-to-target-orig
  (lambda (target prefixes suffixes)
    (cond [(null? prefixes) #f]
          [(null? suffixes) #f]
          [(equal? target (append (car prefixes) (car suffixes)))
           (car prefixes)]
          [else (let ((try1 (combine-to-target-orig target
                                               (list (car prefixes))
                                               (cdr suffixes))))
                  (if try1
                      try1
                      (combine-to-target-orig target
                                         (cdr prefixes)
                                         suffixes)))])))

(define-datatype continuation continuation?
  [init-k]
  [list-k]
  [step1 (target list?) (prefixes list?) (suffixes list?) (k continuation?)]
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
           [init-k () v]
           [list-k () (list v)] ;; for testing
           [step1 (target prefixes suffixes k)
                  (let ((try1 v))
                  (if try1
                      (apply-k k try1)
                      (combine-to-target-cps target
                                             (cdr prefixes)
                                             suffixes
                                             k)))]
           )))
  

(define combine-to-target-cps
  (lambda (target prefixes suffixes k)
    (cond [(null? prefixes) (apply-k k #f)]
          [(null? suffixes) (apply-k k #f)]
          [(equal? target (append (car prefixes) (car suffixes)))
           (apply-k k (car prefixes))]
          [else (combine-to-target-cps target
                                       (list (car prefixes))
                                       (cdr suffixes)
                                       (step1 target prefixes suffixes k)
                                       )])))


; (trace apply-k combine-to-target-cps)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; QUESTION 2 DEFINE SYNTAX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Implement the operation all-equal which is a boolean operation that
;; returns true if all the expressions are equal to each other (in
;; terms of equal? equality).

;; (all-equal (+ 1 2) 3 (- 103 100)) yields #t
;; (all-equal 1 1 1 3) yields #f

;; all-equal uses "short circuiting" i.e. if two earlier values are
;; unequal, later expressions will not be evaluated.  For example:

;; (all-equal 7 (display "I print") (display "I dont print"))

;; This short circuiting behavior means all-equal cannot be
;; implemented as a function - it must be a macro.

;; Note that the smallest all-equal expression is with 2 terms.
;; (i.e. (all-equal 3) or (all-equal) have no defined meaning).

;; For full credit, each subexpression in the all equal should only be
;; evaluated once.  For example:

;; (all-equal (display "a") (display "b") (display "c") (display "d"))

;; each letter should only print once.  You can get 15/20 if your
;; solution is correct except for meeting this last requirement.


(define-syntax (all-equal stx)
  (syntax-case stx ()
    [(all-equal x y)
     #'(equal? x y)]
    [(all-equal x y more ...)
     #'(let ((x-result x)
             (y-result y))
         (and (equal? x-result y-result) (all-equal y-result more ...)))]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; QUESTION 3 SYNTAX EXPAND
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Implement a variation of the cases-expression called “num-cases” with the following 
;; syntax: (num-cases <exp> {(<number> <exp1>)}+(else <exp3>)) In this variant, <exp> evaluates to a number
;; and the cases are identified by numbers, except for the "else" case. For example, the following 
;; expression: (num-cases 3 (1 'a) (2 'b) (3 'c) (4 'd) (else 'f)) evaluates to 'c.
;; For testing purposes, you may assume that the first item of each case is a number and that the else case 
;; is always provided and appears last. You may assume that there is at least one number case.
;; It is important that the <exp> be evaluated exactly once. If you use a let-exp to implement this 
;; behavior, then you need to create a new variable. You may assume that the variable name you choose is 
;; unique. Also, do not forget to run the let-exp that you create through syntax-expand if your let-exp
;; is not interpreted. Below are a few more examples:
;;
;; (num-cases (+ 5 2) (1 'a) (7 'b) (3 'c) (4 'd) (else 'f))  -> 'b
;;
;; (num-cases 7 (1 'a) (else 'b))  -> 'b
;; 
;; (num-cases (+ 3 8) 
;;            (1 (+ 2 3)) 
;;            (2 (* 2 3)) 
;;            (3 (- 11 3)) 
;;            (11 (* 3 (let ([a 5]) (* a 4)))) 
;;            (else 'f))  -> 60
;;
;; (num-cases ((lambda (x) x) 6) 
;;            (1 (+ 2 3)) 
;;            (2 (* 2 3)) 
;;            (6 (- 11 3)) 
;;            (11 (* 3 (let ([a 5]) (* a 4)))) 
;;            (else 'f))  -> 8
;;
;; (let ([v (vector 0)]) 
;;      (num-cases (let () (vector-set! v 0 (+ (vector-ref v 0) 1)) v) 
;;                 (1 v) 
;;                 (2 v) 
;;                 (3 v) 
;;                 (else v)))  -> '#(1)

;; replace this with your interpreter and implementation of eval-one-exp
(define eval-one-exp
  (lambda (exp)
    (nyi))) ; sorry not giving you my interpreter

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; QUESTION 4 GENERAL INTERPRETER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Change your interpreter so that when a closure is invoked with less
;; arguments than it expects, it returns a new closure which is
;; expects the remaining arguments - i.e. make closures implicitly
;; curry.
;;
;; An example:
;;
;; (let* ((fun (lambda (x y z) (list 'x x 'y y 'z z)))
;;        (needs-z (fun 1 2))) ; returns a closure
;;   (needs-z 3)) ; yields '(x 1 y 2 z 3)
;;
;; To do this, when a closure is involved with too few arguments,
;; don't error.  Instead, construct a new environment that maps the
;; parameters you have, and create a new closure expecting the
;; remaining paramters that includes the original bodies.
;;
;; You may find built in racket procedures take and drop useful to do
;; the list manipulations you need.
;;
;; Your solution does not need to work with primitive procedures.
;;
;; Your solution does not need to work with closures that expect
;; arbitrary arguments (i.e. (lambda arg-list body))
;;
;; Dont try to solve this problem with syntax expansion - it's not
;; possible.

  ;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
