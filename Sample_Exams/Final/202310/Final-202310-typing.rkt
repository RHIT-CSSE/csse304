#lang racket

(provide cons-type)
;; 15 POINTS
;;
;; So we're going to handle types for a simple language I call cons.
;; This language is similar to scheme cons/car/cdr expressions
;; except lists must be proper (e.g. no (cons 1 2)) and
;; lists must have a singular type (e.g. no (cons a (cons 1 ())))
;;
;; here's the details
;; cons_exp ::= <number>
;;              | <symbol>
;;              | ()
;;              | (car <cons-exp>)
;;              | (cdr <cons-exp>)
;;              | (cons <cons-exp> <cons-exp>)
;;
;; each of these expressions has a type
;; <number> => number
;; <symbol> => symbol
;; () => empty-list
;; (car A) where A has type (T) (i.e. list of T) => T
;; (car A) where A is not a list type should (raise 'car-nonlist)
;; (cdr A) where A has type (T) => (T)
;; (car A) where A is not a list type should (raise 'cdr-nonlist)
;; (cons A B) where A has type T and B is type empty-list => (T)
;; (cons A B) where A has type T and B has type (T) => (T)
;; (cons A B) where B has a non-list type should (raise 'cons-nonlist)
;; (cons A B) where A has type X and B has type (Y) and X != Y should (raise 'list-mismatch-cons)
;;
;; Write cons-type which deduces the type of a cons expression.  Take
;; a look at the test cases to see how the various types are expected to be
;; returned.
;;
;; Note that you should not write code that attempts to evaluate the expression
;; (i.e. uses eval or your own code to actually determine what list or number
;; is produced)


(define cons-type
  (lambda (exp)
    'nyi))
              
                    
        