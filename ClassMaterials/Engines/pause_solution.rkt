#lang racket

(define pause-k #f)
(define resume-k #f)
(define final-k #f)

(define run-pausable
  (lambda (proc)
    (call/cc (lambda (k)
               (set! pause-k k)
               (proc)
               (final-k)
               ))
    ))

(define resume
  (lambda ()
    (call/cc (lambda (k)
               (set! final-k k)
               (resume-k)))))

(define pause
  (lambda ()
    (call/cc (lambda (k)
               (set! resume-k k)
               (pause-k)))))

(run-pausable (lambda ()
                (display 1)
                (pause)
                (display 3)

                ))
(display 2)
(resume)
(display 4)