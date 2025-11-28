#lang racket

; Draw pictures for the following:
(define a '(3 4 5))
(cdr a)
(cddr a)
(cdddr a)
;(cddddr a)
;(cdddddr a)
(define b (cons 2 a))
(define c (cons a b))
(define d (list a b))
(define e (cons 1 (cons 2 3)))
b
c
d
e
; Procedures are not "operators" in Scheme.
;(/ 4 5)
;/
(define /
  (lambda (x y) (* x (+ 1 y))))
(/ 4 5) ; Not a good idea, but it illustrates what / is.
; A useful procedure
(max 4 8 2 7 3)
;(Max 3 2 1)
(max a)
(apply max a)


(define t 6) ; what does it return?
(void)
(list (void))

; everything that is not #f is a "true value"
(if 0 1 2)
(if '() 1 2)
(if (void) 1 2)

; When we write procedures:
;   No mutation
;   Usually assume correct data

(define letter-to-number
  (lambda (letter)
    (if (eq? letter 'A)
	4.0
	(if (eq? letter 'B+)
	    3.5
	    3.0))))
(letter-to-number 'A)
(letter-to-number 'B+)
(letter-to-number 'B)

; End of Day 1

	  

(define letter-to-number2
  (lambda (letter)
    (case letter
      [(A) 4.0]
      [(B+) 3.5]
      [else 3.0])))

(define vector-sum ; 3D vectors as in A1, A2
  (lambda (v1 v2)
    (list (+ (car v1) (car v2))
	  (+ (cadr v1) (cadr v2))
	  (+ (caddr v1) (caddr v2)))))

(vector-sum '(2 3 4) '(5 6 7))

(define largest-in-list
  (lambda (lon)
    (if (null? lon)
	(error 'largest-in-list "list is empty")
	(largest-non-empty (car lon) (cdr lon)))))

(define largest-non-empty
  (lambda (largest-so-far not-seen-yet)
    (if (null? not-seen-yet)
	largest-so-far
	(largest-non-empty (max largest-so-far
				(car not-seen-yet))
			   (cdr not-seen-yet)))))
(largest-in-list '())
(largest-in-list '(3 2 7 8 6))
(largest-in-list '(5 4 3))
(largest-in-list '(3 4 5))
(largest-in-list '(-3))

; A challenge for students (at each table):
; Write (positives? lon).

; procedures can be anonymous.
((lambda (n)
   (* n 3))
 4)

(define make-adder
  (lambda (n)
    (lambda (m)
      (+ m n))))

(define add5 (make-adder 5))
add5
(add5 7)
((make-adder 8) 9)
(((lambda (n)
    (lambda (m)
      (+ m n)))
  3)
 7)
 
 (define count-reflexive-pairs
  (lambda (rel)
    (cond [(null? rel) 0]
	  [(eq? (caar rel)  (cadar rel))
	   (+ 1 (count-reflexive-pairs (cdr rel)))]
	  [else (count-reflexive-pairs (cdr rel))])))

(define count-reflexive-pairs2
  (lambda (rel)
    (if (null? rel)
	0
	(let ([cdr-refl-count (count-reflexive-pairs (cdr rel))])
	  (if (eq? (caar rel)  (cadar rel))
	      (+ 1 cdr-refl-count)
	      cdr-refl-count)))))

(define count-reflexive-pairs3
  (lambda (rel)
    (if (null? rel)
	0
	(+ (count-reflexive-pairs (cdr rel))
	   (if (eq? (caar rel)  (cadar rel))
	       1
	       0)))))
