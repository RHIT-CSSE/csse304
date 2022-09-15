#lang racket

(define make-bank-account
  (lambda (starting-balance)
    (let ([balance starting-balance])
      (lambda (command . args)
        (cond [(eqv? command 'balance) balance]
              [(eqv? command 'deposit) (set! balance (+ balance (car args)))]
              [(eqv? command 'withdraw) (set! balance (- balance (car args)))]
              [else 'unknown-command])))))

(define ba1 (make-bank-account 100))
(define ba2 (make-bank-account 500))