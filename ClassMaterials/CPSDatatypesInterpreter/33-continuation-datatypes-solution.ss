;continuations with with apply-k solution

(load "chez-init.ss")

(define-datatype continuation continuation?
  [initk]
  [flatten-cdr-k 
   (ls list?)
   (k continuation?)]
  [flatten-car-k
   (flattened-cdr list?)
   (k continuation?)]
  [append-k (first symbol?)
   (k continuation?)])

(define apply-k
  (lambda (k v)
    (cases continuation k
       [initk ()
		(begin
			(pretty-print v) ; in-class version had val instead of v
			(read-flatten-print))]
       [flatten-cdr-k (ls k) 
			(if (list? (car ls))
				(flatten-cps (car ls) (flatten-car-k v k))
				(apply-k k (cons (car ls) v)))]
       [flatten-car-k (flattened-cdr k)
			(append-cps v flattened-cdr k)]
       [append-k (first k)
			(apply-k k (cons first v))])))
	       
(define flatten-cps
  (lambda (ls k)
    (if (null? ls)
	(apply-k k ls)
	(flatten-cps (cdr ls) (flatten-cdr-k ls k)))))

(define append-cps 
  (lambda (L1 L2 k)
    (if (null? L1)
	(apply-k k L2)
	(append-cps (cdr L1)
		    L2
		    (append-k (car L1) k)))))

(define read-flatten-print
  (lambda ()
    (display "enter slist to flatten: ")
    (let ([slist (read)])
      (unless (eq? slist 'exit)
		(flatten-cps slist (initk)))))) ; in-class version missing
                                        ; parens around initk
