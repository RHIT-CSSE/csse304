(define-syntax my-if
  (syntax-rules (then else)
    [(_ e1 then e2 else e3) ; pattern
     (if e1 e2 e3)] ; template
    [(_ e1 then e2) ;pattern
     (if e1 e2)]))  ; template

(my-if (< 3 4) then  5 else 6)
(my-if (< 3 2) then  5 else 6)
(length (list (my-if (< 3 2) then 4)))


(define-syntax ++
  (syntax-rules ()
    [(_ x) (begin (set! x (+ 1 x))
		  x)]))

(define a 5)
(++ a)
a
(define b (+ 3 (++ a)))
b
a

(define-syntax ++post
  (syntax-rules ()
    [(_ x)
     (let ([temp x])
       (set! x (+ 1 x))
       temp)]))

(define a 5)
(define b (+ 3 (++post a)))
a
b
(++ (+ a 2))

(define-syntax my-and
  (syntax-rules ()
    [(_) #t]
    [(_ exp) exp]
    [(_ e1 e2 ...)
     (if e1
	 (my-and e2 ...)
	 #f)]))

(my-and)
(my-and 4)
(my-and 5 6 7)
(my-and 5 #f 7)
(expand '(my-and 5 #f 7))

(define-syntax for
  (syntax-rules (:)
    [(_ ((init ...) : test : update ...)
	body ...)
     (begin
       init ...
       (let for-loop ()
	 (if test
	     (begin body ...
		    update ...
		    (for-loop)))))]))

(for (((define i 0) (define j 1)) :
      (< i 12) :
      (++ i) (set! j (* j 2)))
     (display i)
     (display "  ")
     (display j)
     (newline))
      
