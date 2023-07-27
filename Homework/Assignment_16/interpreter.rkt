#lang racket

(provide eval-one-exp y2 advanced-letrec)

(define eval-one-exp
  (lambda (x) 'nyi))

;; This is the starting code for the Y Combinator final
;; 1 point question.  Dump the y2 and advanced-letrec
;; into your interpreter to get the tests working.
;;
;; Only attempt the question if you are feeling very daring.

(define my-*p
  (lambda (self)
    (lambda (num times)
      (if (zero? times)
          0
          (+ num (self num (sub1 times)))))))

; The Y Combinator: A function that takes a function
; and returns a recursive version of that function

(define yp
  (lambda (self)
    (lambda (f)
      (f (lambda params
         (apply ((self self) f) params)))
    )))

(define y
  (yp yp))

(define my-*
  (y my-*p))



(define-syntax (basic-letrec stx)
   (syntax-case stx ()
     [(basic-letrec prod-name prod-body letrec-body)
      #'(let ((prod-name (y (lambda (prod-name) prod-body))))
          letrec-body)]))

(basic-letrec my-*2 (lambda (num times)
                      (if (zero? times)
                          0
                          (+ num (my-*2 num (sub1 times)))))
              (my-*2 3 4))

(define my-odd?
  (lambda (my-odd? my-even?)
    (lambda (num)
      (if (zero? num)
          #f
          (my-even? (sub1 num))))))
                      
(define my-even?
  (lambda (my-odd? my-even?)
    (lambda (num)
      (if (zero? num)
          #t
          (my-odd? (sub1 num))))))

;; STEP 1 first hand code y2

(define y2
  (basic-letrec y2 (lambda (which f1 f2)
                     (which (lambda params
                              (apply (y2 f1 f1 f2) params))
                            (lambda params
                              (apply (y2 f2 f1 f2) params))))
                y2))

(define good-odd?
  (y2 my-odd? my-odd? my-even?))

(define good-even?
  (y2 my-even? my-odd? my-even?))


(define-syntax (advanced-letrec stx)
  (syntax-case stx ()
    [(advanced-letrec ((fun-name fun-body)...) letrec-body)
     #'(basic-letrec y* (lambda (which fun-name ...)
                          (which (lambda params
                                   (apply (y* fun-name fun-name ...) params)) ...))
                     (let ((fun-name (lambda (fun-name ...)
                                       fun-body)) ...)
                       (let ((fun-name (y* fun-name fun-name ...)) ...)
                         letrec-body)))]))

; just an example for you to see advanced letrec in action

(advanced-letrec
 ((odd-last? (lambda (num)
               (if (zero? num)
                   #f
                   (even-last? (sub1 num)))))
  (even-last? (lambda (num)
                (if (zero? num)
                    #t
                    (odd-last? (sub1 num))))))
 (even-last? 6))

