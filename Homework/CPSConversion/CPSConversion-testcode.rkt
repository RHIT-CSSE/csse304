#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-test group-name)

(require "../testcode-base.rkt")
(require "cps-conversion-helper.rkt")
(require "CPSConversion.rkt")
(provide get-weights get-names individual-test test)

(define set-equals?  ; are these list-of-symbols equal when
  (lambda (s1 s2)    ; treated as sets?
    (if (or (not (list? s1)) (not (list? s2)))
        #f
        (not (not (and (is-a-subset? s1 s2) (is-a-subset? s2 s1)))))))

; The substantial procedures: the ones that may only ever be called in tail
; position.  These are the names as they are written in CPSConversion.rkt, which
; is what the analysis of that file reads out of the code.  Each problem's tail
; position group checks its own procedures, and each group is worth 5 points.
(define substantial
  '(sum-numbers-cps slist-subst-cps free-vars-cps remove-cps apply-k))

; (non-tail-substantial-calls proc) is the list of calls that proc makes from a
; non-tail position to any substantial procedure.  A finished conversion has
; none, so a failing tail position test shows you the calls to move: each one
; needs the rest of the computation moved into the continuation of that call.
; A procedure that cannot be looked up -- one not declared with
; define-cps-procedure, or one whose binding was replaced (tracing does that) --
; is reported as a failing answer carrying the reason, instead of taking the
; whole run down with it.
(define (non-tail-substantial-calls proc)
  (with-handlers ([exn:fail? (lambda (e) (list 'error (exn-message e)))])
    (filter (lambda (name) (memq name substantial))
            (procs-in-non-tail-position proc))))

(define test
  (make-test ; (r)

   (sum-numbers equal? ; (run-test sum-numbers)
    [(sum-numbers-cps '() (init-k)) 0 1] ; (run-test sum-numbers 1)
    [(sum-numbers-cps '(5) (init-k)) 5 1] ; (run-test sum-numbers 2)
    [(sum-numbers-cps '(a b) (init-k)) 0 2] ; (run-test sum-numbers 3)
    [(sum-numbers-cps '(1 a 2 b 3) (init-k)) 6 2] ; (run-test sum-numbers 4)
    [(sum-numbers-cps '(x 10 y 20) (init-k)) 30 2] ; (run-test sum-numbers 5)
    [(sum-numbers-cps '(1 2 3 4) (list-k)) '(10) 2] ; (run-test sum-numbers 6)
    )

   (sum-numbers-tail-positions equal? ; (run-test sum-numbers-tail-positions)
    [(non-tail-substantial-calls sum-numbers-cps) '() 3] ; (run-test sum-numbers-tail-positions 1)
    [(non-tail-substantial-calls apply-k) '() 2] ; (run-test sum-numbers-tail-positions 2)
    )

   (sublist-subst-datatype equal?
                           [(slist-subst-cps '(a a c a) 'a 'b (list-k)) '((b b c b)) 3]
                           [(slist-subst-cps '(a x a c x a) 'x 'y (init-k)) '(a y a c y a) 3]
                           [(slist-subst-cps '(a (x a () c) (x a)) 'x 'y (init-k)) '(a (y a () c) ( y a)) 4]
                           [(slist-subst-cps '((x x) ((x a)) ((x))) 'x 'y (list-k)) '(((y y) ((y a)) ((y)))) 4]
                           )

   (sublist-subst-tail-positions equal? ; (run-test sublist-subst-tail-positions)
                           [(non-tail-substantial-calls slist-subst-cps) '() 3] ; (run-test sublist-subst-tail-positions 1)
                           [(non-tail-substantial-calls apply-k) '() 2] ; (run-test sublist-subst-tail-positions 2)
                           )

  (free-vars-remove set-equals? ; (run-test free-vars-remove)
                    [(free-vars-cps '((lambda (x) y) (lambda (y) x)) (init-k)) '(x y) 2] ; (run-test free-vars-remove 1)
                    [(free-vars-cps '(x x) (list-k)) '((x)) 2] ; (run-test free-vars-remove 2)
                    [(free-vars-cps '((lambda (x) (x y)) (z (lambda (y) (z y)))) (init-k)) '(y z) 3] ; (run-test free-vars-remove 3)
                    [(free-vars-cps '(lambda (x) y) (init-k)) '(y) 3] ; (run-test free-vars-remove 4)
                    [(free-vars-cps '(x (lambda (x) x)) (init-k)) '(x) 3] ; (run-test free-vars-remove 5)
                    [(free-vars-cps '(x (lambda (x) (y z))) (init-k)) '(x y z) 3] ; (run-test free-vars-remove 6)
                    [(free-vars-cps '(x (lambda (x) y)) (init-k)) '(x y) 3] ; (run-test free-vars-remove 7)
                    [(free-vars-cps '((lambda (y) (lambda (y) y)) (lambda (x) (lambda (x) x))) (init-k)) '() 4] ; (run-test free-vars-remove 8)
                    [(remove-cps 'a '(b c e a d a) (init-k)) '(b c e d a) 2] ; (run-test free-vars-remove 9)
                    [(remove-cps 'b '(b c e a d) (init-k)) '(c e a d) 2] ; (run-test free-vars-remove 10)
                    [(free-vars-cps '(a (b ((lambda (x) (c (d (lambda (y) ((x y) e))))) f))) (init-k)) '(a b c d e f) 4] ; (run-test free-vars-remove 11)
  )

  (free-vars-remove-tail-positions equal? ; (run-test free-vars-remove-tail-positions)
                    [(non-tail-substantial-calls remove-cps) '() 2] ; (run-test free-vars-remove-tail-positions 1)
                    [(non-tail-substantial-calls free-vars-cps) '() 2] ; (run-test free-vars-remove-tail-positions 2)
                    [(non-tail-substantial-calls apply-k) '() 1] ; (run-test free-vars-remove-tail-positions 3)
  )
))

(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))


(implicit-run test) ; run tests as soon as this file is loaded
