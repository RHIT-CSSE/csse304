#lang racket

;; activity 1

;; continuation loop printing 1 - 5



;; activity 2

;; fix this using a super-return

(define (list-index item L)
  (cond 
    [(null? L) -1]
    [(eq? (car L) item) 0]
    [else (+ 1 (list-index item 
                           (cdr L)))]))




(define throw #f)

(define try
  (lambda (code_to_run on_error)
    'nyi))

(try (lambda () 4) (lambda (code) 'error))

(try (lambda ()
       (throw 'errorcode)
       (display "I should never run")
       ) (lambda (code) 'error))
    