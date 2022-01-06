#lang racket

(require "../chez-init.rkt")
(provide my-let my-or += return-first bintree? leaf-node interior-node bintree-to-list max-interior parse-exp unparse-exp)

(define-syntax my-let
  (syntax-rules ()
    [(my-let args ...)
     (nyi)]))

(define-syntax my-or
  (syntax-rules ()
    [(my-or args ...)
     (nyi)]))

(define-syntax +=
  (syntax-rules ()
    [(+= args ...)
     (nyi)]))

(define-syntax return-first
  (syntax-rules ()
    [(return-first args ...)
     (nyi)]))

(define-datatype bintree bintree?
  (leaf-node
   (datum number?))
  (interior-node
   (key symbol?)
   (left-tree bintree?)
   (right-tree bintree?)))

(define bintree-to-list
  (lambda (a)
    (nyi)))

(define max-interior
  (lambda (a)
    (nyi)))

; This is a parser for simple Scheme expressions, 
; such as those in EOPL, 3.1 thru 3.3.

; You will want to replace this with your parser that includes more expression types, more options for these types, and error-checking.

(define-datatype expression expression?
  [var-exp
   (id symbol?)]
  [lit-exp
   (data number?)]
  [lambda-exp
   (id symbol?)
   (body expression?)]
  [app-exp
   (rator expression?)
   (rand expression?)])

; Procedures to make the parser a little bit saner.
(define 1st car)
(define 2nd cadr)
(define 3rd caddr)

(define parse-exp         
  (lambda (datum)
    (cond
      [(symbol? datum) (var-exp datum)]
      [(number? datum) (lit-exp datum)]
      [(pair? datum)
       (cond
         [(eqv? (car datum) 'lambda)
          (lambda-exp (car (2nd  datum))
                      (parse-exp (3rd datum)))]
         [else (app-exp (parse-exp (1st datum))
                        (parse-exp (2nd datum)))])]
      [else (error 'parse-exp "bad expression: ~s" datum)])))

(define unparse-exp
  (lambda (exp)
    (nyi)))

; An auxiliary procedure that could be helpful.
(define var-exp?
  (lambda (x)
    (cases expression x
      [var-exp (id) #t]
      [else #f])))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
