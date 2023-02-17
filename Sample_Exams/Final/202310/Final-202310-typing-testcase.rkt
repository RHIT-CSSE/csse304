#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "Final-202310-typing.rkt")
(provide get-weights get-names individual-test test)

(define expect-error
  (lambda (code)
    (with-handlers ([symbol? (lambda (x) x)])
      (cons-type code)
      'unexpected-success)))

(define test (make-test ; (r)
              (cons-type equal? ; (run-test cons-type)
                 [(cons-type 1) 'number 1] ; (run-test cons-type 1)
                 [(cons-type 'foo) 'symbol 1] ; (run-test cons-type 2)
                 [(cons-type '()) 'empty-list 1] ; (run-test cons-type 3)
                 [(cons-type '(cons 1 ())) '(number) 1]
                 [(cons-type '(cons a (cons b ()))) '(symbol) 1]
                 [(cons-type '(cons (cons 1 ()) ())) '((number)) 1]
                 [(cons-type '(cons (cons 3 ()) (cons (cons 1 ()) ()))) '((number)) 1]
                 [(expect-error '(cons 1 (cons b ()))) 'list-mismatch-cons 1]
                 [(expect-error '(cons 1 2)) 'cons-nonlist 1]
                 [(expect-error '(cons (cons a ()) (cons (cons 1 ()) ()))) 'list-mismatch-cons 1]
                 [(expect-error '(cons (cons a ()) (cons b ()))) 'list-mismatch-cons 1]
                 [(cons-type '(car (cons 1 ()))) 'number 1]
                 [(cons-type '(cdr (cons 1 ()))) '(number) 1]
                 [(cons-type '(cons (car (cons a ())) (cons b ()))) '(symbol) 1]
                 [(expect-error '(car a)) 'car-nonlist 1]
                 [(expect-error '(cdr (car (cons 1 ())))) 'cdr-nonlist 1]
                 ; this may be an invalid program, but it has a valid type
                 [(cons-type '(cdr (cdr (cdr (cons 1 ()))))) '(number) 1]
                 ; this is a valid program, but its type is still invalid
                 [(expect-error '(cons a (cdr (cons 1 ())))) 'list-mismatch-cons 1]
                 ; two silly edge cases with the empty list type
                 [(cons-type '(cons (cons () ()) ())) '((empty-list)) 1]
                 [(cons-type '(cons a (car (car (cons (cons () ()) ()))))) '(symbol) 1]
              )

  ))

(implicit-run test) ; run tests as soon as this file is loaded