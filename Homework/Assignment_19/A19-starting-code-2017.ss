(load "chez-init.ss")

(define-datatype kontinuation kontinuation?
  [init-k]
  [flatten-cdr-k (ls list?) (k kontinuation?)]
  [flatten-car-k  (flattened-cdr list?)
		  (k kontinuation?)]
  [append-k (car-L1 symbol?) (k kontinuation?)]
)

(define apply-k 
  (lambda (k v)
	 (cases kontinuation k
	    [init-k ()
	       (pretty-print v)
	       (read-flatten-print)]
	    [flatten-cdr-k (ls k)
	       (if (list? (car ls))
		   (flatten-cps (car ls) (flatten-car-k v  k))
		   (apply-k k (cons (car ls) v)))]
	    [flatten-car-k (flattened-cdr k)
	       (append-cps v flattened-cdr k)]
	    [append-k (car-L1 k)
		(apply-k k (cons car-L1 v))])))


(define append-cps 
  (lambda (L1 L2 k)
    (if (null? L1)
	(apply-k k L2)
	(append-cps (cdr L1)
		    L2
		    (append-k (car L1) k)))))

'(trace append-cps flatten-cps apply-k)


(define read-flatten-print
  (lambda ()
    (display "enter slist to flatten: ")
    (let ([slist (read)])
      (unless (eq? slist 'exit)
	(flatten-cps slist (init-k))))))

(define flatten-cps
  (lambda (ls k)
    (if (null? ls)
	(apply-k k ls)
	(flatten-cps (cdr ls) (flatten-cdr-k ls k)))))


