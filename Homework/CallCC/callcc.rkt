#lang racket

(provide make-retlam return jobs switch-job go-home)


; RETLAM

(define return
  (lambda (retval)
    (nyi)))

(define make-retlam
  (lambda (lam)
    lam)) ; <- not what you want, but prevents the tests from exploding initially

; JOBS

(define go-home
  (lambda ()
    (nyi)))

(define switch-job
  (lambda (index)
    (nyi)))

(define jobs
  (lambda vars
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
