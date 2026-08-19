#lang racket
(define escape #f)
(define goto #f)

(define run-pausable
  (lambda (proc)
    (call/cc (lambda (escape-k)
               (set! escape escape-k)
               (proc)))))

(define resume
  (lambda ()
    (goto 'unpaused)))

(define pause
  (lambda ()
    (call/cc (lambda (goto-k)
               (set! goto goto-k)
               (escape 'paused)))
    ))

;((lambda ()
(run-pausable (lambda ()
                (display 1)
                (pause)
                (display 3)

                ))
(display 2)
(resume)
(display 4);))