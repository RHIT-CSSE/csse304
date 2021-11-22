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
    (if (or (not (is-a-set? s1)) (not (is-a-set? s2)))
        #f
        (not (not (and (is-a-subset? s1 s2) (is-a-subset? s2 s1)))))))

(define test (make-test
  (intersection set-equals?
    [(intersection '(a b d e f h i j) '(h q r i z)) '(i h) 5]
    [(intersection '(g h i) '(j k l)) '() 3]
    [(intersection '(a p t) '()) '() 1]
    [(intersection '() '(g e t)) '() 1]
  )

  (subset? equal?
    [(subset? '(c b) '(a d b e c)) #t 2]
    [(subset? '(c b) '(a d b e)) #f 2]
    [(subset? '(c b) '()) #f 2]
    [(subset? '(c b) '(b c)) #t 1]
    [(subset? '(1 3 4) '(1 2 3 4 5)) #t 1]
    [(subset? '() '()) #t 1]
    [(subset? '() '(x y)) #t 1]
  )

  (relation? equal?
    [(relation? 5) #f 1]
    [(relation? '()) #t 2]
    [(relation? '((a b) (b c))) #t 3]
    [(relation? '((a b) (b a) (a a) (b b))) #t 2]
    [(relation? '((a b) (b c d))) #f 3]
    [(relation? '((a b) (c d) (a b))) #f 2]
    [(relation? '((a b) (c d) "5")) #f 1]
    [(relation? '((a b) . (b c))) #f 1]
  )

  (domain set-equals?
    [(domain '((1 2) (3 4) (1 3) (2 7) (1 6))) '(2 3 1) 6]
    [(domain '()) '() 4]
  )

  (reflexive? eq?
    [(reflexive? '((a a) (b b) (c d) (b c) (c c) (e e) (c a) (d d))) #t 3]
    [(not (reflexive? '((a a) (b b) (c d) (b c) (e e) (c a) (d d)))) #t 3]
    [(not (reflexive? '((a a) (c d) (b c) (c c) (e e) (c a) (d d)))) #t 4]
    [(reflexive? '()) #t 1]
    [(not (reflexive? '((c c) (b b) (c d) (b c) (e e) (c a) (d d)))) #t 4]
  )

  (multi-set? equal?
    [(and (multi-set? '()) (not (multi-set? '(a b)))) #t 2]
    [(and (multi-set? '((a 2))) (not (multi-set? '((a -1))))) #t 1]
    [(and (multi-set? '((a 2)(b 3))) (not (multi-set? '((a 2) (a 3))))) #t 1]
    [(and (not (multi-set? '(a b))) (not (multi-set? '((a 3) b)))) #t 1]
    [(and (not (multi-set? '((a 2) (2 3)))) (multi-set? '((a 2))) (not (multi-set? '(#(a 3))))) #t 1]
    [(and (multi-set? '()) (not (multi-set? '((a 3) b)))) #t 1]
    [(and (multi-set? '()) (not (multi-set? '((a 3.7))))) #t 1]
    [(and (multi-set? '()) (not (multi-set? 5)) (not (multi-set? '((a 2) (b 3) (a 1))))) #t 1]
    [(and (multi-set? '()) (not (multi-set? (list (cons 'a 2)))) (not (multi-set? '((a 2) (a 3))))) #t 1]
    [(and (multi-set? '((a 3))) (not (multi-set? '((a b) (c d))))) #t 1]
  )

  (ms-size equal?
    [(ms-size '()) 0 1]
    [(ms-size '((a 2))) 2 2]
    [(ms-size '((a 2)(b 3))) 5 3]
  )

  (last equal?
    [(last '(1 5 2 4)) 4 1]
    [(last '(c)) 'c 1]
    [(last '(() (()) (()()))) '(()()) 1]
  )

  (all-but-last equal?
    [(all-but-last '(1 5 2 4)) '(1 5 2) 2]
    [(all-but-last '(c)) '() 2]
    [(all-but-last '(() (()) (()()))) '(() (())) 1]
  )
))

(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))

(define is-a-set?
  (lambda (s)
    (cond [(null? s) #t]
          [(not (list? s)) #f]
          [(member (car s) (cdr s)) #f]
          [else (is-a-set? (cdr s))])))
