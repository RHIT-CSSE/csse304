; (define-syntax my-let
;	(syntax-rules ()

(my-let ([a 3] [b 5])
	(my-let ([c (+ a b)])
		(+ c 4)))
		
; (my-if x then y else z)

; (define-syntax my-if
;  (syntax-rules 

(my-if (< 3 4) then 5 else 6)
(my-if (< 3 2) then 5 else 6)
(my-if (< 3 2) then 5)
(list (my-if (< 3 2) then 5))

;; (define-syntax ++
;;  (syntax-rules ()


(define a 5)
(++ a)
a
(define b (+ 3 (++ a)))
b
a

;; (define-syntax ++post
;;  (syntax-rules ()
 

(define b (+ 3 (++post a)))
b
a
(++ (* a 2))

;; (define-syntax my-and
;;  (syntax-rules ()

(my-and)
(my-and 4)
(my-and 4 #f 6)
(my-and 4 5 6)
(expand '(my-and 4 5 6))

;; (define-syntax for
;;  (syntax-rules (:)

(for (((define i 0) (define j 1)) :
      (< i 12) :
      (++ i) (set! j (* 2 j)))
     (display i)
     (display "  ")
     (display j)
     (newline))
