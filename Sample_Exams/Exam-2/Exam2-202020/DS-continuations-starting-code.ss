(load "chez-init.ss")

; The two cps procedures below use the "scheme procedure" representation of continuations.
; Rewrite them so that they use the "define-datatype" representation.
; As in A15, your continuation datatype needs to include init-k and list-k,
; continuations which have no fields and whose applications return the expected things.

; Your code must be in tail form.
; Don't forget that apply-k is a substantial procedure.
; The various continuation constructors are not substantial.


(define flatten-cps
  (lambda (ls k)
    (if (null? ls)
	(apply-k k ls)
	(flatten-cps (cdr ls)
	  (make-k (lambda (v) (if (list? (car ls))
				  (flatten-cps (car ls)
					       (make-k (lambda (u) (append-cps u v k))))
				  (apply-k k (cons (car ls) v)))))))))

(define append-cps 
  (lambda (L1 L2 k)
    (if (null? L1)
	(apply-k k L2)
	(append-cps (cdr L1)
		    L2
		    (make-k (lambda (appended-cdr)
			      (apply-k k (cons (car L1)
					       appended-cdr))))))))


