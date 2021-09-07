; Version 1. From Day 02 in-class solutions.

(define count-occurrences
  (lambda (n lon)
    (cond [(null? lon) 0]
	  [(= (car lon) n)
	   (add1 (count-occurrences n (cdr lon)))]
	  [else (count-occurrences n (cdr lon))])))

;Version 2,  another approach (with let)

(define count-occurrences
  (lambda (n lon)
    (if (null? lon)
	0
	(let ([cdr-occurrences (count-occurrences n (cdr lon))])
	  (if (= n (car lon))
	      (add1 cdr-occurrences)
	      cdr-occurrences)))))

; Tests
(count-occurrences 3 '())          ; 0
(count-occurrences 2 '(2 3 2 4 2)) ; 3
(count-occurrences 2 '(3 3 2 4 2)) ; 2
(count-occurrences 2 '(2 3 2 4 3)) ; 2
(count-occurrences 7 '(1 2 3 4 5)) ; 0

; Version 3  with accumlator.  Tail-recursive

(define count-occurrences
  (lambda (n lon)
    (count-with-accumulator n lon 0)))

(define count-with-accumulator
  (lambda (n lon acc)
    (if (null? lon)
	acc
	(if (= n (car lon))
	    (count-with-accumulator n (cdr lon) (add1 acc))
	    (count-with-accumulator n (cdr lon) acc)))))

; Version 4: A slightly different code arrangement

(define count-with-accumulator
  (lambda (n lon acc)
    (if (null? lon)
	acc
	(count-with-accumulator n (cdr lon) (if (= n (car lon))
						(add1 acc)
						acc)))))

; Version 1 with letrec
(define count-occurrences
  (lambda (n lon)
    (letrec ([count (lambda (lon2)
		      (cond [(null? lon2) 0]
			    [(= (car lon2) n)
			     (add1 (count (cdr lon2)))]
			    [else (count(cdr lon2))]))])
      (count lon))))


; There is no need to name the inner variable to be different than lon.

(define count-occurrences
  (lambda (n lon)
    (letrec ([count (lambda (lon)
		      (cond [(null? lon) 0]
			    [(= (car lon) n)
			     (add1 (count (cdr lon)))]
			    [else (count (cdr lon))]))])
      (count lon))))

; rewrite this as a named let (the name is count)

(define count-occurrences
  (lambda (n lon)
    (Let count ([lon lon])
	 (cond [(null? lon) 0]
	       [(= (car lon) n)
		(add1 (count (cdr lon)))]
	       [else (count (cdr lon))]))))

; Version 4 with letrec

(define count-occurrences
  (lambda (n lon)
    (letrec ([count (lambda (lon acc)
		      (if (null? lon)
			  acc
			  (count (cdr lon) (if (= n (car lon))
					       (add1 acc)
					       acc))))])
      (count lon 0))))


; Version 4 with named let

(define count-ocurrences
  (lambda (n lon)
    (let count ([lon lon] [acc 0])
      (if (null? lon)
	  acc
	  (count (cdr lon) (if (= n (car lon))
			       (add1 acc)
			       acc))))))
		      
