#lang racket

; only functions in racket/base can be used by default in macros
; this adds some other useful prodcedures
(require (for-syntax racket/list)) 

(provide my-let my-or let-destruct range-cases ifelse define-object define-method)

(define-syntax (my-let stx)
  (syntax-case stx ()
    [(my-let ((name value) ...) bodies ...)
     #'((lambda (name ...) bodies ...) value ...)]
    [(my-let _ ...) ; <- NOTE THIS PATTERN IS NOT RIGHT
     #''nyi] ; the above pattern is just a way to ensure the test cases run
             ; and expand into the expression 'nyi rather than crashing
    ))


(define-syntax (my-or stx)
  (syntax-case stx ()
    [(my-or _ ...) #''nyi]))
    
             
(define-syntax (range-cases stx)
  (syntax-case stx (< else)
    [(range-cases _ ...) #''nyi]))   



(define-syntax (let-destruct stx)
  (syntax-case stx ()
    [(let-destruct _ ...) #''nyi]))

(define-syntax (ifelse stx)
  #'(error "nyi"))


(define-syntax (define-object stx)
    #''nyi
    )

(define-syntax (define-method stx)
  (syntax-case stx ()
    [(define-method _ name _ ...)
     #'(define name (lambda x (error "nyi")))])) ; <- had to do a little more work to prevent the test cases
                                        ; from failing all the other tests.  You'll have to change this
                                        ; template quite a bit though.
