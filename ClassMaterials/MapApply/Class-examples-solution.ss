; firsts 

(define firsts
  (lambda (lol)
    (if (null? lol) '() (cons (caar lol) (firsts (cdr lol))))))

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

;; turn a list of two element "pairs" into a list of their sums
;; note these are lists, not scheme "pairs"
(define sum-pairs
  (lambda (pairlist)
    (map (lambda (pair) (+ (car pair) (cadr pair))) pairlist)))

(sum-pairs '((1 2) (3 4))) ;; should yield (3 7)

;; take a list of numbers, and halve all the even ones
;; note that in scheme the % operator is called mod
(define halve-evens
  (lambda (lon)
    (map (lambda (num) (if (even? num) (/ num 2) num)) lon))) 

(halve-evens '(1 2 3 40 60)) ;; should yield (1 1 3 20 30)

;; there is a similar thing called filter which expects a predicate

(filter even? '(1 2 3 4 5 6))

;; takes a list of numbers, and removes all members that are evenly 
;; divisible by a given value
(define remove-divisible-by 
  (lambda (num list)
    (filter (lambda (testnum) (not (zero? (mod testnum num)))) list)))

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
    (let (
      [nonempty-lists (filter (lambda (list) (not (null? list))) llon)]
      [list-max (lambda (list) (apply max list))]) ;; not required, but I think makes it simpler to understand
      (if 
        (null? nonempty-lists)
        #f
        (list-max (map list-max nonempty-lists)))))

