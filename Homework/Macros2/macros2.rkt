#lang racket

; only functions in racket/base can be used by default in macros
; this adds some other useful prodcedures
(require (for-syntax racket/list)) 

(provide ifelse let-destruct)

(define-syntax (ifelse stx)
  #'(error "nyi"))

(define-syntax (let-destruct stx)
  (syntax-case stx ()
    [(let-destruct _ ...) #''nyi]))
