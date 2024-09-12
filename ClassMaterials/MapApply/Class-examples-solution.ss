#lang racket

; firsts 

;(define firsts
;  (lambda (lol)
;    (if (null? lol) '() (cons (caar lol) (firsts (cdr lol))))))

; Map unary

(define map-unary
  (lambda (func list)
    (if (null? list) '() (cons (func (car list)) (map-unary func (cdr list))))))

;; use map-unary to simplify firsts
(define firsts
  (lambda (lol)
    (map-unary car lol)))

;; The real map is even better because it can handle any number of arguments
(map + '(1 2 3) '(10 100 1000))

;; its power really shines when you realize you can use custom built lambdas

(map (lambda (num) (* -1  num)) '(1 -3 4 -6))

;; OK you try

;; Very basic - turn a list of lists into a list of lengths

(define list-lengths
  (lambda (lol)
    (map length lol)))

(list-lengths '((a) (b c d) (e f))) ; should yield '(1 3 2)

;; turn a list of two element "pairs" into a list of their sums
;; note these are lists, not scheme "pairs"
(define sum-pairs
  (lambda (pairlist)
    (map (lambda (pair) (+ (car pair) (cadr pair))) pairlist)))

(sum-pairs '((1 2) (3 4))) ;; should yield (3 7)

    
;; take a list of numbers, and halve all the even ones
;; note that in scheme the % operator is called modulo
(define halve-evens
  (lambda (lon)
    (map (lambda (num) (if (even? num) (/ num 2) num)) lon))) 

(halve-evens '(1 2 3 40 60)) ;; should yield (1 1 3 20 30)

; take 3 lists of equal length and return a list of triplets
; each triplet contains 1 element from each list.  Hint:
; remember, map can take more than 1 list as arguments.
(define make-triplets
  (lambda (l1 l2 l3)
    (map list l1 l2 l3)))

(make-triplets '(a b c d e) '(1 2 3 4 5) '(v w x y z))
; should be '((a 1 v) (b 2 w) (c 3 x) (d 4 y) (e 5 z))


; take a list of list of numbers and find the largest, smallest element
; i.e. the largest element that this is the smallest member of it's
; individual list.  This one requires both map and apply (hint: use apply twice).

(define largest-smallest
  (lambda (lol)
    (apply max (map (lambda (x) (apply min x)) lol))))

(largest-smallest '((10 7 2) (11 3 6) (1 25))) ; should yield 3

;; there is a similar thing called filter which expects a predicate

(filter even? '(1 2 3 4 5 6))

;; takes a list of numbers, and removes all members that are evenly 
;; divisible by a given value
(define remove-divisible-by 
  (lambda (num list)
    (filter (lambda (testnum) (not (zero? (modulo testnum num)))) list)))

(remove-divisible-by 3 '(1 2 3 4 5 6)) ;; should yield (1 2 4 5)

;; Takes a list of symbols and numbers and sums the numbers
(define num-sum
  (lambda (lst)
    (apply + (filter number? lst))))

(num-sum '(a 1 b 2 c d 3)) ; should yield 6

;; there is also ones called andmap and ormap (not standard scheme)

(define all-positive?

  (lambda (lon)
    (andmap (lambda (num) (> num 0)) lon)))

(all-positive? '(1 2 3)) ;; yields #t
(all-positive? '(1 2 3)) ;; yields #f

;; Alright last challenge this time I want you to make your own
;; list iterator function.  It should take a list and a predicate
;; and returns 2 lists - one where the predicate was true, one
;; where the predicates was false.  Don't use filter in this solution.
;; Hint - I think its easier to do tail recursive style, using reverse
;; at the end

(define split-list
  (lambda (pred lst)
    (let recur ((lst lst) (yes '()) (no '()))
      (cond [(null? lst) (list (reverse yes) (reverse no))]
            [(pred (car lst)) (recur (cdr lst) (cons (car lst) yes) no)]
            [else (recur (cdr lst) yes (cons (car lst) no))]))))

(split-list even? '(1 2 3 4 6 8 9)) ; yields '((2 4 6 8) (1 3 9))

