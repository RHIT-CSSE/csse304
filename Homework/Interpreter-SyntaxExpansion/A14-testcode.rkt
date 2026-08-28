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
             
  (primitive-procedures equal? ; (run-test primitive-procedures)
    [(eval-one-exp ' (list (procedure? +) (not (procedure? (+ 3 4))))) '(#t #t) 2] ; (run-test primitive-procedures 1)
    [(eval-one-exp ' (list (procedure? procedure?) (procedure? (lambda(x) x)) (not (procedure? '(lambda (x) x))))) '(#t #t #t) 2] ; (run-test primitive-procedures 2)
    [(eval-one-exp ' (list (procedure? list) (procedure? map) (procedure? apply) (procedure? #t))) '(#t #t #t #f) 2] ; (run-test primitive-procedures 3)
    [(eval-one-exp ' (map procedure? (list map car 3 (lambda(x) x) (lambda x x) ((lambda () 2))))) '(#t #t #f #t #t #f) 2] ; (run-test primitive-procedures 4)
    [(eval-one-exp '(apply list (list 3 4 5))) '(3 4 5) 2] ; (run-test primitive-procedures 5)
    [(eval-one-exp ' (list (vector? (vector 3)) (vector-ref (vector 2 4 5) (vector-ref (vector 2 4 5) 0)))) '(#t 5) 1] ; (run-test primitive-procedures 6)
    [(eval-one-exp '(length '(a b c d e))) 5 1] ; (run-test primitive-procedures 7)
    [(eval-one-exp '(vector->list '#(a b c))) '(a b c) 1] ; (run-test primitive-procedures 8)
    [(eval-one-exp ' (list (procedure? list) (procedure? (lambda (x y) (list (+ x y)))) (procedure? 'list))) '(#t #t #f) 3] ; (run-test primitive-procedures 9)
    [(eval-one-exp '(apply + '(1 2 3 4))) 10 2] ; (run-test primitive-procedures 10)
  )

  (lambda-regression-tests equal? ; (run-test lambda-regression-tests)
    [(eval-one-exp '((lambda (x) (+ 1 x)) 5)) 6 1] ; (run-test lambda-regression-tests 1)
    [(eval-one-exp '((lambda (x) (+ 1 x) (+ 2 (* 2 x))) 5)) 12 1] ; (run-test lambda-regression-tests 2)
    [(eval-one-exp ' ((lambda (a b) (let ((a (+ a b)) (b (- a b))) (let ((f (lambda (a) (+ a b)))) (f (+ 3 a b))))) 56 17)) 154 3] ; (run-test lambda-regression-tests 3)
    [(eval-one-exp ' (((lambda (f) ((lambda (x) (f (lambda (y) ((x x) y)))) (lambda (x) (f (lambda (y) ((x x) y)))))) (lambda (g) (lambda (n) (if (zero? n) 1 (* n (g (- n 1))))))) 6)) 720 4] ; (run-test lambda-regression-tests 4)
    [(eval-one-exp ' (let ((Y (lambda (f) ((lambda (x) (f (lambda (y) ((x x) y)))) (lambda (x) (f (lambda (y) ((x x) y))))))) (H (lambda (g) (lambda (x) (if (null? x) '() (cons (procedure? (car x)) (g (cdr x)))))))) ((Y H) (list list (lambda (x) x) 'list)))) '(#t #t #f) 4] ; (run-test lambda-regression-tests 5)
  )

  (lambda-with-variable-args equal? ; (run-test lambda-with-variable-args)
    [(eval-one-exp '((lambda x (car x) (cdr x)) 'a 'b 'c)) '(b c) 5] ; (run-test lambda-with-variable-args 1)
  )

  (let equal? ; (run-test literals)
    [(eval-one-exp '(let () 3)) 3 1] ; (run-test literals 1)
    [(eval-one-exp '(let () 3 4 5)) 5 1] ; (run-test literals 2)
    [(eval-one-exp '(let ([x 3]) 5 x)) 3 1] ; (run-test literals 3)
    [(eval-one-exp '(let ([x 3][y 4]) (list x y))) '(3 4) 1] ; (run-test literals 4)
    [(eval-one-exp '(let ([x 3][y (let ([z 42]) (+ (- z 1) 1))]) (list x y))) '(3 42) 2] ; (run-test literals 5)
    [(eval-one-exp '(let ([x 3][y 42]) (let ([z y]) (+ z 1)) (let ([z x]) (+ z 1) z))) 3 2] ; (run-test literals 6)
    [(eval-one-exp '(let ([x 3][y 42]) (let ([z y]) (let ([z x]) (list z x y))))) '(3 3 42) 2] ; (run-test literals 7)
  )

   (let* equal? ; (run-test literals)
    [(eval-one-exp '(let* () 3)) 3 1] ; (run-test literals 1)
    [(eval-one-exp '(let* () 3 4 5)) 5 1] ; (run-test literals 2)
    [(eval-one-exp '(let* ([x 3]) 5 x)) 3 1] ; (run-test literals 3)
    [(eval-one-exp '(let* ([x 3][y (+ x 1)]) (list x y))) '(3 4) 2] ; (run-test literals 4)
    [(eval-one-exp '(let* ([x 3][y (let ([z (+ x 1)]) z)]) (list x y))) '(3 4) 2] ; (run-test literals 5)
    [(eval-one-exp '(let* ([x 3][y (+ x 1)]) (let* ([z (+ y 1)][a (+ z 1)]) (let* ([b (+ a 1)]) (list x y z a b))))) '(3 4 5 6 7) 3] ; (run-test literals 6)
  )

   (and equal? ; (run-test literals)
    [(eval-one-exp '(and 3)) 3 1] ; (run-test literals 1)
    [(eval-one-exp '(and)) #t 1] ; (run-test literals 1)
    [(eval-one-exp '(and 3 4 5)) 5 2] ; (run-test literals 2)
    [(eval-one-exp '(and 3 #f 5)) #f 2] ; (run-test literals 3)
    [(eval-one-exp '(and 3 4 #f)) #f 2] ; (run-test literals 4)
    [(eval-one-exp '((lambda (v) (and 3 ((lambda () (vector-set! v 1 42) #f)) 5)) (vector 3 4 5))) #f 3] ; (run-test literals 5)
    [(eval-one-exp '((lambda (v) (and 3 ((lambda () (vector-set! v 1 42) #f)) ((lambda ()(vector-set! v 1 88)))) v) (vector 3 4 5))) '#(3 42 5) 3] ; (run-test literals 6)
  )

   (or equal? ; (run-test literals)
    [(eval-one-exp '(or)) #f 1] ; (run-test literals 1)
    [(eval-one-exp '(or 3)) 3 1] ; (run-test literals 1)
    [(eval-one-exp '(or 3 4 5)) 3 2] ; (run-test literals 2)
    [(eval-one-exp '(or 3 #f 5)) 3 2] ; (run-test literals 3)
    [(eval-one-exp '(or #f 4 5)) 4 2] ; (run-test literals 4)
    [(eval-one-exp '((lambda (v) (or ((lambda () (vector-set! v 1 42) #f)) 5)) (vector 3 4 5))) 5 3] ; (run-test literals 5)
    [(eval-one-exp '((lambda (v) (or 3 ((lambda () (vector-set! v 1 42) #f))) v) (vector 3 4 5))) '#(3 4 5) 3] ; (run-test literals 6)
  )

   (begin equal? ; (run-test literals)
    [(eval-one-exp '(begin)) (void) 1] ; (run-test literals 1)
    [(eval-one-exp '(begin 3)) 3 1] ; (run-test literals 1)
    [(eval-one-exp '(begin 3 4 5)) 5 1] ; (run-test literals 2)
    [(eval-one-exp  '(begin 3 (begin 4 5) 6)) 6 2] ; (run-test literals 3)
    [(eval-one-exp '(begin 3 (begin 4 (begin 5 (begin 6))))) 6 2] ; (run-test literals 4)
    [(eval-one-exp '((lambda (v) (begin (vector-set! v 0 (+ (vector-ref v 0) 1)) (vector-set! v 0 (+ (vector-ref v 0) 1)) v)) (vector 5))) '#(7) 3] ; (run-test literals 5)
  )

  (cond equal? ; (run-test literals)
    [(eval-one-exp '(cond)) (void) 2] ; (run-test literals 1)
    [(eval-one-exp '(cond [3 4])) 4 2] ; (run-test literals 2)
    [(eval-one-exp '(cond [3 4 5])) 5 2] ; (run-test literals 3)
    [(eval-one-exp '((lambda (x) (cond [(= x 3) (+ x 3)][(= x 7) (+ x 7)][else (+ x 9)][(= x 10)(+ x 10)])) 3)) 6 3]
    [(eval-one-exp '((lambda (x) (cond [(= x 3) (+ x 3)][(= x 7) (+ x 7)][else (+ x 9)][(= x 10)(+ x 10)])) 7)) 14 3]
    [(eval-one-exp '((lambda (x) (cond [(= x 3) (+ x 3)][(= x 7) (+ x 7)][else (+ x 9)][(= x 10)(+ x 10)])) 42)) 51 3]
    [(eval-one-exp '((lambda (x) (cond [(= x 3) (+ x 3)][(= x 7) (+ x 7)][else (+ x 9)][(= x 10)(+ x 10)])) 10)) 19 3]
    )
  
  (one-armed-if equal? ; (run-test one-armed-if)
    [(eval-one-exp '(let ((x (vector 7))) (if (< 4 5) (vector-set! x 0 (+ 3 (vector-ref x 0)))) (if (< 4 2) (vector-set! x 0 (+ 6 (vector-ref x 0)))) (vector-ref x 0))) 10 5] ; (run-test one-armed-if 1)
  )

  (quasiquote equal?
              [(begin (quasiquote-enabled?)
                      (eval-one-exp '`,(+ 1 2))) 3 .1]
              [(eval-one-exp '(let ((var 'val))
                                `(foo ,(cons 2 '()) () (,var var)))) '(foo (2) () (val var)) .1]
              [(eval-one-exp '`(1 ,@(list 2 3) 4)) '(1 2 3 4) .1]
              [(eval-one-exp '(let ((var (list 1 2)))
                                `(,@var a ,var b ,@var (c ,@var)))) '(1 2 a (1 2) b 1 2 (c 1 2)) .1]
              [(eval-one-exp '(let ((stx '(let ((x 1) (y 2)) x y (+ x y))))
                                `((lambda ,(map car (cadr stx)) ,@(cddr stx)) ,@(map cadr (cadr stx)))))
               '((lambda (x y) x y (+ x y)) 1 2) .1]
              
              )

  (add-macro-interpreter equal?
                         [(begin
                            (add-macro-interpreter 'varpair '(lambda (stx) `(list (quote ,(cadr stx)) ,(cadr stx))))
                            (eval-one-exp '(let ((x 3))
                                             (varpair x)))) '(x 3) .1]
                         [(begin
                            (add-macro-interpreter 'let2
                                                   '(lambda (stx) `((lambda ,(map car (cadr stx)) ,@(cddr stx)) ,@(map cadr (cadr stx)))))
                            (eval-one-exp '(let2 ((x 1) (y 2)) (+ x y)))) 3 .1]
                         [(eval-one-exp '(begin
                                           (define-syntax varpair2 (lambda (stx) `(list (quote ,(cadr stx)) ,(cadr stx))))
                                           (let ((y 3))
                                             (varpair2 y)))) '(y 3) .1]
                         [(eval-one-exp '(begin
                                           (define-syntax varpair3 (lambda (stx) `(list (quote ,(cadr stx)) ,(cadr stx))))
                                           (define-syntax let3 (lambda (stx) `((lambda ,(map car (cadr stx)) ,@(cddr stx)) ,@(map cadr (cadr stx)))))
                                           (let3 ((y 4))
                                             (varpair3 y)))) '(y 4) .2]
                         )


))

(implicit-run test) ; run tests as soon as this file is loaded
