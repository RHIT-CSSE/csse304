#lang racket


; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "typing.rkt")
(provide get-weights get-names individual-test test)

; we'll use this when we want to run a typecheck but we expect it to fail
; do to a typing error.  The error symbol is returned.
(define expect-error
  (lambda (code)
    (with-handlers ([symbol? (lambda (x) x)])
      (typecheck code)
      'unexpected-success)))
  

(define test (make-test ; (r)
  (typecheck equal? ; (run-test typecheck)
    [(typecheck 1) 'num 1] ; (run-test typecheck 1)
    [(typecheck #f) 'bool 1]
    [(typecheck '(lambda bool (x) 2)) '(bool -> num) 2]
    [(typecheck '(lambda bool (x) (lambda num (y) #f))) '(bool -> (num -> bool)) 2]
    [(typecheck '(lambda bool (x) x)) '(bool -> bool) 2]
    [(typecheck '(lambda (bool -> num) (x) (lambda num (y) x))) '((bool -> num) -> (num -> (bool -> num))) 2]
    [(expect-error 'foobar) 'unbound-var 2]
    [(expect-error '((lambda (num -> num) (x) 1) (lambda num (y) x))) 'unbound-var 2]
    [(typecheck 'zero?) '(num -> bool) 2]
    [(typecheck '-) '(num -> (num -> num)) 2]
    [(typecheck '((- 10) 3)) 'num 2]
    [(expect-error '(1 1)) 'bad-procedure 2]
    [(expect-error '(lambda bool (f) (f 1))) 'bad-procedure 2]
    [(typecheck '((lambda num (n) ((- n) 1)) 9)) 'num 2]
    [(expect-error '((lambda num (n) ((- n) 1)) #t)) 'bad-parameter 2]
    [(expect-error '((- #t) 3)) 'bad-parameter 2]
    [(expect-error '((- 10) #f)) 'bad-parameter 2]
    [(typecheck '(if #t 1 2)) 'num 2]
    [(typecheck '((lambda bool (y) (if y (lambda num (x) #t) (lambda num (x) #t))) #f))
     '(num -> bool) 2]
    [(expect-error '(if 3 1 2)) 'bad-if-test 2]
    [(expect-error '(if #f #f 2)) 'bad-if-branches 2]
    [(expect-error '((lambda bool (y) (if y (lambda num (x) 1) (lambda num (x) y))) #f))
     'bad-if-branches 2]
    [(typecheck '(letrec num f (lambda bool (p) (f p)) f)) '(bool -> num) 2]
    [(typecheck '(letrec num f (lambda num (n) (if (zero? n) 77 (f ((- n ) 1)))) (f 3))) 'num 2]
    [(expect-error '(letrec num f (lambda bool (p) p) f)) 'bad-letrec-types 2]
    [(expect-error '(letrec bool f (lambda num (n) (if (zero? n) 77 (f ((- n ) 1)))) (f 3))) 'bad-if-branches 2]
  )

))

(implicit-run test) ; run tests as soon as this file is loaded
