#lang racket

; A Java-like ArrayList class. constructors include:
;   (make-array-list) makes an array-list with size 0 and capacity 3
;   (make-array-list cap) makes an array-list with size 0 and capacity cap
;   (make-array-list vec) contents will bw vec, size and capacity (vector-length vec)
; When capacity needs to grow, it should be doubled.


(define make-array-list
  (lambda L
    (let ([v (make-vector 3 #f)] ; default values
	  [capacity 3]
	  [size 0])
      (cond [(null? L) 'do-nothing]
	    [(integer? (car L)) (set! capacity (car L))]
	    [(vector? (car L))
	     (set! v (car L))
	     (set! capacity (vector-length (car L)))
	     (set! size capacity)]
	    [else (error 'array-list-constructor "initial arguments")])
      (letrec  ; helper procedures. We will add some!
	  ([ensure-capacity (lambda (size)
                              'nyi
                              )
                            ])
	(lambda (method . args) ; This is the actual array-list object.
	  (case method
	    [(add)
	     (ensure-capacity (+ 1 size)) 
	     (if (null? (cdr args))
		 (vector-set! v size (car args))
		 'You-will-add-the-other-case) ; to do
	     (set! size (+ size 1))]
	    [(show) `((size ,size) (capacity ,capacity) (v ,v))]))))))

; To do:
; 1. Write code for 'add with an integer argumnt, tells where to add the object. Shift right.
; 2. Add the 'remove method.  Takes an integer argument. shift left.


(let ([al (make-array-list)])
  (al 'add 5)  ; add at end
  (al 'add 4)
  (al 'show))  ; show the instance fields (useful for testing)


(let ([al (make-array-list)])
  (al 'add 5)  ; add at end
  (al 'add 4)
  (al 'add 3)
  (al 'add 2)
  (al 'show))  ; show the instance fields


(let ([al (make-array-list)])
  (al 'add 5)  ; add at end
  (al 'add 4)
  (al 'add 3)
  (al 'add 2)
  (al 'add 7 1); add at index 1
  (al 'show))  ; show the instance fields


; If you have time ...
(let ([al (make-array-list)])
  (al 'add 5)  ; add at end
  (al 'add 4)
  (al 'add 3)
  (al 'add 2)
  (al 'add 7 1); add at index 1
  (al 'add 10 3)
  (display (al 'remove 3)) (newline)
  (al 'show))  ; show the instance fields






       
	    
