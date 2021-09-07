;; The previous examples are from a previous class (Day 4?)
;; Original version of factorial function:

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

(define fact
   (lambda (n) 
      "Abe Lincoln elected President"))

(fact 1860)

(f 1860)


; We'd like to write fact so that we can rename it safely:
;   (defnie g fact)
;   (define fact whatever) and still have g work.
; It would also be nice to add the efficiency-enhancing acccumulator

; How about this?

(define fact
  (let ([fact-tail (lambda (n accum)
                     (if (zero? n)
                         accum
                         (fact-tail (- n 1) (* n accum))))])
    (lambda (n) (fact-tail n 1))))

(fact 5)

; Solution?

(define fact 
  (letrec ([fact-tail 
            (lambda (n prod)
              (if (zero? n)
                  prod
                  (fact-tail (sub1 n) 
                         (* n prod))))])
    (lambda (n)  (fact-tail n 1))))



; another letrec example

(define odd?
  (letrec ([odd? (lambda (n) 
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

; trace-lambda can be useful

;; Named let version of fact

(define fact
  (lambda (n)
    (let fact-tail ([x n] [prod 1])
      (if (zero? x)
	  prod
	  (fact-tail (sub1 x) (* prod x))))))

; This is a shorthand for :
(define fact
  (lambda (n)
    (letrec ([fact-tail
              (lambda (x prod)
		(if (zero? x)
                    prod
                    (fact-tail (sub1 x) 
                                   (* x prod))))])
       (fact-tail n 1))))

; Note that let and named-let have the same name
; but very different semantics.
; The difference in syntax is the "name" part
; (in this case, the name is "fact-tail").
; In this example, there is nothing special 
; about the name "fact-tail": it is simply a name
; that I chose for this example.

;  Think of it as initializing x by n and prod by 1,
; then ececuting the body (in this case, the "if").



