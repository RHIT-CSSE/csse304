#lang racket

; only functions in racket/base can be used by default in macros
; this adds some other useful prodcedures
(require (for-syntax racket/list)) 

(provide my-let null-let all-equal begin-unless range-cases ifelse let-destruct)

(define-syntax (my-let stx)
  (syntax-case stx ()
    [(my-let ((name value) ...) bodies ...)
     #'((lambda (name ...) bodies ...) value ...)]
    [(my-let _ ...) ; <- NOTE THIS PATTERN IS NOT RIGHT
     #''nyi] ; the above pattern is just a way to ensure the test cases run
             ; and expand into the expression 'nyi rather than crashing
    ))

(define-syntax (null-let stx)
   (syntax-case stx ()
     [(null-let _ ...)
      #''nyi]))

(define-syntax (all-equal stx)
  (syntax-case stx ()
    [(all-equal _ ...)
     #''nyi]))

(define-syntax (begin-unless stx)
  (syntax-case stx ()
    [(begin-unless _ ...)
     #''nyi]))

             
(define-syntax (range-cases stx)
  (syntax-case stx (< else)
    [(range-cases _ ...) #''nyi]))   



(define-syntax (let-destruct stx)
  (syntax-case stx ()
    [(let-destruct _ ...) #''nyi]))

(define-syntax (ifelse stx)
  #'(error "nyi"))
