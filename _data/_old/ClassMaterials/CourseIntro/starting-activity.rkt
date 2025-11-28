#lang racket

;; The single define form is syntactic sugar for function definitions in Scheme.
;; It allows you to write function definitions more concisely by combining the
;; function name, parameters, and body in a single expression.
;;
;; Single define form:     (define (function-name param1 param2 ...) body)
;; Equivalent lambda form: (define function-name (lambda (param1 param2 ...) body))
;;
;; Examples:
;; (define (square x) (* x x))
;; (define (add a b) (+ a b))
;; (define (factorial n) (if (= n 0) 1 (* n (factorial (- n 1)))))
;;
;; The single define form is automatically converted to the lambda form by the
;; Scheme interpreter, making both forms functionally equivalent.
;;
;; Feel free to use the sigle define form, and I will occasionally myself.
;;
;; But now - take a look at this function here.  What it does is convert the single
;; define form expressed as a list of symbols into the old lambda form.  It's
;; intended to be called like this:
;;
;; (define-to-lambda '(define (add a b) (+ a b)))
;;
;; Try it out and then answer these questions about the code
;;
;; Q1-5.  The function has 5 checks I've noted with the comments.  What do each of the checks do?
;; Q6.  Down on the last line, we "(cons 'lambda ...other stuff)" why not (list 'lambda ...other stuff)

(define (define-to-lambda expr)
  (cond

    ((not (and (list? expr) ; <= check 1
               (eq? (car expr) 'define))) ; <= check 2
     (error "Not a define? Got:" expr))
    
    ((not (and (list? (cadr expr)) ; <= check 3
               (symbol? (caadr expr)) ; <= check 4
               (= (length expr) 3))) ; <= check 5
     (error "Define parameters not right? Got:" expr))
    
    ;; Valid function definition - convert it
    (else
     (let ((function-name (caadr expr))
           (arguments (cdr (cadr expr)))
           (body (caddr expr)))
       (list 'define
             function-name
             (cons 'lambda (cons arguments (list body))))))))

(define-to-lambda '(define (median-of-three a b c) (- (+ a b c) (max a b c) (min a b c))))
 