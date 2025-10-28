#lang racket

(define combine
  (lambda (a b c d e op)
    (let ((error (lambda () (display "error"))))
    (max e (op (op a b error) (op c d error) error)))))

(define example-op
  (lambda (rand1 rand2 error)
    (if (< (+ rand1 rand2) 0)
        (error)
        (+ rand1 rand2))))

(combine 1 2 3 4 2 example-op)
(combine -3 2 3 4 2 example-op)

; challenge 1
; make combine return 'error when error is called
; challenge 2
; make calling error stop computation and return 0 for that op
; even if not called from tail position
; challenge 3
; make a loop that sums numbers 1-10 with continuations
        