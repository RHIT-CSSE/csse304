#lang racket

; only functions in racket/base can be used by default in macros
; this adds some other useful prodcedures
(require (for-syntax racket/list)) 

(provide init all-equal begin-unless range-cases for)

(define-syntax init
   (syntax-rules ()
     ))

(define-syntax all-equal
  (syntax-rules ()
    ))

(define-syntax begin-unless
  (syntax-rules ()
    ))

(define-syntax range-cases
  (syntax-rules (< else)
    ))   

(define-syntax for
  (syntax-rules (:)
    ))  
