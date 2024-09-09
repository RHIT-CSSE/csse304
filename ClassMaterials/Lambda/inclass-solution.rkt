#lang racket

(provide median-of-three add-n-to-each count-occurrences remove-zeros sum-pairs compress)
; Day 2 in-class exercises

; (median-of-three a b c) returns the median of the three numbers.

(define median-of-three
  (lambda (a b c)
    (- (+ a b c) (max a b c) (min a b c))))

; (add-n-to-each n lon) Given a list of numbers lon and a number n,
;   return a new list of numbers where each element is n more than
;   the corresponding element of lon.

(define add-n-to-each
  (lambda (n lon)
    (if (null? lon)
	'()
	(cons (+ n (car lon))
	      (add-n-to-each n (cdr lon))))))

; (count-occurrences n lon) counts how many times n appears in lon

(define count-occurrences
  (lambda (n lon)
    (cond [(null? lon) 0]
	  [(= (car lon) n)
	   (add1 (count-occurrences n (cdr lon)))]
	  [else (count-occurrences n (cdr lon))])))

; I reccommend you try to solve all of these with the same
; cond style we used with count-occurances

; (remove-zeros lon) removes all the zeros from a list of numbers
(define remove-zeros
  (lambda (lon)
    (cond [(null? lon) '()]
          [(eq? (car lon) 0) (remove-zeros (cdr lon))]
          [else (cons (car lon) (remove-zeros (cdr lon)))])))

; (sum-pairs lon) take a list of number and returns a list of half the size
; with each pair added.  If the list has an odd length, the last element
; is left alone.

(define sum-pairs
  (lambda (lon)
    (cond [(null? lon) lon]
          [(null? (cdr lon)) lon]
          [else (cons (+ (car lon) (cadr lon)) (sum-pairs (cddr lon)))])))


; (compress lst) takes a list and returns a list where repeated equal values
; are "compressed" into a value and a number
;
; e.g (compress '(a a b c c c a)) => '(a 2 b 1 c 3 a 1)

(define compress
  (lambda (lst)
    (cond [(null? lst) '()]
          [(null? (cdr lst)) (list (car lst) 1)]
          [(equal? (car lst) (cadr lst))
           (let ((result (compress (cdr lst))))
             (cons (car lst) (cons (add1 (cadr result)) (cddr result))))]
          [else (cons (car lst) (cons 1 (compress (cdr lst))))])))
