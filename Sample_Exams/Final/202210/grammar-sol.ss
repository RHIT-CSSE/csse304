(load "chez-init.ss")


;; Consider a language for boolean expressions defined in this way:
;;
;; <boolean_exp> = <and_exp> | <or_exp> | <not_exp> | <var_exp>
;; <and_exp> = ( <boolean_exp> and <boolean_exp> )
;; <or_exp> = ( <boolean_exp> or <boolean_exp> )
;; <not_exp> = ( not <boolean_exp> )
;; <var_exp> = <symbol>
;;
;; Given this language, write a function remove-ands that takes a
;; boolean expression are returns a new boolean expression where all
;; the and_exps have been removed.  We'll use the usual DeMorgan's law
;; to removed an and expression:
;;
;; (exp1 and exp2) => (not ((not exp1) or (not exp2)))
;;
;; That's how a single and_exp should be removed, but remove-ands
;; should remove all ands in the expression, no matter how deeply they
;; appear in subexpressions.  For example:
;;
;; (remove-ands '(x and (y and z)))
;;
;; yields
;;
;; (not ( (not x) or (not (not ((not y) or (not z))))))
;;
;; non-and expressions should be unchanged by remove-ands (except if
;; they contain and_exps as a subexpression).  Look at the test
;; cases for some detailed examples.
(define (remove-ands bool-exp)
  (cond
   [(symbol? bool-exp) bool-exp]
   [(eqv? (cadr bool-exp) 'or) (list (remove-ands (car bool-exp))
                                     'or
                                     (remove-ands (caddr bool-exp)))]
   [(eqv? (cadr bool-exp) 'and) (let ([exp1 (remove-ands (car bool-exp))]
                                      [exp2 (remove-ands (caddr bool-exp))]
                                      [my-not (lambda (x) (list 'not x))]
                                      )
                                  (my-not (list (my-not exp1) 'or (my-not exp2))))]
   [(eqv? (car bool-exp) 'not) (list 'not (remove-ands (cadr bool-exp)))]
   [else 'error]))
