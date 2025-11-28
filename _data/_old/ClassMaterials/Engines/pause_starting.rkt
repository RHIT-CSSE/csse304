#lang racket

(define run-pausable
  (lambda (proc)

    ; just running the proc is not enough of course
    (proc)))

(define resume
  (lambda ()
    'nyi))

(define pause
  (lambda ()
    'nyi))

(run-pausable (lambda ()
                (display 1)
                (pause)
                (display 3)

                ))
(display 2)
(resume)
(display 4)