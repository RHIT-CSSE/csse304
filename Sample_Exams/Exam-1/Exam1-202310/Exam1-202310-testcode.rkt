#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "testcode-base.rkt")
(require "exam1-solution.rkt")
(provide get-weights get-names individual-test test)

(define bst-command
  (lambda (lst)
    (let ((it (make-bst-iterator '(5 (3 (1 () ()) (4 () ())) (6 () (8 (7 () ()) ()))))))
      (last (map (lambda (command) (it command)) lst)))))

; 3 handwritten stackable functions for testing the last problem
(define st-plus
  (lambda (lst)
    (if (< (length lst) 2)
        '((error))
        (cons (list (+ (first lst) (second lst)) ) (cddr lst) ))))

(define st-mul
  (lambda (lst)
    (if (< (length lst) 2)
        '((error))
        (cons (list (* (first lst) (second lst)) ) (cddr lst) ))))

; note st-list expects 3 parameters
(define st-list
  (lambda (lst)
    (if (< (length lst) 3)
        '((error))
        (cons (list (list (first lst) (second lst) (third lst)) ) (cdddr lst) ))))


(define test (make-test ; (r)
  (most-common-thing equal? ; (run-test most-common-thing)
                 [(most-common-thing '(a 1 b)) 'symbols 1] ; (run-test most-common-thing 1)
                 [(most-common-thing '(2 1 b)) 'numbers 1]
                 [(most-common-thing '(4 x y z a 1 b)) 'symbols 1]
                 [(most-common-thing '(1 a a 1 b 4)) 'neither 1]
                 [(most-common-thing '(a a a a 1 2 4)) 'symbols 1]
                 [(most-common-thing '(a a 1 2 4)) 'numbers 1]
                 [(most-common-thing '()) 'neither 1]
                 )
    (just-lists equal? ; (run-test just-lists)
                 [(just-lists '((b) (c))) '(()()) 1] ; (run-test just-lists 1)
                 [(just-lists '(a b c d)) '() 1]
                 [(just-lists '((a b (c) d) e)) '((())) 1]
                 [(just-lists '((a b (c) d) e (f ()))) '((())(())) 1]
                 [(just-lists '()) '() 1]
                 [(just-lists '((a) (b) (c) ())) '(()()()()) 1]
   )
    (bst1 equal? ; (run-test bst1)
          ; I made a helper so I writing lists of commands wasn't so annoying
          ; you can understand it if you want, but if not I'm just applying
          ; commands in sequence to the bst on line 16 and returns last
          [(bst-command '(value)) 5 1]
          [(bst-command '(left value)) 3 1]
          [(bst-command '(left left value)) 1 1]
          [(bst-command '(left right value)) 4 1]
          [(bst-command '(right value)) 6 1]
          [(bst-command '(right left value)) '() 1]
          [(bst-command '(right value right value)) 8 1]
          [(bst-command '(right right left value)) 7 1]
          [(bst-command '(right value right right value)) '() 1]
          )
    
    (bst2 equal? ; (run-test bst1)
          ; I made a helper so I writing lists of commands wasn't so annoying
          ; you can understand it if you want, but if not I'm just applying
          ; commands in sequence to the bst on line 16 and returns last
          [(bst-command '(left up value)) 5 1]
          [(bst-command '(left up left right value)) 4 1]
          [(bst-command '(right value up value)) 5 1]
          [(bst-command '(left up right value)) 6 1]
          [(bst-command '(left left value up up right right left value)) 7 1]
          [(bst-command '(left value left value up up right right right value)) '() 1]
          )

    (is-shadowed? equal?
                  [(is-shadowed? 'x '(lambda (x) (lambda (x) y))) #t 1]
                  [(is-shadowed? 'y '(lambda (x) (lambda (x) y))) #f 1]
                  [(is-shadowed? 'x '(lambda (x) (lambda (y) y))) #f 1]
                  [(is-shadowed? 'x '(lambda (x) (lambda (y) (lambda (x) y)))) #t 1]
                  [(is-shadowed? 'y '(lambda (y) (lambda (y) (lambda (x) y)))) #t 1]
                  [(is-shadowed? 'x '(lambda (y) (lambda (x) (lambda (x) y)))) #t 1]
                  [(is-shadowed? 'x '((lambda (x) (lambda (x) y)))) #t 1]
                  [(is-shadowed? 'x '((lambda (x) x) (lambda (x) (lambda (y) y)))) #f 1]
                  [(is-shadowed? 'x '((lambda (x) x) (lambda (x) (y (lambda (x) y))))) #t 1]
                  )
     (make-stackable equal?
                     [((make-stackable * 2) '(3 4)) '((12)) 1]
                     [((make-stackable * 2) '(3 4 5)) '((12) 5) 1]
                     [((make-stackable * 3) '(3 4 5 6 7)) '((60) 6 7) 1]
                     [((make-stackable * 3) '(3 4)) '((error)) 1]
                     [((make-stackable abs 1) '(-3 -4)) '((3) -4) 1]
                     [((make-stackable list 2) '(1 2 3 4)) '(((1 2)) 3 4) 1]
     )

     (stack equal?
                     [((stack st-plus st-mul) '(3 4 5 6)) '((7 30)) 1]
                     [((stack st-plus st-mul) '(3 4 5 6 7 8)) '((7 30) 7 8) 1]
                     [((stack st-plus st-mul) '(3 4 5)) '((7 error)) 1]
                     [((stack st-list st-mul) '(3 4 5 6 7 8)) '(((3 4 5) 42) 8) 1]
                     [((stack st-list st-list) '(3 4 5 6 7 8)) '(((3 4 5) (6 7 8))) 1]
                     [((stack (stack st-list st-mul) st-plus) '(3 4 5 6 7 8 9 10)) '(((3 4 5) 42 17) 10) 1]
                     [((stack st-list (stack st-mul st-plus)) '(3 4 5 6 7 8 9 10)) '(((3 4 5) 42 17) 10) 1]
                     [((stack (stack st-plus st-plus) st-plus) '(3 4 5 6 7 8 9 10)) '((7 11 15) 9 10) 1]
                     [((stack (stack st-list st-mul) st-plus) '(3 4 5 6 7 8)) '(((3 4 5) 42 error)) 1]
                     [((stack (stack st-list st-mul) st-plus) '(3 4 5 6)) '(((3 4 5) error error)) 1]
                     [((stack (stack st-list st-mul) st-plus) '()) '((error error error)) 1]
     )
   ))

(implicit-run test) ; run tests as soon as this file is loaded
