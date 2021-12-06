#lang racket

; firsts 

(define firsts
  (lambda (lol)
    '() ;; NYI
))

; Map unary

(define map-unary
  (lambda (func list)
    '() ;; NYI
  ))

;; use map-unary to simplify firsts

;; The real map is even better because it can handle any number of arguments
(map + '(1 2 3) '(10 100 1000))

;; its power really shines when you realize you can use custom built lambdas

(map (lambda (num) (* -1  num)) '(1 -3 4 -6))

;; OK you try

;; turn a list of two element "pairs" into a list of their sums
;; note these are lists, not scheme "pairs"
(define sum-pairs
  (lambda (pairlist)
    '() ;; NYI
  ))

(sum-pairs '((1 2) (3 4))) ;; should yield (3 7)

;; take a list of numbers, and halve all the even ones
;; note that in scheme the % operator is called modulo
(define halve-evens
  (lambda (pairlist)
    '() ;; NYI
  ))

(halve-evens '(1 2 3 40 60)) ;; should yield (1 1 3 20 30)

;; there is a similar thing called filter which expects a predicate

(filter even? '(1 2 3 4 5 6))

;; takes a list of numbers, and removes all members that are evenly 
;; divisible by a given value
(define remove-divisible-by 
  (lambda (num list)
    '() ;; NYI
  ))

(remove-divisible-by 3 '(1 2 3 4 5 6)) ;; should yield (1 2 4 5)

;; there is also ones called andmap and ormap (not standard scheme)

(define all-positive?
  (lambda (lon)
    (andmap (lambda (num) (> num 0)) lon)))

(all-positive? '(1 2 3)) ;; yields #t
(all-positive? '(1 2 3)) ;; yields #f


;; Last activity

;; Takes a list of lists of numbers.  Some lists may be empty.
;; Returns the largest number in any of the lists.
;; Returns #f if there are no numbers in any of the lists

(define largest-in-lists
  (lambda (llon)
    '()
  ))

(largest-in-lists '((1) (2 3) () () (9 5) ())) ;; 9
(largest-in-lists '(()())) ;; #f