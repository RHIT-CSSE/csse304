#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A07.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
  (slist-map equal? ; (run-test slist-map)
    [(slist-map symbol? '()) '() 2] ; (run-test slist-map 1)
    [(slist-map symbol? '(a b (c) () d)) '(#t #t (#t) () #t) 2] ; (run-test slist-map 2)
    [(slist-map (lambda (x) (list x 'x)) '(a b (c) () d)) '((a x) (b x) ((c x)) () (d x)) 2] ; (run-test slist-map 3)
    [(slist-map (lambda (x) (let ((s (symbol->string x))) (string->symbol(string-append s s)))) '((b (c) d) e ((a)) () e)) '((bb (cc) dd) ee ((aa)) () ee) 2] ; (run-test slist-map 4)
  )

  (slist-reverse equal? ; (run-test slist-reverse)
    [(slist-reverse '()) '() 2] ; (run-test slist-reverse 1)
    [(slist-reverse '(a b)) '(b a) 2] ; (run-test slist-reverse 2)
    [(slist-reverse '((a b) c)) '(c (b a)) 2] ; (run-test slist-reverse 3)
    [(slist-reverse '((a b) c ((d) e) () f)) '(f () (e (d)) c (b a)) 3] ; (run-test slist-reverse 4)
  )

  (slist-paren-count equal? ; (run-test slist-paren-count)
    [(slist-paren-count '(a)) 2 1] ; (run-test slist-paren-count 1)
    [(slist-paren-count '((a))) 4 2] ; (run-test slist-paren-count 2)
    [(slist-paren-count '((a ((b))))) 8 2] ; (run-test slist-paren-count 3)
    [(slist-paren-count '((a ((b) ())))) 10 2] ; (run-test slist-paren-count 4)
    [(slist-paren-count '((a ((b c d e) () f)))) 10 3] ; (run-test slist-paren-count 5)
  )

  (slist-depth equal? ; (run-test slist-depth)
    [(slist-depth '()) 1 1] ; (run-test slist-depth 1)
    [(slist-depth '(a)) 1 1] ; (run-test slist-depth 2)
    [(slist-depth '((a))) 2 1] ; (run-test slist-depth 3)
    [(slist-depth '(() (((()))))) 5 2] ; (run-test slist-depth 4)
    [(slist-depth '( () (a) ((s b (c) ())))) 4 2] ; (run-test slist-depth 5)
    [(slist-depth '(a (b c (d (x x) e)) ((f () g h)))) 4 3] ; (run-test slist-depth 6)
  )

  (slist-symbols-at-depth equal? ; (run-test slist-symbols-at-depth)
    [(slist-symbols-at-depth '(a (b c) d) 2) '(b c) 1] ; (run-test slist-symbols-at-depth 1)
    [(slist-symbols-at-depth '(a (b c) d) 1) '(a d) 2] ; (run-test slist-symbols-at-depth 2)
    [(slist-symbols-at-depth '(a (b c) d) 3) '() 2] ; (run-test slist-symbols-at-depth 3)
    [(slist-symbols-at-depth '(a (b c (d (x x) e)) ((f () g h)) i) 1) '(a i) 2] ; (run-test slist-symbols-at-depth 4)
    [(slist-symbols-at-depth '(a (b c (d (x x) e)) ((f () g h)) i) 2) '(b c) 2] ; (run-test slist-symbols-at-depth 5)
    [(slist-symbols-at-depth '(a (b c (d (x x) e)) ((f () g h)) i) 3) '(d e f g h) 2] ; (run-test slist-symbols-at-depth 6)
    [(slist-symbols-at-depth '(a (b c (d (x x) e)) ((f () g h)) i) 4) '(x x) 2] ; (run-test slist-symbols-at-depth 7)
  )

  (path-to equal? ; (run-test path-to)
    [(path-to '(a b) 'a) '(car) 1] ; (run-test path-to 1)
    [(path-to '(c a b) 'a) '(cdr car) 2] ; (run-test path-to 2)
    [(path-to '(c () ((a b))) 'a) '(cdr cdr car car car) 3] ; (run-test path-to 3)
    [(path-to '((d (f ((b a)) g))) 'a) '(car cdr car cdr car car cdr car) 3] ; (run-test path-to 4)
    [(path-to '((d (f ((b a)) g))) 'c) #f 1] ; (run-test path-to 5)
  )

  (make-c...r equal? ; (run-test make-c...r)
    [(let ((caddddr (make-c...r "adddd"))) (caddddr '(a (b) (c) (d) (e) (f)))) '(e) 8] ; (run-test make-c...r 1)
    [(list ((make-c...r "") '(a b c)) ((make-c...r "ddaddd") '(a b c ((d e f g) h i j)))) '((a b c) (i j)) 8] ; (run-test make-c...r 2)
    [(list ((make-c...r "a") '(a b c)) ((make-c...r "adddddddddd") '(a b c d e f g h i j k l m))) '(a k) 9] ; (run-test make-c...r 3)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
