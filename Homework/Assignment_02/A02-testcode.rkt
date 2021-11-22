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

(define test (make-test
  (choose equal?
    [(choose 0 0) 1 1]
    [(choose 3 2) 3 1]
    [(choose 10 6) 210 1]
  )

  (sum-of-squares equal?
    [(sum-of-squares '(1 3 5 7)) 84 1]
    [(sum-of-squares '()) 0 1]
  )

  (range equal?
    [(range 0 0) '() 1]
    [(range 0 5) '(0 1 2 3 4) 1]
    [(range 5 9) '(5 6 7 8) 1]
    [(range 25 30) '(25 26 27 28 29) 1]
    [(range 31 32) '(31) 1]
    [(range 7 4) '() 1]
  )

  (set? equal?
    [(and (set? '()) (not (set? '(1 1)))) #t 1]
    [(and (set? '(1 2 3) ) (not (set? '(1 2 1)))) #t 1]
    [(and (set? '(1 (2 3) (3 2) 5)) (not (set? '(1 3 1 2)))) #t 1]
    [(and (not (set? '(1 (2 3) (3 2) 5 (3 2)))) (set? '())) #t 1]
    [(set? '(r o s e - h u l m a n)) #t 1]
    [(set? '(c o m p u t e r s c i e n c e)) #f 1]
    [(set? '((i) (a m) (a) (s e t))) #t 1]
    [(set? '((i) (a m) (n o t) (a) (s e t) (a m) (i))) #f 1]
  )

  (union set-equals?
    [(union '(a b d e f h j) '(f c e g a)) '(a b c d e f g h j) 1]
    [(union '(a b c) '(d e)) '(a b c d e) 1]
    [(union '(a b c) '()) '(a b c) 1]
    [(union '() '()) '() 1]
  )

  (cross-product equal?
    [(cross-product '(1 3 4) '(3 6 2)) '(-18 10 -3) 1]
    [(cross-product '(1 2 3) '(2 4 6)) '(0 0 0) 1]
  )

  (parallel? equal?
    [(parallel? '(1 3 4) '(3 6 2)) #f 1]
    [(parallel? '(1 2 3) '(2 4 6)) #t 1]
    [(parallel? '(1 2 0) '(2 4 0)) #t 1]
    [(parallel? '(0 0 1) '(0 0 3)) #t 1]
    [(parallel? '(0 1 0) '(0 0 1)) #f 1]
  )

  (collinear? equal?
    [(collinear? '(1 2 3) '(4 5 6) '(10 11 12)) #t 1]
    [(collinear? '(1 2 3) '(4 5 6) '(10 11 13)) #f 1]
  )
))

(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))
