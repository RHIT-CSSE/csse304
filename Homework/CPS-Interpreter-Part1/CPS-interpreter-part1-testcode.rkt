#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "interpreter.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
  (literals equal? ; (run-test literals)
    [(eval-one-exp ''()) '() 2] ; (run-test literals 1)
    [(eval-one-exp #t) #t 2] ; (run-test literals 2)
    [(eval-one-exp #f) #f 2] ; (run-test literals 3)
    [(eval-one-exp "") '"" 2] ; (run-test literals 4)
    [(eval-one-exp "test") '"test" 2] ; (run-test literals 5)
    [(eval-one-exp ''#(a b c)) #(a b c) 2] ; (run-test literals 6)
    [(eval-one-exp ''#5(a)) #5(a) 2] ; (run-test literals 7)
  )

  (quote equal? ; (run-test quote)
    [(eval-one-exp '(quote ())) '() 2] ; (run-test quote 1)
    [(eval-one-exp '(quote a)) 'a 2] ; (run-test quote 2)
    [(eval-one-exp '(quote (car (a b)))) '(car (a b)) 2] ; (run-test quote 3)
    [(eval-one-exp '(quote (lambda (x) (+ 1 x)))) '(lambda (x) (+ 1 x)) 2] ; (run-test quote 4)
  )

  (if equal? ; (run-test if)
    [(eval-one-exp '(if #t 5 6)) 5 3] ; (run-test if 1)
    [(eval-one-exp '(if 2 (if #f 3 4) 6)) 4 3] ; (run-test if 2)
    [(eval-one-exp '(if #f 5 6)) 6 3] ; (run-test if 3)
    [(eval-one-exp '(if 1 2 3)) 2 3] ; (run-test if 4)
     )

  (primitive-procedures equal? ; (run-test primitive-procedures)
    [(eval-one-exp '(+ (+ 1 2) 3 4)) 10 1] ; (run-test primitive-procedures 1)
    [(eval-one-exp '(- 10 1 (- 5 3))) 7 1] ; (run-test primitive-procedures 2)
    [(eval-one-exp '(* 2 (* 3 4) 2)) 48 1] ; (run-test primitive-procedures 3)
    [(eval-one-exp '(/ 6 2)) 3 1] ; (run-test primitive-procedures 4)
    [(eval-one-exp '(sub1 (add1 10))) 10 1] ; (run-test primitive-procedures 5)
    [(eval-one-exp '(not (zero? 3))) #t 1] ; (run-test primitive-procedures 6)
    [(eval-one-exp '(= 3 4)) #f 1] ; (run-test primitive-procedures 7)
    [(eval-one-exp '(>= 4 3)) #t 1] ; (run-test primitive-procedures 8)
    [(eval-one-exp '(cons 'a 'b)) '(a . b) 1] ; (run-test primitive-procedures 9)
    [(eval-one-exp '(car (cdr '(a b c)))) 'b 1] ; (run-test primitive-procedures 10)
    [(eval-one-exp '(list 'a 'b 'c)) '(a b c) 1] ; (run-test primitive-procedures 11)
    [(eval-one-exp '(null? '())) #t 1] ; (run-test primitive-procedures 12)
    [(eval-one-exp '(eq? 'a 'a)) #t 1] ; (run-test primitive-procedures 13)
    [(eval-one-exp '(equal? 'a 'a)) #t 1] ; (run-test primitive-procedures 14)
    [(eval-one-exp '(length '(a b c d e))) 5 1] ; (run-test primitive-procedures 15)
    [(eval-one-exp '(list->vector '(a b c))) #(a b c) 1] ; (run-test primitive-procedures 16)
    [(eval-one-exp '(list? 'a)) #f 1] ; (run-test primitive-procedures 17)
    [(eval-one-exp '(pair? '(a b))) #t 1] ; (run-test primitive-procedures 18)
    [(eval-one-exp '(vector->list '#(a b c))) '(a b c) 1] ; (run-test primitive-procedures 19)
    [(eval-one-exp '(vector? '#(a b c))) #t 1] ; (run-test primitive-procedures 20)
    [(eval-one-exp '(number? 5)) #t 1] ; (run-test primitive-procedures 21)
    [(eval-one-exp '(caar '((a b) c))) 'a 1] ; (run-test primitive-procedures 23)
    [(eval-one-exp '(cadr '((a b) c))) 'c 1] ; (run-test primitive-procedures 24)
    [(eval-one-exp '(cadar '((a b) c))) 'b 1] ; (run-test primitive-procedures 25)
  )


))

(implicit-run test) ; run tests as soon as this file is loaded
