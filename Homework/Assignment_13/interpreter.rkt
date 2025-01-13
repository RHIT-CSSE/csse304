#lang racket

(require "../chez-init.rkt")
(provide eval-one-exp)

;-------------------+
;                   |
;   sec:DATATYPES   |
;                   |
;-------------------+

; parsed expression.  You'll probably want to replace this 
; code with your expression datatype from A11b

(define-datatype expression expression?  
  [var-exp        ; variable references
   (id symbol?)] 
  )
	

;; environment type definitions

(define scheme-value?
  (lambda (x) #t))
  
(define-datatype environment environment?
  [empty-env-record]
)


; datatype for procedures.  At first there is only one
; kind of procedure, but more kinds will be added later.


  
;-------------------+
;                   |
;    sec:PARSER     |
;                   |
;-------------------+

; This is a parser for simple Scheme expressions, such as those in EOPL 3.1 thru 3.3.

; You will want to replace this with your parser that includes more expression types, more options for these types, and error-checking.

; Helper procedures to make the parser a little bit saner.
(define 1st car)
(define 2nd cadr)
(define 3rd caddr)

; Again, you'll probably want to use your code from A11b

(define parse-exp         
  (lambda (datum)
    (cond
      [(symbol? datum) (var-exp datum)]
      [(number? datum) (lit-exp datum)]
      [else (error 'parse-exp "bad expression: ~s" datum)])))


;-------------------+
;                   |
; sec:ENVIRONMENTS  |
;                   |
;-------------------+


; Environment definitions for CSSE 304 Scheme interpreter.  
; Based on EoPL sections 2.2 and 2.3

(define empty-env
  (lambda ()
    (empty-env-record)))


;-----------------------+
;                       |
;  sec:SYNTAX EXPANSION |
;                       |
;-----------------------+

; To be added later.

;---------------------------------------+
;                                       |
; sec:CONTINUATION DATATYPE and APPLY-K |
;                                       |
;---------------------------------------+

; To be added later


;-------------------+
;                   |
;  sec:INTERPRETER  |
;                   |
;-------------------+






