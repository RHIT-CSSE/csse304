; We write code in CPS using a continuation ADT	      
; As we did in our first representation of
; environments we represent each continuation by a
; Scheme procedure.
; Then we find that make-k and apply-k are very simple.

(define apply-k
  (lambda (k v)
    (k v)))

(define make-k
  (lambda (v) v))

;; Some procedures to transform to CPS

(define fact-acc
  (lambda (n acc)
    (if (zero? n)
	acc
	(fact-acc (- n 1) (* acc n)))))

(fact-acc 5 1)

(define fact-cps
  (lambda (n k)
    (if (zero? n)
	(apply-k k 1)
	(fact-cps (- n 1)
		  (make-k (lambda (v)
			    (apply-k k (* n v)))))
	)))

(fact-cps 5 (make-k list))
(fact-cps 6 (make-k (lambda (v) (* 10 v))))

(define list-copy-cps
  (lambda (L k)
    (if (null? L)
	(apply-k k '())
	(list-copy-cps (cdr L)
		       (make-k (lambda (copied-cdr)
				 (apply-k k (cons (car L)
						  copied-cdr)))))
	)))

(list-copy-cps '(1 2 3) (make-k reverse))

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
		     

(define intersection  ; convert this to CPS
  (lambda (los1 los2)
    (cond
     [(null? los1) '()]
     [(memq (car los1) los2)
      (cons (car los1)
            (intersection (cdr los1) los2))]
     [else (intersection (cdr los1) los2)])))


(define intersection-cps
  (lambda (los1 los2 k)
    (if (null? los1) 
	(apply-k k '())
	(intersection-cps
	 (cdr los1) 
	 los2
	 (make-k (lambda (cdr-intersection)
		   (memq-cps
		    (car los1)
		    los2
		    (make-k (lambda (is-car-los1-in-los2?)
			    (apply-k
			     k
			     (if is-car-los1-in-los2?
				 (cons (car los1) cdr-intersection)
				 cdr-intersection)))))))))))
	
(intersection-cps
 '(a d e g h) '(s f c h b r a) (make-k list))
    



(define free-vars ; convert to CPS
  (lambda (exp)
    (cond [(symbol? exp) (list exp)]
	  [(eq? (1st exp) 'lambda)       
	   (remove (car (2nd exp)) 
		   (free-vars (3rd exp)))]      
	  [else (union (free-vars (1st exp))
		       (free-vars (2nd exp)))])))

(define 1st car)
(define 2nd cadr)
(define 3rd caddr)

(define free-vars-cps ; convert to CPS
  (lambda (exp k)
    (cond [(symbol? exp) (apply-k k (list exp))]
	  [(eq? (1st exp) 'lambda) 
	   (free-vars-cps (3rd exp)
			  (make-k (lambda (free-vars-in-body)
			    (remove-cps (car (2nd exp))
					free-vars-in-body
					k))))]
	  [else (free-vars-cps (1st exp)
			       (make-k (lambda (rator-free-vars)
					 (free-vars-cps
					  (2nd exp)
					  (make-k
					   (lambda (rand-free-vars)
					     (union-cps
					      rator-free-vars
					      rand-free-vars k)))))))])))
					     

(free-vars-cps '(a (b ((lambda (x) (c (d (lambda (y) ((x y) e))))) f)))
	       (make-k (lambda (v) v)))

(define union-cps
  (lambda (s1 s2 k)
    (if (null? s1)
	(apply-k k s2)
	(union-cps
	 (cdr s1) 
	 s2
	 (make-k
	  (lambda (cdr-union)
	    (memq-cps (car s1)
		      s2
		      (make-k
		       (lambda (isin?)
			 (if isin?
			     (apply-k k cdr-union)
			     (apply-k k (cons (car s1)
					      cdr-union))))))))))))

(union-cps '(3 1 11 6 8 4) '(5 1 8 9 2) (make-k list))

(define remove-cps
  (lambda (element ls k)
    (if (null? ls) 
	(apply-k k '())
	(remove-cps
	 element 
	 (cdr ls)
	 (make-k
	  (lambda (element-free-cdr)
	    (apply-k k
		     (if (eq? (car ls) element)
			 element-free-cdr
			 (cons (car ls)
			       element-free-cdr)))))))))
(remove-cps 'a '(b c e a d a a ) (make-k list))
			 
(define apply-k
  (lambda (k . args)
    (apply k args)))

(define substitute-leftmost
  (lambda (new old slist)
    (subst-left-cps
      new
      old
      slist
      (make-k (lambda (v) v))     ; succeed continuation (called "changed" in cps code)
      (make-k (lambda () slist))  ; fail continuation (called "unchanged" in cps code)
     )))

(define subst-left-cps  ; changed and unchanged are continuations
  (lambda (new old slist changed unchanged)
    (let loop ([slist slist] [changed changed] [unchanged unchanged])
      (cond
       [(null? slist) (apply-k unchanged)]
       [(symbol? (car slist)) 
	(if (eq? (car slist) old)
	    (apply-k changed (cons new (cdr slist)))
	    (loop (cdr slist) 
		  (make-k (lambda (substituted-cdr)
			    (apply-k changed (cons (car slist) substituted-cdr))))
		  unchanged))]
       [else ; car is an s-list
	(loop (car slist)
	      (make-k (lambda (substituted-car)
		(apply-k changed (cons substituted-car (cdr slist)))))
	      (make-k (lambda ()
			(loop (cdr slist) 
			      (make-k (lambda (substituted-cdr)
					(apply-k changed
						 (cons (car slist) substituted-cdr))))
			      unchanged))))]))))


(define subst-left-cps  ; changed and unchanged are continuations
  (lambda (new old slist changed unchanged)
    (let loop ([slist slist] [changed changed] [unchanged unchanged])
      (cond
       [(null? slist)     ]
       
	   ))))

(substitute-leftmost 'b 'a '((a c a) (((a (((b a))))))))
(substitute-leftmost 'b 'a '((d c a) (((a (((b a))))))))
(substitute-leftmost 'b 'a '((d c d) (((a (((b a))))))))
