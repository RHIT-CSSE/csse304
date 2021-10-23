(load "chez-init.ss")

(define-datatype kontinuation kontinuation?
  [init-k]
  [list-k]
  [append-k (L1 list?)
            (k kontinuation?)]	    
  [flat-cdr-k (ls list?)
	      (k kontinuation?)]
  [flat-car-k (flat-cdr list?)
	      (k kontinuation?)]
  )

(define apply-k
  (lambda (k v)
    (cases kontinuation k
	   [flat-cdr-k (ls k)  ; v is the flat cdr
		       (if (list? (car ls))
			   (flatten-cps (car ls)
					(flat-car-k v k))
			   (apply-k k (cons (car ls) v)))]
	   [flat-car-k (flat-cdr k);  v is the flat car
		       (append-cps v flat-cdr k)]
	   [init-k () ; v is flattened entire list
		   v]
	   [list-k () (list v)]
	   [append-k (L1 k) ; v is appended-cdr
		     (apply-k k (cons (car L1) v))]
	  )))
    
(define flatten-cps
  (lambda (ls k)
    (if (null? ls)
	(apply-k k ls)
	(flatten-cps (cdr ls) (flat-cdr-k ls k)))))

(define append-cps                          
  (lambda (L1 L2 k)
    (if (null? L1)
	(apply-k k L2)
	(append-cps (cdr L1) L2 (append-k L1 k)))))

(flatten-cps '() (list-k))
(flatten-cps '(a) (init-k))
(flatten-cps '(a (b)) (init-k))
(flatten-cps '((a) b) (init-k))
(flatten-cps '((a) ()  b) (list-k))
(flatten-cps '(() (((a b (c)) () (d) e) () f)) (init-k))
