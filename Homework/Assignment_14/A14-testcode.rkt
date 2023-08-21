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

  (syntactic-expansion equal? ; (run-test syntactic-expansion)
    [(eval-one-exp '(cond ((< 4 3) 8) ((< 2 3) 7) (else 8))) 7 2] ; (run-test syntactic-expansion 1)
    [(eval-one-exp '(cond ((< 4 3) 8) ((> 2 3) 7) (else 6))) 6 2] ; (run-test syntactic-expansion 2)
    [(eval-one-exp '(cond (else 8))) 8 1] ; (run-test syntactic-expansion 3)
    [(eval-one-exp '(let ((a (vector 3))) (cond ((= (vector-ref a 0) 4) 5) ((begin (vector-set! a 0 (+ 1 (vector-ref a 0))) (= (vector-ref a 0) 4)) 6) (else 10)))) 6 3] ; (run-test syntactic-expansion 4)
    [(eval-one-exp '(or #f #f 3 #f)) 3 3] ; (run-test syntactic-expansion 5)
    [(eval-one-exp '(or #f #f #f)) #f 1] ; (run-test syntactic-expansion 6)
    [(eval-one-exp '(or)) #f 1] ; (run-test syntactic-expansion 7)
    [(eval-one-exp '(let ((a (vector 5))) (if #t (begin (vector-set! a 0 3) (vector-set! a 0 (+ 3 (vector-ref a 0))) a)))) '#(6) 4] ; (run-test syntactic-expansion 8)
    [(eval-one-exp '(let ((f (lambda (x) (+ 2 (* 3 x))))) (f (let ((f (lambda (x) (f (* 5 x))))) (f 4))))) 188 8] ; (run-test syntactic-expansion 9)
    [(eq? (void) (eval-one-exp '(cond ((< 3 3) "this is false") ((< 2 2) "this is false" )))) #t 3] ; (run-test syntactic-expansion 10)
    [(eval-one-exp '(let* ((x 1) (y (+ x 1))) (if (and (= x 1) (= y 2)) 'correct 'incorrect))) 'correct 3] ; (run-test syntactic-expansion 11)
    [(eval-one-exp ' (let ((a (vector 4))) (or (begin (vector-set! a 0 (+ 2 (vector-ref a 0))) #f) (begin (vector-set! a 0 (+ 7 (vector-ref a 0))) #t)) a)) '#(13) 3] ; (run-test syntactic-expansion 12)
    [(eval-one-exp ' (let ((a (vector 5))) (let ((b (begin (vector-set! a 0 7) (list->vector (cons 4 (vector->list a))))) (a 12)) (list->vector (cons a (vector->list b)))))) '#(12 4 7) 5] ; (run-test syntactic-expansion 13)
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
