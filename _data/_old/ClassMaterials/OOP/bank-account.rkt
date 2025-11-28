#lang racket

(define make-bank-account
  (lambda (starting-balance)
    'nyi)) 

; hint, you might find the lambda form with required
; and optional args useful here
; e.g. (lambda (command . extra-args)

(define ba1 (make-bank-account 100))
(define ba2 (make-bank-account 500))

(ba1 'deposit 200)
(ba1 'balance) ; should print 300

(ba2 'withdraw 50)
(ba2 'balance) ; should print 450