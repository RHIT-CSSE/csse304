#lang racket

; only functions in racket/base can be used by default in macros
; this adds some other useful prodcedures
(require (for-syntax racket/list)) 

(provide init all-equal begin-unless range-cases for)

(define-syntax (init stx)
  (syntax-case stx ()
    [(init _ ...)
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
    [(range-cases _ ...)
     #''nyi]))   

(define-syntax (for stx)
  (syntax-case stx (:)
    [(for _ ...)
     #''nyi]))  
