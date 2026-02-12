#lang racket
; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "interpreter-cps.rkt")
(provide get-weights get-names individual-test test)

 (define test (make-test ; (r)
               
   (literals equal? ; (run-test literals)
     [(eval-one-exp ''()) '() 1] ; (run-test literals 1)
     [(eval-one-exp "test") '"test" 1] ; (run-test literals 5)
     [(eval-one-exp ''#(a b c)) #(a b c) 1] ; (run-test literals 6)
   )

   (quote equal? ; (run-test quote)
     [(eval-one-exp '(quote ())) '() 1] ; (run-test quote 1)
     [(eval-one-exp '(quote (lambda (x) (+ 1 x)))) '(lambda (x) (+ 1 x)) 1] ; (run-test quote 4)
   )

  (if equal? ; (run-test if)
    [(eval-one-exp '(if #t 5 6)) 5 1] ; (run-test if 1)
    [(eval-one-exp '(if 2 (if #f 3 4) 6)) 4 1] ; (run-test if 2)
    [(eval-one-exp '(if #f 5 6)) 6 1] ; (run-test if 3)
    [(eval-one-exp '(if 1 2 3)) 2 1] ; (run-test if 4)
    [(eval-one-exp '((lambda (x) (+ x 7)) (if #f 2 3))) 10 1] ; (run-test if 5)
  )

   (primitive-procedures equal? ; (run-test primitive-procedures)
     [(eval-one-exp '(not (zero? 3))) #t 1] ; (run-test primitive-procedures 6)
     [(eval-one-exp '(cons 'a 'b)) '(a . b) 1] ; (run-test primitive-procedures 9)
     [(eval-one-exp '(list->vector '(a b c))) #(a b c) 1] ; (run-test primitive-procedures 16)
     [(eval-one-exp '(cadar '((a b) c))) 'b 1] ; (run-test primitive-procedures 25)
     [(eval-one-exp '(list (procedure? list) (procedure? (lambda (x y) (list (+ x y)))) (procedure? 'list))) '(#t #t #f) 1] ; (run-test primitive-procedures 26)
   )

  (lambda equal? ; (run-test lambda-app)
    [(eval-one-exp '((lambda (x) (+ 1 x)) 5)) 6 4] ; (run-test lambda 1)
    [(eval-one-exp '((lambda (x) (+ 1 x) (+ 2 (* 2 x))) 5)) 12 5] ; (run-test lambda 2)
    [(eval-one-exp '((lambda (a b) (set! a 5) a) 2 3)) 5 5]
    [(eval-one-exp '((lambda (a b)
               ((lambda (a b) 
                 ((lambda (f) 
                   (f (+ 3 a b)))
                  (lambda (a) (+ a b))))
                (+ a b) (- a b)))
             56 17)) 154 5] ; (run-test lambda 3)
    [(eval-one-exp '(((lambda (f) ((lambda (x) (f (lambda (y) ((x x) y)))) (lambda (x) (f (lambda (y) ((x x) y)))))) (lambda (g) (lambda (n) (if (zero? n) 1 (* n (g (- n 1))))))) 6)) 720 6] ; (run-test lambda 4)
    [(eval-one-exp '((lambda (Y H)
              ((Y H) (list list (lambda (x) x) 'list)))
             (lambda (f) ((lambda (x) (f (lambda (y) ((x x) y)))) (lambda (x) (f (lambda (y) ((x x) y)))) ))
             (lambda (g) (lambda (x) (if (null? x) '() (cons (procedure? (car x)) (g (cdr x))))))))
              '(#t #t #f) 5] ; (run-test lambda 5)
)
            
  (define equal?
    [(begin (eval-one-exp '(define a 3)) (eval-one-exp 'a)) 3 2]
    [(begin (eval-one-exp '(define a 3))(eval-one-exp '(define a 5))(eval-one-exp 'a)) 5 2]
    [(begin (eval-one-exp '(define fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))))
            (eval-one-exp '(fac 5))) 120 3]    
    [(begin (eval-one-exp  '(define fac (lambda (n) (if (= n 1) 1 (* n (fac (- n 1)))))))
            (eval-one-exp  '(fac 100))) 93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000 5] 
   )

  (set! equal?
    [(begin (eval-one-exp '(define a 3))
            (eval-one-exp '(set! a 42))
            (eval-one-exp 'a)) 42 2]
    [(begin (eval-one-exp '(define a 3))
            (eval-one-exp '(set! a 42))
            (eval-one-exp '(set! a 88))
            (eval-one-exp 'a)) 88 2]
    
    [(eval-one-exp '((lambda (a b) (set! a 5) a) 2 3)) 5 2]
    [(eval-one-exp '((lambda (a b) (lambda () (set! a 5)) a) 2 3)) 2 2]
    [(eval-one-exp '((lambda (a b) ((lambda (c d) (set! a 5)) 6 7) a) 2 3)) 5 2]
    [(eval-one-exp '((lambda (a b) ((lambda (c d) c) ((lambda () (set! a 5) 6)) 7) a) 5 3)) 5 2]    
   )

  (break equal?
    [(eval-one-exp '(+ 3 (break 5))) '(5) 2]
    [(eval-one-exp '(+ 4 (- 7 (break 3 5)))) '(3 5) 2]
    [(eval-one-exp '(+ 3 ((lambda (x) (break (list x (list x)))) 5))) '((5 (5))) 3]
    [(eval-one-exp '(+ 4 (break 5 (break 6 7)))) '(6 7) 3]
    )

))

(implicit-run test) ; run tests as soon as this file is loaded
