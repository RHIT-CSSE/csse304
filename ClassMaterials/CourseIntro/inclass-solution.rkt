#lang racket

; num-positive - returns the number of positive elements in a list
; implement this in a tail recursive way, similar to fact2
;
; (num-positive '(1 -2 0 100 77)) -> 3

(define num-positive-recur
  (lambda (cur lon)
    (cond [(null? lon) cur]
          [(positive? (car lon)) (num-positive-recur (add1 cur) (cdr lon))]
          [else (num-positive-recur cur (cdr lon))])))

(define num-positive
  (lambda (lon)
    (num-positive-recur 0 lon)))

; second largest - returns the second largest element in a list of numbers
;
; (second-largest '( 7 4 5 3 6 2 1)) -> 6
;
; you can assume the list has 2 elements
; implement this in a tail recursive way

(define second-largest
  (lambda (lon)
    (if (> (first lon) (second lon))
        (second-largest-recur (first lon) (second lon) (cddr lon))
        (second-largest-recur (second lon) (first lon) (cddr lon)))))

(define second-largest-recur
  (lambda (biggest big lon)
    (cond [(null? lon) big]
          [(> (car lon) biggest) (second-largest-recur (car lon) biggest (cdr lon))]
          [(> (car lon) big) (second-largest-recur biggest (car lon) (cdr lon))]
          [else (second-largest-recur biggest big (cdr lon))])))