#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-test group-name)
;
; Each problem has two groups: the value tests for its converted procedure, and
; the tail position tests.  A tail position test asks whether the converted
; procedure, or apply-k, is ever called from a non-tail position -- a finished
; conversion never does that, because making those calls tail calls is the whole
; point.  (The tail position tests need the procedures as defined by the macro,
; so keep the (trace ...) line in your problem file commented out: tracing
; rebinds the name to a wrapper and the lookup is by identity.)

(require "testcode-base.rkt")
(require "cps-conversion-helper.rkt")
(require "prob1.rkt")
(require "prob2.rkt")
(require "prob3.rkt")
(require "prob4.rkt")
(provide get-weights get-names individual-test test)

; (non-tail-calls-to proc names) is the list of calls that proc makes from a
; non-tail position to any of names.  The names to test are the ones written in
; the problem file -- list-last-cps and apply-k -- because that is what the
; analysis reads out of the source.  The renamed names this file requires
; (list-last-apply-k, list-last-init-k) exist only to keep four problem files
; apart inside one program, and never appear in a problem file's own code.
; A finished conversion has no such calls.  A procedure that cannot be looked up
; -- one that was not defined with the macro, or whose binding was replaced --
; is reported as a failing answer carrying the reason, instead of taking the
; whole run down with it.
(define (non-tail-calls-to proc names)
  (with-handlers ([exn:fail? (lambda (e) (list 'error (exn-message e)))])
    (filter (lambda (name) (memq name names)) (procs-in-non-tail-position proc))))

(define test (make-test ; (r)
   (list-last-cps equal? ; (run-test list-last-cps)
    [(list-last-cps '(1 2 3) (list-last-init-k)) 3 1] ; (run-test list-last-cps 1)
    [(list-last-cps '(7) (list-last-init-k)) 7 1]
    [(list-last-cps '(1 2) (list-last-init-k)) 2 1]
    [(list-last-cps '(a b c d) (list-last-init-k)) 'd 1]
  )

   (list-last-tail-positions equal? ; (run-test list-last-tail-positions)
    [(non-tail-calls-to list-last-cps '(list-last-cps apply-k)) '() 1]
    [(non-tail-calls-to list-last-apply-k '(list-last-cps apply-k)) '() 1]
  )

   (sum-digits-cps equal?
    [(sum-digits-cps 0 (sum-digits-init-k)) 0 1]
    [(sum-digits-cps 9 (sum-digits-init-k)) 9 1]
    [(sum-digits-cps 10 (sum-digits-init-k)) 1 1]
    [(sum-digits-cps 902 (sum-digits-init-k)) 11 1]
    [(sum-digits-cps 12345 (sum-digits-init-k)) 15 1]
    [(sum-digits-cps 999 (sum-digits-init-k)) 27 1]
  )

   (sum-digits-tail-positions equal?
    [(non-tail-calls-to sum-digits-cps '(sum-digits-cps apply-k)) '() 1]
    [(non-tail-calls-to sum-digits-apply-k '(sum-digits-cps apply-k)) '() 1]
  )

   (max-of-cps equal?
    [(max-of-cps '(2) (max-of-init-k)) 2 1]
    [(max-of-cps '(5 5 2) (max-of-init-k)) 5 1]
    [(max-of-cps '(3 1 4 1 5) (max-of-init-k)) 5 1]
    [(max-of-cps '(1 2 3) (max-of-init-k)) 3 1]
    [(max-of-cps '(-1 -5 -3) (max-of-init-k)) -1 1]
  )

   (max-of-tail-positions equal?
    [(non-tail-calls-to max-of-cps '(max-of-cps apply-k)) '() 1]
    [(non-tail-calls-to max-of-apply-k '(max-of-cps apply-k)) '() 1]
  )

   (dup-all-cps equal?
    [(dup-all-cps '() (dup-all-init-k)) '() 1]
    [(dup-all-cps '(a) (dup-all-init-k)) '(a a) 1]
    [(dup-all-cps '(1 2) (dup-all-init-k)) '(1 1 2 2) 1]
    [(dup-all-cps '(x y z) (dup-all-init-k)) '(x x y y z z) 1]
  )

   (dup-all-tail-positions equal?
    [(non-tail-calls-to dup-all-cps '(dup-all-cps apply-k)) '() 1]
    [(non-tail-calls-to dup-all-apply-k '(dup-all-cps apply-k)) '() 1]
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
