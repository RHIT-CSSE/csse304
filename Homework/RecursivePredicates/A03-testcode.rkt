#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A03.rkt")
(provide get-weights get-names individual-test test)

(define set-equals?  ; are these list-of-symbols equal when
  (lambda (s1 s2)    ; treated as sets?
    (if (or (not (list? s1)) (not (list? s2)))
        #f
        (not (not (and (is-a-subset? s1 s2) (is-a-subset? s2 s1)))))))

(define test (make-test ; (r)
  (intersection set-equals? ; (run-test intersection)
    [(intersection '(a b d e f h i j) '(h q r i z)) '(i h) 5] ; (run-test intersection 1)
    [(intersection '(g h i) '(j k l)) '() 3] ; (run-test intersection 2)
    [(intersection '(a p t) '()) '() 1] ; (run-test intersection 3)
    [(intersection '() '(g e t)) '() 1] ; (run-test intersection 4)
  )

  (subset? equal? ; (run-test subset?)
    [(subset? '(c b) '(a d b e c)) #t 2] ; (run-test subset? 1)
    [(subset? '(c b) '(a d b e)) #f 2] ; (run-test subset? 2)
    [(subset? '(c b) '()) #f 2] ; (run-test subset? 3)
    [(subset? '(c b) '(b c)) #t 1] ; (run-test subset? 4)
    [(subset? '(1 3 4) '(1 2 3 4 5)) #t 1] ; (run-test subset? 5)
    [(subset? '() '()) #t 1] ; (run-test subset? 6)
    [(subset? '() '(x y)) #t 1] ; (run-test subset? 7)
  )

  (relation? equal? ; (run-test relation?)
    [(relation? 5) #f 1] ; (run-test relation? 1)
    [(relation? '()) #t 2] ; (run-test relation? 2)
    [(relation? '((a b) (b c))) #t 3] ; (run-test relation? 3)
    [(relation? '((a b) (b a) (a a) (b b))) #t 2] ; (run-test relation? 4)
    [(relation? '((a b) (b c d))) #f 3] ; (run-test relation? 5)
    [(relation? '((a b) (c d) (a b))) #f 2] ; (run-test relation? 6)
    [(relation? '((a b) (c d) "5")) #f 1] ; (run-test relation? 7)
    [(relation? '((a b) . (b c))) #f 1] ; (run-test relation? 8)
  )

  (domain set-equals? ; (run-test domain)
    [(domain '((1 2) (3 4) (1 3) (2 7) (1 6))) '(2 3 1) 6] ; (run-test domain 1)
    [(domain '()) '() 4] ; (run-test domain 2)
  )

  (reflexive? eq? ; (run-test reflexive?)
    [(reflexive? '((a a) (b b) (c d) (b c) (c c) (e e) (c a) (d d))) #t 3] ; (run-test reflexive? 1)
    [(not (reflexive? '((a a) (b b) (c d) (b c) (e e) (c a) (d d)))) #t 3] ; (run-test reflexive? 2)
    [(not (reflexive? '((a a) (c d) (b c) (c c) (e e) (c a) (d d)))) #t 4] ; (run-test reflexive? 3)
    [(reflexive? '()) #t 1] ; (run-test reflexive? 4)
    [(not (reflexive? '((c c) (b b) (c d) (b c) (e e) (c a) (d d)))) #t 4] ; (run-test reflexive? 5)
  )

  (multi-set? equal? ; (run-test multi-set?)
    [all-or-nothing 2 ; (run-test multi-set? 1)
      ((multi-set? '()) #t)
      ((multi-set? '(a b)) #f)]
    [all-or-nothing 1 ; (run-test multi-set? 2)
      ((multi-set? '((a 2))) #t)
      ((multi-set? '((a -1))) #f)]
    [all-or-nothing 1 ; (run-test multi-set? 3)
      ((multi-set? '((a 2)(b 3))) #t)
      ((multi-set? '((a 2) (a 3))) #f)]
    [all-or-nothing 1 ; (run-test multi-set? 4)
      ((multi-set? '(a b)) #f)
      ((multi-set? '((a 3) b)) #f)]
    [all-or-nothing 1 ; (run-test multi-set? 5)
      ((multi-set? '((a 2) (2 3))) #f)
      ((multi-set? '((a 2))) #t)
      ((multi-set? '(#(a 3))) #f)]
    [all-or-nothing 1 ; (run-test multi-set? 6)
      ((multi-set? '()) #t)
      ((multi-set? '((a 3) b)) #f)]
    [all-or-nothing 1 ; (run-test multi-set? 7)
      ((multi-set? '()) #t)
      ((multi-set? '((a 3.7))) #f)]
    [all-or-nothing 1 ; (run-test multi-set? 8)
      ((multi-set? '()) #t)
      ((multi-set? 5) #f)
      ((multi-set? '((a 2) (b 3) (a 1))) #f)]
    [all-or-nothing 1 ; (run-test multi-set? 9)
      ((multi-set? '()) #t)
      ((multi-set? (list (cons 'a 2))) #f)
      ((multi-set? '((a 2) (a 3))) #f)]
    [all-or-nothing 1 ; (run-test multi-set? 10)
      ((multi-set? '((a 3))) #t)
      ((multi-set? '((a b) (c d))) #f)]
  )

  (ms-size equal? ; (run-test ms-size)
    [(ms-size '()) 0 1] ; (run-test ms-size 1)
    [(ms-size '((a 2))) 2 2] ; (run-test ms-size 2)
    [(ms-size '((a 2)(b 3))) 5 3] ; (run-test ms-size 3)
  )

  (last equal? ; (run-test last)
    [(last '(1 5 2 4)) 4 1] ; (run-test last 1)
    [(last '(c)) 'c 1] ; (run-test last 2)
    [(last '(() (()) (()()))) '(()()) 1] ; (run-test last 3)
  )

  (all-but-last equal? ; (run-test all-but-last)
    [(all-but-last '(1 5 2 4)) '(1 5 2) 2] ; (run-test all-but-last 1)
    [(all-but-last '(c)) '() 2] ; (run-test all-but-last 2)
    [(all-but-last '(() (()) (()()))) '(() (())) 1] ; (run-test all-but-last 3)
  )
))
(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))


(implicit-run test) ; run tests as soon as this file is loaded
