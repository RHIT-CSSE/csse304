#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A02.rkt")
(provide get-weights get-names individual-test test)

(define set-equals?  ; are these list-of-symbols equal when
  (lambda (s1 s2)    ; treated as sets?
    (if (or (not (list? s1)) (not (list? s2)))
        #f
        (not (not (and (is-a-subset? s1 s2) (is-a-subset? s2 s1)))))))

(define test (make-test ; (r)
  (choose equal? ; (run-test choose)
    [(choose 0 0) 1 1] ; (run-test choose 1)
    [(choose 3 2) 3 2] ; (run-test choose 2)
    [(choose 10 6) 210 2] ; (run-test choose 3)
  )

  (sum-of-squares equal? ; (run-test sum-of-squares)
    [(sum-of-squares '(1 3 5 7)) 84 3] ; (run-test sum-of-squares 1)
    [(sum-of-squares '()) 0 2] ; (run-test sum-of-squares 2)
  )

  (range equal? ; (run-test range)
    [(range 0 0) '() 2] ; (run-test range 1)
    [(range 0 5) '(0 1 2 3 4) 1] ; (run-test range 2)
    [(range 5 9) '(5 6 7 8) 1] ; (run-test range 3)
    [(range 25 30) '(25 26 27 28 29) 1] ; (run-test range 4)
    [(range 31 32) '(31) 1] ; (run-test range 5)
    [(range 7 4) '() 2] ; (run-test range 6)
  )

  (my-set? equal? ; (run-test my-set?)
    [all-or-nothing 1 ; (run-test my-set? 1)
      ((my-set? '()) #t)
      ((my-set? '(1 1)) #f)]
    [all-or-nothing 1 ; (run-test my-set? 2)
      ((my-set? '(1 2 3)) #t)
      ((my-set? '(1 2 1)) #f)]
    [all-or-nothing 1 ; (run-test my-set? 3)
      ((my-set? '(1 (2 3) (3 2) 5)) #t)
      ((my-set? '(1 3 1 2)) #f)]
    [all-or-nothing 1 ; (run-test my-set? 4)
      ((my-set? '(1 (2 3) (3 2) 5 (3 2))) #f)
      ((my-set? '()) #t)]
    [(my-set? '(r o s e - h u l m a n)) #t 1] ; (run-test my-set? 5)
    [(my-set? '(c o m p u t e r s c i e n c e)) #f 1] ; (run-test my-set? 6)
    [(my-set? '((i) (a m) (a) (s e t))) #t 2] ; (run-test my-set? 7)
    [(my-set? '((i) (a m) (n o t) (a) (s e t) (a m) (i))) #f 2] ; (run-test my-set? 8)
  )

  (union set-equals? ; (run-test union)
    [(union '(a b d e f h j) '(f c e g a)) '(a b c d e f g h j) 2] ; (run-test union 1)
    [(union '(a b c) '(d e)) '(a b c d e) 1] ; (run-test union 2)
    [(union '(a b c) '()) '(a b c) 1] ; (run-test union 3)
    [(union '() '()) '() 1] ; (run-test union 4)
  )

  (cross-product equal? ; (run-test cross-product)
    [(cross-product '(1 3 4) '(3 6 2)) '(-18 10 -3) 3] ; (run-test cross-product 1)
    [(cross-product '(1 2 3) '(2 4 6)) '(0 0 0) 2] ; (run-test cross-product 2)
  )

  (parallel? equal? ; (run-test parallel?)
    [(parallel? '(1 3 4) '(3 6 2)) #f 1] ; (run-test parallel? 1)
    [(parallel? '(1 2 3) '(2 4 6)) #t 1] ; (run-test parallel? 2)
    [(parallel? '(1 2 0) '(2 4 0)) #t 1] ; (run-test parallel? 3)
    [(parallel? '(0 0 1) '(0 0 3)) #t 1] ; (run-test parallel? 4)
    [(parallel? '(0 1 0) '(0 0 1)) #f 1] ; (run-test parallel? 5)
  )

  (collinear? equal? ; (run-test collinear?)
    [(collinear? '(1 2 3) '(4 5 6) '(10 11 12)) #t 3] ; (run-test collinear? 1)
    [(collinear? '(1 2 3) '(4 5 6) '(10 11 13)) #f 2] ; (run-test collinear? 2)
  )
))

(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))


(implicit-run test) ; run tests as soon as this file is loaded
