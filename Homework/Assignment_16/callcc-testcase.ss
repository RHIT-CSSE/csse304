;; this nex thing is actually a possible test-case for A16, map and call/cc
(begin
  (eval-one-exp
   '(define stored-k #f))
  (eval-one-exp
   '(define id-with-k-storage
      (lambda (n)
	(if (= n 3)
	    (call/cc (lambda (k)
		       (begin
			 (set! stored-k k)
			 n)))
	    n))))
  (eval-one-exp
   '(define answer
      (map id-with-k-storage '(0 1 2 3 4 5))))
  (eval-one-exp
   '(map (lambda (x)
	   (if (= x 15)
	       (stored-k x)
	       x))
	 '(10 11 12 13 14 15 16 17)))
  (eval-one-exp  'answer)
)
; this is the code to be executred (one expression at a time) in Scheme.

(define stored-k #f)
(define id-with-k-storage
  (lambda (n)
    (if (= n 3)
	(call/cc (lambda (k)
		   (begin
		     (set! stored-k k)
		     n)))
	n)))
(define answer
  (map id-with-k-storage '(0 1 2 3 4 5)))
(map (lambda (x)
       (if (= x 15)
	   (stored-k x)
	   x))
     '(10 11 12 13 14 15 16 17))
answer
