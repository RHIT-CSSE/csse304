#lang racket

(define throw #f)

(define try
  (lambda (code_to_run on_error)
    'nyi))

(try (lambda () 4) (lambda (code) 'error))

(try (lambda ()
       (throw 'errorcode)
       (display "I should never run")
       ) (lambda (code) 'error))
    