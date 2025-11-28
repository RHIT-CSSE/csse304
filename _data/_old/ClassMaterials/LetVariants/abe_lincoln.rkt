#lang racket
;; The previous examples are from a previous class (Day 4?)
;; Original version of factorial function:
(require racket/trace)


(define fact     ; standard factorial function.
  (lambda (n)
    (if (zero? n)
            1
            (* n (fact (- n 1))))))
			
			
(define fact-tail   ; tail-recursive version with accumulator
   (lambda (n accum)
      (if (zero? n)
           accum
          (fact-tail (- n 1) (* n accum)))))

(define factorial
    (lambda (n)
    (fact-tail n 1)))

;; Now a Day 5 experiment.
;; For each expression, try to predict what will happen.
;; Then execute we will to see what really happens.
;; Can you explain what you see?
    
(define f fact)

(f 5)

(set! fact
   (lambda (n) 
      "Abe Lincoln elected President"))

(fact 1860)

(f 1860)


; We'd like to write fact so that we can rename it safely:
;   (defnie g fact)
;   (define fact whatever) and still have g work.

;(define fact2
;  (let ([fact-tail2 (lambda (n accum)
;                     (if (zero? n)
;                         accum
;                         (fact-tail2 (- n 1) (* n accum))))])
;    (lambda (n) (fact-tail2 n 1))))

; (fact2 5)

(define fact3 
  (letrec ([fact-tail3 
            (lambda (n prod)
              (if (zero? n)
                  prod
                  (fact-tail3 (sub1 n) 
                         (* n prod))))])
    (lambda (n)  (fact-tail3 n 1))))

;(define f3 fact3)
;(set! fact3 "abe again")
;(f3 5)

; another letrec example

(define odd?
  (letrec ([odd? (lambda (n) ; HINT replace lambda with trace-lambda and see what happens
		   (if (zero? n) 
		       #f 
		       (even? (sub1 n))))]
           [even? (lambda (n) 
                     (if (zero? n) 
                         #t 
                         (odd? (sub1 n))))])
    (lambda (n)
      (odd? n))))

(odd? 6)

;; Named let version of fact

(define fact4
  (lambda (n)
    (let fact-tail4 ([x n] [prod 1])
      (if (zero? x)
	  prod
	  (fact-tail4 (sub1 x) (* prod x))))))

; This is a shorthand for :
(define fact5
  (lambda (n)
    (letrec ([fact-tail5
              (lambda (x prod)
		(if (zero? x)
                    prod
                    (fact-tail5 (sub1 x) 
                                   (* x prod))))])
       (fact-tail5 n 1))))

; Note that let and named-let have the same name
; but very different semantics.
; The difference in syntax is the "name" part
; (in this case, the name is "fact-tail").
; In this example, there is nothing special 
; about the name "fact-tail": it is simply a name
; that I chose for this example.

;  Think of it as initializing x by n and prod by 1,
; then ececuting the body (in this case, the "if").

