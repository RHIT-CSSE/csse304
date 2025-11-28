; -- Convert to imperative form ----------------------
; -- This puts it into a form where all of the ---------
; -- recursion can be replaced by assignments and "goto"s

(load "chez-init.ss")
(define any? (lambda (x) #t))

(define-datatype continuation continuation?  ; no changes
  [init-k]
  [append-k (a any?) (k continuation?)]
  [rev1-k (car-L any?) (k continuation?)]
  [rev2-k (reversed-cdr (list-of any?)) (k continuation?)])

; global variables take the place of parameters of
; substantial procedures.
(define L)  ; current list
(define k)  ; current continuation
(define a)  ; used for append
(define b)  ; used for append
(define v)  ; 2nd parameter of apply-k application

; The next 3 procedures are from the previous file. 
; Convert them.

(define apply-k
  (lambda () ; was k v
    (trace-it "apply-k   ")
    (cases continuation k
      [init-k () (printf "answer: ~s~n" v)]
      [append-k (a k1)
		(set! v (cons (car a) v))
		(set! k k1)
		(apply-k)]
      [rev1-k (car-L k1)
	      (if (pair? car-L)
		  (begin
		    (set! L car-L)
		    (set! k (rev2-k v k1))		  
		    (reverse*-cps))
		  (begin
		    (set! a v)
		    (set! b (list car-L))
		    (set! k k1)
		    (append-cps)))]
      [rev2-k (reversed-cdr k1)
	      (set! a reversed-cdr)
	      (set! b (list v))
	      (set! k k1)
	      (append-cps)])))

(define reverse*-cps
  (lambda () ; was L k
    (trace-it "reverse*  ")
    (if (null? L)
	(begin
	  (set! v '())
          (apply-k))
	(begin
	  (set! k (rev1-k (car L) k))
	  (set! L (cdr L))
          (reverse*-cps)))))

(define append-cps
  (lambda () ; was a b k
    (trace-it "append    ")
    (if (null? a)
        (begin
	  (set! v b)
	  (apply-k))
        (begin
	  (set! k (append-k a k))
	  (set! a (cdr a))
	  (append-cps)))))


; This driver procedure isn't really substantial,
; So it's okay for it to have a parameter.
(define test-reverse
  (lambda (slist)
    (set! L slist)
    (set! k (init-k))
    (reverse*-cps)))

'(test-reverse
  '(1 ((2 3) () (((4))))))

(define *tracing* #t)

(define trace-it
  (lambda (sym)
    (when *tracing*
      (printf "~a " sym)
      (printf "L=~s" L)
      (printf "  a=~s" a)
      (printf "  b=~s" b)
      (printf "  v=~s~%" v)
      (printf "           k=~s~%" k))))



