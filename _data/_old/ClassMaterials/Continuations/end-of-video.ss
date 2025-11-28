; We write some code in CPS (continuation-passing style)

; As we did in our first representation of
; environments, we represent each continuation by a
; Scheme procedure.
; We see that make-k and apply-k are very simple.
;
; Then, as we did with our second representation of environments,
; we use define-datatype to define a continuation variant record
; type where each specific continuation is one of the variants.


;-----------------------------------------------
; CONTINUATIONS REPRESENTED BY SCHEME PROCEDURES
;-----------------------------------------------

(define apply-k
  (lambda (k v)
    (k v)))

(define make-k    ; lambda is the "real" continuation 
  (lambda (v) v)) ; constructor here.

;; Some procedures to transform to CPS.
;; When we get the answer without a substantial call,
;;       we apply k to that answer.
;; When we make a call to a substantial procedure,
;;       we must provide a continuation.

(define fact ; normal version,  NOT tail-recursive
  (lambda (n)
    (if (zero? n)
	1
	(* n (fact (- n 1))))))

(define fact-cps
  (lambda (n k)
    (if (zero? n)
	(apply-k k 1)
	(fact-cps (- n 1)
		  (make-k (lambda (v)
			    (apply-k k (* n v))))))))

(fact-cps 5 (make-k list))
(fact-cps 6 (make-k (lambda (v) (* 10 v))))

(trace make-k apply-k fact-cps list)
(fact-cps 5 (make-k list))

