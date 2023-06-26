#lang racket

; zero! FROM THE SLIDES

(printf "Does this print first?~n")

(define-syntax zero!
  (lambda (stx)
    (let ((code (syntax->datum stx)))
      (printf "transforming ~s~n" code)
      (unless (symbol? (cadr code))
        (raise-syntax-error "zero! non symbol" stx))
      (let ((result (list 'set! (cadr code) 0)))
        (printf "produced ~s~n" result)
        (datum->syntax stx result)))))

(define myvar1 2)
(zero! myvar1)

;; IN CLASS EXERCISE BW
;;
;;
;; BW lets you take a scheme function call and invoke it in reverse order
;; (BW 1 2 +) yields 3
;; (BW 1 2 3 list) yields (3 2 1)

;; Note that it does not apply recursively to subexpressions
;; (BW (list 1 2) (list 2 3) list) yields ((2 3) (1 2))

(define-syntax BW
  (lambda (stx)
    (datum->syntax stx '(quote nyi))))

;; IN CLASS EXAMPLE SWAP

(define-syntax (swap stx)
  (syntax-case stx ()
    [(swap x y)
     #'(let ([tmp x])
         (set! x y)
         (set! y tmp))]))

(define myvar2 99)
(swap myvar1 myvar2) ; myval1s value goes in myvar2 and vice versa

;; EXERCISE classic-if
;;
;; In classic scheme, if you call if when 2 parameters it
;; returns void on false (similar to Racket's when).
;;
;; (classic-if #t 1) yields 1
;; (classic-if #f 1) yields void
;;
;; If you call it with two parameters it acts like regular
;; racket if.  
;; (classic-if #f 1 2) yields 2

(define-syntax (classic-if stx)
  (syntax-case stx ()
    [(classic-if test then-exp)
     #'(quote nyi)]
    [(classic-if test then-exp else-exp)
     #'(quote nyi)]
    ))

;; IN CLASS EXAMPLE DUPSYMS
;;
;; Changes a list of symbols into a list of symbol pairs
;; (dupsyms a b c) yields '((a . a) (b . b) (c . c))

(define-syntax (dupsyms stx)
  (syntax-case stx ()
    [(_ sym ...) #'(quote nyi)]))

;; EXERCISE MYWHEN
;;
;; Just reimplementing the standard Racket scheme when.
;; Implement it by transforming it to an if expression.
;; Use begin too.
;;
;; If the test of mywhen is false, the expression
;; should return a void value (generate it by calling (void)).
;;
;; Note that mywhen allows any number of body expressions
;;
;; (mywhen #t (display "a") (display "b")) ; prints ab

(define-syntax (mywhen stx)
  (syntax-case stx ()
    [(mywhen test thenexps ...)
     #'(if test (begin thenexps ...) (void))]))

;; EXECISE TOPAIRS
;;
;; Takes two list of symbols and converts them to a list of symbol pairs
;; (topairs (a b c) (d e f)) yields '((a . d) (b . e) (c . f))


(define-syntax (topairs stx)
  (syntax-case stx ()
    [(_ (a ...) (b ...) ) #'(quote nyi)]))

;; IN CLASS EXAMPLE myand

(define-syntax (myand stx)
  (syntax-case stx ()
    [(myand exp) #'exp]
    [(myand exp exps ...)
     #'(quote nyi)]))

;; EXERCISE MYLET*
;; Build an your own implementation of mylet*.
;; If you want you can build it in terms of built in let.
;; For slightly more challenge you can build in terms
;; of lambda.

(define-syntax (mylet* stx)
  #'(quote nyi))

;; Usage
;; (mylet* ((a 2) (b (+ 1 a))) (+ a b)) yields 5

;; IN CLASS EXAMPLE REPEAT
;; 
;; (repeat 3 (display "hello")) prints hellohellohello
;;
;; Note that this implementation is buggy

(define-syntax (repeat stx)
  (syntax-case stx ()
    [(_ numExp repeatExp ) #'(let repeatme ((count 0))
                               (if (= count numExp)
                                   (void)
                                   (begin
                                     repeatExp
                                     (repeatme (add1 count)))))]))

;; IN CLASS EXERCISE REPEAT
;; Make a second form of repeat that has variable parameter that you can
;; use within the body
;;
;;  (repeat i 3 (display i)) prints 123

(define-syntax (repeat2 stx)
  #'(quote nyi))
