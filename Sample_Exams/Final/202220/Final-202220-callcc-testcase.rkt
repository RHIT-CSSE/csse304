#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "testcode-base.rkt")
(require "Final-202220-callcc.rkt")
(provide get-weights get-names individual-test test)


; this is some stuff for the lazy func test
(define mylist '())
(define reset-mylist (lambda () (set! mylist '())))
(define prepend-mylist (lambda (val) (set! mylist (cons val mylist)))) 

(define example-code
  (lambda ()
    (prepend-mylist 'a)
    (rest)
    (prepend-mylist 'b)
    (rest)
    (prepend-mylist 'c)
    'done))


(define test (make-test ; (r)
              (do-lazy-func equal? ; (run-test do-lazy-func)
                 [(begin
                    (reset-mylist)
                    (do-lazy-func example-code)
                    (prepend-mylist 'x)
                    mylist
                    )
                  '(x a) 1] ; (run-test do-lazy-func 1)
                 [(begin
                    (reset-mylist)
                    (do-lazy-func example-code)
                    (prepend-mylist 'x)
                    (continue)
                    (prepend-mylist 'y)
                    mylist
                    )
                  '(y b x a) 1] ; (run-test do-lazy-func 2)
                 [(begin
                    (reset-mylist)
                    (do-lazy-func example-code)
                    (prepend-mylist 'x)
                    (continue)
                    (prepend-mylist 'y)
                    (prepend-mylist (continue))                    
                    mylist
                    )
                  '(done c y b x a) 1] ; (run-test do-lazy-func 3)
              )

  ))

(implicit-run test) ; run tests as soon as this file is loaded
