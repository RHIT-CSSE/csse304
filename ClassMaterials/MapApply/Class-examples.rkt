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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; now lets talk about functions that return functions


; simple
(define make-adder
  (lambda (n)
    (lambda (input)
      (+ n input))))

(define add2 (make-adder 2))
(define add3 (make-adder 3))

; a little trickier
(define loudify-func
  (lambda (name func)
    (lambda arg-list
      (let ((result (apply func arg-list)))
        (display (list name " returns " result))
        result))))

(define loud+ (loudify-func "loud+" +))
      

; a list cleaner in a function that removes particular value
; from a list.  make-list-cleaner makes a cleaner for the given
; value

; (define remove-zeros (make-list-cleaner 0))
; (remove-zeros '(1 0 2 0 3)) => '(1 2 3)


(define make-list-cleaner
  (lambda (value-to-clean)
    'nyi))

(define remove-zeros (make-list-cleaner 0))
(define remove-qs (make-list-cleaner 'q))

; I find students occasionally pass an unreasonable number
; of parameters to functions.

; So I want to make new versions of functions that enforce
; limits.
;
; Write a function that given another function, returns a new
; function that acts like the original but returns 'unreasonable if
; more than 3 paramters are passed.
;
; (define limited+ (make-limited +))
; (limited+ 1 2) => 3
; (limited+ 10 20 30) => 30
; (limited+ 1 2 3 4) => 'unreasonable

(define make-limited
  (lambda (proc)
    'nyi))
      



