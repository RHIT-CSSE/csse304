#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "testcode-base.rkt")
(require "sublists-cps.rkt")
(provide get-weights get-names individual-test test)

(require racket/trace)

(define test (make-test ; (r)
 (slist-subst-cps equal?
         [(slist-subst-cps '(a a c a) 'a 'b (list-k)) '((b b c b)) 1]
         [(slist-subst-cps '(a x a c x a) 'x 'y (init-k)) '(a y a c y a) 1]
         [(slist-subst-cps '(a (x a () c) (x a)) 'x 'y (init-k)) '(a (y a () c) ( y a)) 1]
         [(slist-subst-cps '((x x) ((x a)) ((x))) 'x 'y (list-k)) '(((y y) ((y a)) ((y)))) 1]
         )
))

(implicit-run test) ; run tests as soon as this file is loaded
