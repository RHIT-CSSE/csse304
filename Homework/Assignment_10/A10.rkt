#lang racket

(provide free-vars bound-vars occurs-free? occurs-bound? lexical-address un-lexical-address convert-multip-calls convert-multip-lambdas)

(define free-vars
  (lambda (a)
    (nyi)))

(define bound-vars
  (lambda (a)
    (nyi)))

(define occurs-free?
  (lambda (a b)
    (nyi)))

(define occurs-bound?
  (lambda (a b)
    (nyi)))


(define convert-multip-calls
  (lambda (lc-exp)
    (cond [(symbol? lc-exp) lc-exp]
          [(equal? (car lc-exp) 'lambda) (list 'lambda
                                               (cadr lc-exp)
                                               (convert-multip-calls (caddr lc-exp)))]
          [(= (length lc-exp) 2) (list (convert-multip-calls (car lc-exp))
                                       (convert-multip-calls (cadr lc-exp)))]
          [else (convert-multip-calls (cons (list (car lc-exp) (cadr lc-exp))
                                            (cddr lc-exp)))])))


(define convert-multip-lambdas
  (lambda (lc-exp)
    (cond [(symbol? lc-exp) lc-exp]
          [(= (length lc-exp) 2) (list (convert-multip-lambdas (car lc-exp))
                                       (convert-multip-lambdas (cadr lc-exp)))]
          [(= (length (cadr lc-exp)) 1) (list 'lambda
                                              (cadr lc-exp)
                                              (convert-multip-lambdas (caddr lc-exp)))]
          [else
           (list 'lambda
                 (cons (car (cadr lc-exp)) '())
                 (convert-multip-lambdas (cons 'lambda (cons (cdr (cadr lc-exp)) (cddr lc-exp)))))])))



(define lexical-address
  (lambda (a)
    (nyi)))

(define un-lexical-address
  (lambda (a)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
