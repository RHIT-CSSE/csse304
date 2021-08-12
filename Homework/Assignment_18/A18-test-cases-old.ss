; Due to the nature of continuations, there will not be test cases on the server.
; paste these expressions one-at-a-time into a Scheme window.
; The assignment document tells how to make this easy if you use Emacs.

; Additional test cases may be added, and if so, there may be 
; adjustments to point values of some existing tests.


(eval-one-exp '
(+ 5 (call/cc 
  (lambda (k) (+ 6 (k 7)))))) ; 1. answer: 12      15 points


(eval-one-exp '
(+ 3 (call/cc (lambda (k) (* 2 5)))))  ; 2. answer: 13  5 points


(eval-one-exp '
(+ 5 (call/cc (lambda (k) (or #f #f (+ 7 (k 4)) #f))))); answer: 9   15 points

(eval-one-exp '
 (+ 2 (call/cc (lambda (k) (+ 3 (let* ([x 5] [y (k 7)]) (k 5))))))
)  ; answer: 9

(eval-one-exp '
 ((car (call/cc list)) (list cdr 1 2 3))
) ; answer: (1 2 3)


(begin
  (reset-global-env)
  (eval-one-exp '
   (define xxx #f))
  (eval-one-exp '
   (+ 5 (call/cc (lambda (k) 
		   (set! xxx k)
		   2))))
  (eval-one-exp '
   (* 7 (xxx 4)))) ; answer: 9                       15  points

(eval-one-exp '(list (call/cc procedure?))) ; answer:  (#t)   10  points

(begin 
  (reset-global-env)
  (eval-one-exp '
   (define strange1
     (lambda (x)
       (display 1)
       (call/cc x)
       (display 2)
       (newline))))
  
  (eval-one-exp '
   (strange1 (call/cc (lambda (k) (k k))))))  ; answer: 112     20  points

(begin
  (eval-one-exp '(define break-out-of-map #f))

  (eval-one-exp '
   (set! break-out-of-map
     (call/cc (lambda (k)
		(lambda (x)
		  (if (= x 7)
		      (k 1000)
		      (+ x 4)))))))

  (eval-one-exp '(map break-out-of-map '(1 3 5 7 9 11)))

  (eval-one-exp 'break-out-of-map))  ; answer:  1000    20 points


(begin
  (eval-one-exp '
   (define jump-into-map #f))

  (eval-one-exp '
   (define do-the-map
     (lambda (x) 
       (map (lambda (v)
	      (if (= v 7)
		  (call/cc (lambda (k) (set! jump-into-map k) 100))
		  (+ 3 v)))
	    x))))   

  (eval-one-exp '
   (list (do-the-map '(3 4 5 6 7 8 9 10)))) ; answer: (6 7 8 9 100 11 12 13)

(eval-one-exp '
 (jump-into-map 987654321))) ; answer: (6 7 8 9 987654321 11 12 13)   20 point2
	  
	 

;----------------   exit

(begin
  (reset-global-env)
  (eval-one-exp '
   (+ 4 (exit-list 5 (exit-list 6 7))) ; answer (6 7)        10 points
))

(begin
  (reset-global-env)
  (eval-one-exp '
   (+  3 (- 2 (exit-list 5)))))   ; answer (5)         10 points

(begin
  (reset-global-env)
  (eval-one-exp '
   (- 7 (if (exit-list 3) 4 5)))) ; answer (3)         10 points

(begin 
  (reset-global-env)		    
  (eval-one-exp '(call/cc (lambda (k) (+ 100 (exit-list (+ 3 (k 12))))))))  ; Answer 12      15 points

(begin
  (reset-global-env)
  (eval-one-exp '(call/cc (lambda (k) (+ 100 (k (+ 3 (exit-list 12)))))))) ; answer (12)     15 points


		
 