(define list-copy-cps
  (lambda (L k)
    (if (null? L)
	(apply-k k '())
	(list-copy-cps (cdr L)
		       (make-k (lambda (copied-cdr)
				 (apply-k k (cons (car L)
						  copied-cdr))))))))
(list-copy-cps '(1 2 3) (make-k reverse))
(trace list-copy-cps)
; memq is a built-in procedure, so we could treat it as primitive.
; Here I treat it as substantial, in order to enhance the CPS learning process.

(define memq-cps
  (lambda (sym ls k)
    (cond [(null? ls)          
	   (apply-k k #f)] 
	  [(eq? (car ls) sym)
	   (apply-k k #t)] 
	  [else (memq-cps sym (cdr ls) k)])
	 ))


(memq-cps 'a '(b c a d) (make-k list))
(memq-cps 'a '( b c d) (make-k not))
		     

(define intersection  ; intersection of two sets of symbols.
  (lambda (los1 los2)
    (cond
     [(null? los1) '()]
     [(memq (car los1) los2)
      (cons (car los1)
            (intersection (cdr los1) los2))]
     [else (intersection (cdr los1) los2)])))

; I could do this in a style that more closely mirrors the layout
; of the above code.  But I decided instead to write only one call to intersection-cps.
;
; Recall:
;; When  we get the answer without a substantial call, we apply k to that answer.
;; When we make a call to a substantial procedure, we must provide a continuation.

(define intersection-cps
  (lambda (los1 los2 k)
    (if (null? los1) 
	(apply-k k '())
	(intersection-cps (cdr los1) los2
	    (make-k (lambda (cdr-intersection)
		      (memq-cps (car los1) los2
				(make-k (lambda (is-in?)
					  (apply-k k
						   (if is-in?
						       (cons (car los1)
							     cdr-intersection)
						       cdr-intersection)))))))))))
	
(intersection-cps
 '(a d e g h) '(s f c h b r a) (make-k list))

(trace intersection-cps make-k apply-k)

(intersection-cps
 '(a d e g h) '(s f c h b r a) (make-k list))


; ------------------------------------------------------
; CONTINUATIONS AS VARIANT RECORDS using define-datatype.
; ------------------------------------------------------

(load "chez-init.ss")
(define scheme-value? (lambda (x) #t))
(define 1st car)
(define 2nd cadr)
(define 3rd caddr)

; A helper procedure that will be useful:
(define exp?     ; Is obj a lambda-calculus expression? This uses
  (lambda (obj)  ; our original simple definition of lc-expressions.
    (or (symbol? obj)
	(and (list? obj)
	     (or 
	      (and (= (length obj) 3)
		   (eq? (1st obj) 'lambda)
		   (list? (2nd obj))
		   (= (length (2nd obj)) 1)
		   (symbol? (caadr obj))
		   (exp? (3rd obj)))
	      (and (= (length obj) 2)
		   (exp? (1st obj))
		   (exp? (2nd obj))))))))

(define-datatype continuation continuation?
  [init-k] ; These first continuation variants need no fields.
  [list-k]
  [not-k]
  [fact-k (n integer?)
	  (k continuation?)]
  [copy-k (car-L scheme-value?)
	  (k continuation?)]
  
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
     [init-k () v]
     [list-k () (list v)]
     [not-k () (not v)]
     [fact-k (n k)
	(apply-k k (* n v))]
     [copy-k (car-L k)
	     (apply-k k (cons car-L v))]
     
     )))

(define fact-cps
  (lambda (n k)
    (if (zero? n)
	(apply-k k 1)
	(fact-cps (- n 1)
		  (fact-k n k)))))

(fact-cps 5 (init-k))
(fact-cps 6 (list-k))

(define list-copy-cps
  (lambda (L k)
    (if (null? L)
	(apply-k k '())
	(list-copy-cps (cdr L)
		       (copy-k (car L) k)))))

(list-copy-cps '(1 2 3) (list-k))

(define memq-cps
  (lambda (sym ls k)
    (cond [(null? ls)          
	   (apply-k k #f)]
	  [(eq? (car ls) sym)
	   (apply-k k #t)]
	  [else (memq-cps sym (cdr ls) k)])
	 ))

(memq-cps 'a '(b c a d) (list-k))
(memq-cps 'a '( b c d) (not-k))

; Copy the previous intersection-cps here, and rewrite
; it using data-structure continuations.




(intersection-cps
 '(a d e g h) '(s f c h b r a) (list-k))

(trace intersection-cps apply-k list-k int-memq-k cdr-intersection-k)

(intersection-cps
 '(a d e g h) '(s f c h b r a) (list-k))



; This is my solution to the free-vars problem from A10.
; It was for the original lambda-calculus expressions where lambdas
; have only one parameter and applications have only one operand.

(define free-vars ; convert to CPS.  We will first convert 
  (lambda (exp)   ; union and remove.
    (cond [(symbol? exp) (list exp)]
	  [(eq? (1st exp) 'lambda)       
	   (remove (car (2nd exp)) 
		   (free-vars (3rd exp)))]      
	  [else (union (free-vars (1st exp))
		       (free-vars (2nd exp)))])))


(define free-vars-cps ; convert to CPS
  (lambda (exp k)
    (cond [(symbol? exp) ;fill it in
	   ]
	  [(eq? (1st exp) 'lambda) ; fill it in
	   ]
	  [else ; fill it in
	   
	   ])))
					     
(free-vars-cps '(a (b ((lambda (x)
			 (c (d (lambda (y)
				 ((x y) e)))))
		       f)))
	       (init-k))

(trace free-vars-cps free-vars-lambda-k rator-k rand-k
       union-cps remove-cps cdr-union-k union-memq-k
       rem-cdr-k apply-k)

(free-vars-cps '(a (b ((lambda (x)
			 (c (d (lambda (y)
				 ((x y) e)))))
		       f)))
	       (init-k))


(define union-cps ; assumes that both arguments are sets of symbols
  (lambda (s1 s2 k)
    (if (null? s1) ; fill it in
	
)))

(union-cps '(3 1 11 6 8 4) '(5 1 8 9 2) (make-k list))

(define remove-cps ; removes the first occurrence of element in ls
  (lambda (element ls k)
    (if (null? ls) 
	; fill it in
	)))

(remove-cps 'a '(b c e a d a a ) (init-k))
(remove-cps 'b '(b c e a d a a ) (init-k))

