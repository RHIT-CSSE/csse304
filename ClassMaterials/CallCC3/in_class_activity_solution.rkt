#lang racket

(define throw #f)

(define try
  (lambda (code_to_run on_error)
    (call/cc (lambda (exit-normally)
               (let ((result (call/cc (lambda (cont)
                                        (set! throw cont)
                                        (exit-normally (code_to_run))
                                        ))))
                 (on_error result)
    )))))

(try (lambda () 4) (lambda (code) 'error))

(try (lambda ()
       (throw 'errorcode)
       (display "I should never run")
       ) (lambda (code) 'error))
    