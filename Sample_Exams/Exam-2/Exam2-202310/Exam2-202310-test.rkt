#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "Exam2-202310.rkt")
(provide get-weights get-names individual-test test)

(require racket/trace)

; we'll use this when we want to assert a variable is unmapped
(define expect-error
  (lambda (code)
    (with-handlers ([symbol? (lambda (x) x)])
      (eval-one-exp code)
      'unexpected-success)))

(define test (make-test ; (r)
 (sublist-subst-datatype equal?
         [(slist-subst-datatype '(a a c a) 'a 'b (list-k)) '((b b c b)) 1]
         [(slist-subst-datatype '(a x a c x a) 'x 'y (init-k)) '(a y a c y a) 1]
         [(slist-subst-datatype '(a (x a () c) (x a)) 'x 'y (init-k)) '(a (y a () c) ( y a)) 1]
         [(slist-subst-datatype '((x x) ((x a)) ((x))) 'x 'y (list-k)) '(((y y) ((y a)) ((y)))) 1]
         )
  (qlet equal? ; (run-test outer)         
         [(eval-one-exp '(qlet (qset x 1) x)) 1 1] ; (run-test qlet 1)
         [(eval-one-exp '(qlet (qset x 1) (qset y 2) (+ x y))) 3 1]
         [(eval-one-exp '(qlet (qset x (list 'a)) (qset y (car x)) (cons y x))) '(a a) 1]
         [(eval-one-exp '(qlet 'a (qset x (list 'a)) (cdr x) (qset y (car x)) (cons y x) (cons 'q x))) '(q a) 1]
         )
  (var-prefix equal? ; (run-test outer)
         ; this just ensures you didn't break basic vars
         [(eval-one-exp '(let ((x 1)) (let ((x 2)) x))) 2 1] ; (run-test prefix-var 1)
         [(expect-error '(let ((pre::x 1)) x)) 'missing-var 1] 
         ; ok onto the real tests
         [(eval-one-exp '(let ((pre::x 1)) (var-prefix pre:: x))) 1 1]
         [(expect-error '(let ((qqq::x 1)) (var-prefix pre:: x))) 'missing-var 1]
         [(expect-error '(var-prefix pre:: (let ((pre::x 1)) x))) 'missing-var 1]
         [(expect-error '(let ((pre::x 1)) (+ (var-prefix pre:: x) x))) 'missing-var 1]
         [(eval-one-exp '(let ((pre::x 1) (pre::y 2)) (var-prefix pre:: (+ x y)))) 3 1]
         [(eval-one-exp '(let ((pre::x 1) (pre::y 2)) (var-prefix pre:: ((lambda (foo) (+ x y foo)) pre::x)))) 4 1]
         [(eval-one-exp '(let ((myfunc (let ((aax 100) (aay 2)) (var-prefix aa (lambda (z) (+ x y z)))))) (myfunc 20))) 122 1]
         [(eval-one-exp '(letrec ((myfunc (lambda (z) (var-prefix bb (+ (x) (y) z))))
                                  (bbx (lambda () 2))
                                  (bby (lambda () 3)))
                           (myfunc 10))) 15 1]
         [(eval-one-exp '(let ((aax 5) (bby 4)) (var-prefix aa (var-prefix bb (- x y))))) 1 1]
         ; though we've mostly tested with let prefixes should work on globals too
         ; however if this is the only thing that doesn't work, we'll probably just take off 2 points
         [(eval-one-exp '(var-prefix li (st 1 2) )) '(1 2) 1]
         )
    
))

(implicit-run test) ; run tests as soon as this file is loaded
