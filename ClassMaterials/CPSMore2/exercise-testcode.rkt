#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-test group-name)
;
; The tail position group checks that flatten-cps and apply-k, the substantial
; procedures of this exercise, are never called from a non-tail position.  Those
; checks look procedures up by identity, so leave the (trace ...) line in your
; exercise file commented out while you run the tests.

(require "testcode-base.rkt")
(require "cps-conversion-helper.rkt")
(require "exercise.rkt")
(provide get-weights get-names individual-test test)

; The names as they are written in exercise.rkt, which is what the analysis of
; that file reads out of the code.
(define substantial
  '(flatten-cps apply-k))

; (non-tail-substantial-calls proc) is the list of calls that proc makes from a
; non-tail position to any substantial procedure.  A finished conversion has
; none, so a failing test shows you the calls to move: each one needs the rest
; of the computation moved into the continuation of that call.  A procedure that
; cannot be looked up -- one not declared with define-cps-procedure, or one
; whose binding was replaced (tracing does that) -- is reported as a failing
; answer carrying the reason, instead of taking the whole run down with it.
(define (non-tail-substantial-calls proc)
  (with-handlers ([exn:fail? (lambda (e) (list 'error (exn-message e)))])
    (filter (lambda (name) (memq name substantial))
            (procs-in-non-tail-position proc))))

(define test
  (make-test ; (r)

   (flatten-cps equal? ; (run-test flatten-cps)
    [(flatten-cps '() (init-k)) '() 1] ; (run-test flatten-cps 1)
    [(flatten-cps '(a) (init-k)) '(a) 1] ; (run-test flatten-cps 2)
    [(flatten-cps '(a (b c) (d ((e (f))) g)) (init-k)) '(a b c d e f g) 2] ; (run-test flatten-cps 3)
    [(flatten-cps '(1 (2 3) (4 (5)) 6) (init-k)) '(1 2 3 4 5 6) 2] ; (run-test flatten-cps 4)
    [(flatten-cps '(a () b) (init-k)) '(a b) 2] ; (run-test flatten-cps 5)
    [(flatten-cps '(((a))) (init-k)) '(a) 2] ; (run-test flatten-cps 6)
    )

   (flatten-cps-tail-positions equal? ; (run-test flatten-cps-tail-positions)
    [(non-tail-substantial-calls flatten-cps) '() 3] ; (run-test flatten-cps-tail-positions 1)
    [(non-tail-substantial-calls apply-k) '() 2] ; (run-test flatten-cps-tail-positions 2)
    )
))

(implicit-run test) ; run tests as soon as this file is loaded
