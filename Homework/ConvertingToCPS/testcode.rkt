#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

;;;; Please add the following to your code:
;;;; (provide member?-cps set?-cps intersection-cps andmap-cps make-cps matrix?-cps halt-cont)

(require "../testcode-base.rkt")
(require "ConvertingToCPS.rkt")
(provide get-weights get-names individual-test test)

(define test
  (make-test
    ; (r)

   (member?-cps equal?
                [(member?-cps 'a '(b c a d) (halt-cont)) '(a d) 5]
                [(member?-cps 'e '(b c a d) (halt-cont)) #f 5]
                )

  (set?-cps equal?
            [(set?-cps '(1 1 1 1) (halt-cont)) #f 5]
            [(set?-cps '(1 4 3 2) (halt-cont)) #t 5]
            )

  (intersection?-cps equal?
                     [(intersection-cps '(1 2 3) '(4 5 6) (halt-cont)) '() 5]
                     [(intersection-cps '(1 2 3) '(3 5 2 6) (halt-cont)) '(2 3) 5]
                     )

  (andmap-cps equal?
              [(andmap-cps (make-cps number?) '(2 3 4 5) (halt-cont)) #t 3]
              [(andmap-cps (make-cps number?) '(2 3 a 5) (halt-cont)) #f 3]
              [(andmap-cps (lambda (L k) (member?-cps 'a L k)) '((b a) (c b a)) (halt-cont)) #t 3]
              [(andmap-cps (lambda (L k) (member?-cps 'a L k)) '((b a) (c b)) (halt-cont)) #f 3]
              )

  (matrix-cps equal?
              [(matrix?-cps '((1 2) (3 4)) (halt-cont)) #t 4]
              [(matrix?-cps '((1 2) (3 4 5)) (halt-cont)) #f 4]
              [(matrix?-cps '(()) (halt-cont)) #f 4]
             )

  

 ))
 

(implicit-run test) ; Run tests as soon as this file is loaded
