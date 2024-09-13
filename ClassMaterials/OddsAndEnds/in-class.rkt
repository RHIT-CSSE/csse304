
; simple
(define make-adder
  (lambda (n)
    (lambda (input)
      (+ n input))))

(define add2 (make-adder 2))
(define add3 (make-adder 3))

; a little trickier
(define loudify-func
  (lambda (name func)
    (lambda arg-list
      (let ((result (apply func arg-list)))
        (display (list name " returns " result))
        result))))

(define loud+ (loudify-func "loud+" +))
      

; a list cleaner in a function that removes particular value
; from a list.  make-list-cleaner makes a cleaner for the given
; value  Hint: easiest with filter.

; (define remove-zeros (make-list-cleaner 0))
; (remove-zeros '(1 0 2 0 3)) => '(1 2 3)


(define make-list-cleaner
  (lambda (value-to-clean)
    'nyi))

(define remove-zeros (make-list-cleaner 0))
(define remove-qs (make-list-cleaner 'q))

; I find students occasionally pass an unreasonable number
; of parameters to functions.

; So I want to make new versions of functions that enforce
; limits.
;
; Write a function that given another function, returns a new
; function that acts like the original but returns 'unreasonable if
; more than 3 paramters are passed.
;
; (define limited+ (make-limited +))
; (limited+ 1 2) => 3
; (limited+ 10 20 30) => 60
; (limited+ 1 2 3 4) => 'unreasonable

(define make-limited
  (lambda (proc)
    'nyi))
