#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A15.rkt")
(provide get-weights get-names individual-test test)

(define set-equals?  ; are these list-of-symbols equal when
  (lambda (s1 s2)    ; treated as sets?
    (if (or (not (list? s1)) (not (list? s2)))
        #f
        (not (not (and (is-a-subset? s1 s2) (is-a-subset? s2 s1)))))))

(define test
  (make-test ; (r)

   (sublist-subst-datatype equal?
                           [(slist-subst-cps '(a a c a) 'a 'b (list-k)) '((b b c b)) 3]
                           [(slist-subst-cps '(a x a c x a) 'x 'y (init-k)) '(a y a c y a) 3]
                           [(slist-subst-cps '(a (x a () c) (x a)) 'x 'y (init-k)) '(a (y a () c) ( y a)) 4]
                           [(slist-subst-cps '((x x) ((x a)) ((x))) 'x 'y (list-k)) '(((y y) ((y a)) ((y)))) 4]
                           )
 
  (free-vars-remove set-equals? ; (run-test free-vars-union-remove)
                    [(free-vars-cps '((lambda (x) y) (lambda (y) x)) (init-k)) '(x y) 2] ; (run-test free-vars-union-remove 1)
                    [(free-vars-cps '(x x) (list-k)) '((x)) 2] ; (run-test free-vars-union-remove 2)
                    [(free-vars-cps '((lambda (x) (x y)) (z (lambda (y) (z y)))) (init-k)) '(y z) 3] ; (run-test free-vars-union-remove 3)
                    [(free-vars-cps '(lambda (x) y) (init-k)) '(y) 3] ; (run-test free-vars-union-remove 4)
                    [(free-vars-cps '(x (lambda (x) x)) (init-k)) '(x) 3] ; (run-test free-vars-union-remove 5)
                    [(free-vars-cps '(x (lambda (x) (y z))) (init-k)) '(x y z) 3] ; (run-test free-vars-union-remove 6)
                    [(free-vars-cps '(x (lambda (x) y)) (init-k)) '(x y) 3] ; (run-test free-vars-union-remove 7)
                    [(free-vars-cps '((lambda (y) (lambda (y) y)) (lambda (x) (lambda (x) x))) (init-k)) '() 4] ; (run-test free-vars-union-remove 8)
                    [(remove-cps 'a '(b c e a d a) (init-k)) '(b c e d a) 2] ; (run-test free-vars-union-remove 10)
                    [(remove-cps 'b '(b c e a d) (init-k)) '(c e a d) 2] ; (run-test free-vars-union-remove 11)
                    [(free-vars-cps '(a (b ((lambda (x) (c (d (lambda (y) ((x y) e))))) f))) (init-k)) '(a b c d e f) 4] ; (run-test free-vars-union-remove 12)
  )
))

(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))


(implicit-run test) ; run tests as soon as this file is loaded
