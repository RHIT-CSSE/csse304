#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A15.rkt")
(provide get-weights get-names individual-test test)

(define set-equals?  ; are these list-of-symbols equal when
  (lambda (s1 s2)    ; treated as sets?
    (if (or (not (list? s1)) (not (list? s2)))
        #f
        (not (not (and (is-a-subset? s1 s2) (is-a-subset? s2 s1)))))))

(define test (make-test ; (r)
  (1st-cps equal? ; (run-test 1st-cps)
    [(1st-cps '((1 2) (3 4)) (make-k cadr)) 2 1] ; (run-test 1st-cps 1)
  )

  (set-of-cps equal? ; (run-test set-of-cps)
    [(set-of-cps '(a c b b c d a b) (make-k length)) 4 2] ; (run-test set-of-cps 1)
    [(set-of-cps '(a c b b c e a b d e) (make-k (lambda (v) (apply max (map (lambda (x) (string->number x 16)) (map symbol->string v)))))) 14 2] ; (run-test set-of-cps 2)
    [(set-of-cps '(a c b b c d a b) (make-k (lambda (v) (member?-cps 'b v (make-k not))))) #f 4] ; (run-test set-of-cps 3)
  )

  (map-cps equal? ; (run-test map-cps)
    [(map-cps (lambda (x k) (apply-k k (add1 x))) '(1 2 3) (make-k reverse)) '(4 3 2) 3] ; (run-test map-cps 1)
    [(let ((add1-cps (make-cps add1))) (map-cps add1-cps '(1 2 3 4) (make-k (lambda (v) (map-cps add1-cps v (make-k (lambda (v) (cons v v)))))))) '((3 4 5 6) 3 4 5 6) 4] ; (run-test map-cps 2)
  )

  (domain-cps equal? ; (run-test domain-cps)
    [(domain-cps '((1 3) (2 4) (1 5) (2 2) (3 6) (2 1) (4 4)) (make-k (lambda (v) (list (length v) (apply max v) (apply min v))))) '(4 4 1) 4] ; (run-test domain-cps 1)
    [(domain-cps '((1 3) (5 4) (1 5) (2 2) (3 6) (2 1)(4 4)) (make-k (lambda (v) (member?-cps 6 v (make-k not))))) #t 3] ; (run-test domain-cps 2)
    [(domain-cps '((1 3) (5 4) (1 5) (2 2) (3 6) (2 14 4)) (make-k (lambda (v) (map-cps (lambda (x k) (member?-cps x v k)) '(1 2 3 4 5 6 7) (make-k reverse))))) '(#f #f #t #f #t #t #t) 4] ; (run-test domain-cps 3)
  )

  (make-cps equal? ; (run-test make-cps)
    [(let ((car-cps (make-cps car))) (car-cps (quote (1 2 3)) (make-k list))) '(1) 3] ; (run-test make-cps 1)
    [(let ((number?-cps (make-cps number?)) (car-cps (make-cps car))) (car-cps (quote (1 2 3)) (make-k (lambda (x) (number?-cps x (make-k (lambda (x) x))))))) #t 4] ; (run-test make-cps 2)
    [((make-cps list?) (quote (1 2 3)) (make-k (lambda (x) (not x)))) #f 4] ; (run-test make-cps 3)
  )

  (andmap-cps equal? ; (run-test andmap-cps)
    [(andmap-cps (make-cps number?) (quote (2 3 4 5)) (make-k list)) '(#t) 2] ; (run-test andmap-cps 1)
    [(andmap-cps (make-cps number?) (quote (2 3 a 5)) (make-k list)) '(#f) 3] ; (run-test andmap-cps 2)
    [(andmap-cps (lambda (L k) (member?-cps (quote a) L k)) (quote ((b a) (c b a))) (make-k list)) '(#t) 3] ; (run-test andmap-cps 3)
    [(let ((t 0)) (andmap-cps (lambda (x k) (set! t (+ 1 t)) (apply-k k x)) (quote (#t #t #t #f #t)) (make-k (lambda (v) (list v t))))) '(#f 4) 3] ; (run-test andmap-cps 4)
    [(begin (define t 0) (andmap-cps (lambda (x k) (set! t (+ 1 t)) (apply-k k x)) (quote (#t #t #t #f #t)) (make-k (lambda (v) (list v t))))) '(#f 4) 6] ; (run-test andmap-cps 5)
  )

  (free-vars-union-remove set-equals? ; (run-test free-vars-union-remove)
    [(free-vars-cps '((lambda (x) y) (lambda (y) x)) (init-k)) '(x y) 2] ; (run-test free-vars-union-remove 1)
    [(free-vars-cps '(x x) (list-k)) '((x)) 2] ; (run-test free-vars-union-remove 2)
    [(free-vars-cps '((lambda (x) (x y)) (z (lambda (y) (z y)))) (init-k)) '(y z) 4] ; (run-test free-vars-union-remove 3)
    [(free-vars-cps '(lambda (x) y) (init-k)) '(y) 3] ; (run-test free-vars-union-remove 4)
    [(free-vars-cps '(x (lambda (x) x)) (init-k)) '(x) 3] ; (run-test free-vars-union-remove 5)
    [(free-vars-cps '(x (lambda (x) (y z))) (init-k)) '(x y z) 3] ; (run-test free-vars-union-remove 6)
    [(free-vars-cps '(x (lambda (x) y)) (init-k)) '(x y) 3] ; (run-test free-vars-union-remove 7)
    [(free-vars-cps '((lambda (y) (lambda (y) y)) (lambda (x) (lambda (x) x))) (init-k)) '() 4] ; (run-test free-vars-union-remove 8)
    [(union-cps '(a c e g r) '(b a g d t) (init-k)) '(c e r b a g d t) 2] ; (run-test free-vars-union-remove 9)
    [(remove-cps 'a '(b c e a d a) (init-k)) '(b c e d a) 2] ; (run-test free-vars-union-remove 10)
    [(remove-cps 'b '(b c e a d) (init-k)) '(c e a d) 2] ; (run-test free-vars-union-remove 11)
    [(free-vars-cps '(a (b ((lambda (x) (c (d (lambda (y) ((x y) e))))) f))) (init-k)) '(a b c d e f) 5] ; (run-test free-vars-union-remove 12)
  )

  (memoized-fib equal? ; (run-test memoized-fib)
    [(letrec ((fib (lambda (n) (if (< n 2) 1 (+ (fib (- n 1)) (fib (- n 2))))))) (let ((fib-memo (memoize fib car equal?))) (map fib-memo (append (make-list 20 27) (make-list 19 26))))) '(317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 317811 196418 196418 196418 196418 196418 196418 196418 196418 196418 196418 196418 196418 196418 196418 196418 196418 196418 196418 196418) 15] ; (run-test memoized-fib 1)
  )

  (memoized-pascal equal? ; (run-test memoized-pascal)
    [(letrec ( (comb (lambda (n k) (if (or (= k n) (zero? k)) 1 (+ (comb (- n 1) k) (comb (- n 1) (- k 1)))))) (map (lambda (proc ls) (if (null? ls) '() (let ((new-car (proc (car ls)))) (cons new-car (map proc (cdr ls)))))))) (let* ((comb-memo (memoize comb (lambda (x) (+ (* 100 (car x)) (min (cadr x) (- (car x) (cadr x))))) (lambda (x y) (and (= (car x) (car y)) (or (= (cadr x) (cadr y)) (= (cadr x) (- (car y) (cadr y)))))))) (pascal-triangle (lambda (max) (let row-loop ((n max) (row-accumulator '())) (if (< n 0) row-accumulator (row-loop (- n 1) (cons (let col-loop ((k n) (col-accumulator '())) (if (< k 0) col-accumulator (col-loop (- k 1) (cons (comb-memo n k) col-accumulator)))) row-accumulator))))))) (map pascal-triangle (range 20)))) '(((1)) ((1) (1 1)) ((1) (1 1) (1 2 1)) ((1) (1 1) (1 2 1) (1 3 3 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1) (1 8 28 56 70 56 28 8 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1) (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1) (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1) (1 10 45 120 210 252 210 120 45 10 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1) (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1) (1 10 45 120 210 252 210 120 45 10 1) (1 11 55 165 330 462 462 330 165 55 11 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1) (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1) (1 10 45 120 210 252 210 120 45 10 1) (1 11 55 165 330 462 462 330 165 55 11 1) (1 12 66 220 495 792 924 792 495 220 66 12 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1) (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1) (1 10 45 120 210 252 210 120 45 10 1) (1 11 55 165 330 462 462 330 165 55 11 1) (1 12 66 220 495 792 924 792 495 220 66 12 1) (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1) (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1) (1 10 45 120 210 252 210 120 45 10 1) (1 11 55 165 330 462 462 330 165 55 11 1) (1 12 66 220 495 792 924 792 495 220 66 12 1) (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1) (1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1) (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1) (1 10 45 120 210 252 210 120 45 10 1) (1 11 55 165 330 462 462 330 165 55 11 1) (1 12 66 220 495 792 924 792 495 220 66 12 1) (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1) (1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14 1) (1 15 105 455 1365 3003 5005 6435 6435 5005 3003 1365 455 105 15 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1) (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1) (1 10 45 120 210 252 210 120 45 10 1) (1 11 55 165 330 462 462 330 165 55 11 1) (1 12 66 220 495 792 924 792 495 220 66 12 1) (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1) (1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14 1) (1 15 105 455 1365 3003 5005 6435 6435 5005 3003 1365 455 105 15 1) (1 16 120 560 1820 4368 8008 11440 12870 11440 8008 4368 1820 560 120 16 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1) (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1) (1 10 45 120 210 252 210 120 45 10 1) (1 11 55 165 330 462 462 330 165 55 11 1) (1 12 66 220 495 792 924 792 495 220 66 12 1) (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1) (1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14 1) (1 15 105 455 1365 3003 5005 6435 6435 5005 3003 1365 455 105 15 1) (1 16 120 560 1820 4368 8008 11440 12870 11440 8008 4368 1820 560 120 16 1) (1 17 136 680 2380 6188 12376 19448 24310 24310 19448 12376 6188 2380 680 136 17 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1) (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1) (1 10 45 120 210 252 210 120 45 10 1) (1 11 55 165 330 462 462 330 165 55 11 1) (1 12 66 220 495 792 924 792 495 220 66 12 1) (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1) (1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14 1) (1 15 105 455 1365 3003 5005 6435 6435 5005 3003 1365 455 105 15 1) (1 16 120 560 1820 4368 8008 11440 12870 11440 8008 4368 1820 560 120 16 1) (1 17 136 680 2380 6188 12376 19448 24310 24310 19448 12376 6188 2380 680 136 17 1) (1 18 153 816 3060 8568 18564 31824 43758 48620 43758 31824 18564 8568 3060 816 153 18 1)) ((1) (1 1) (1 2 1) (1 3 3 1) (1 4 6 4 1) (1 5 10 10 5 1) (1 6 15 20 15 6 1) (1 7 21 35 35 21 7 1) (1 8 28 56 70 56 28 8 1) (1 9 36 84 126 126 84 36 9 1) (1 10 45 120 210 252 210 120 45 10 1) (1 11 55 165 330 462 462 330 165 55 11 1) (1 12 66 220 495 792 924 792 495 220 66 12 1) (1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1) (1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14 1) (1 15 105 455 1365 3003 5005 6435 6435 5005 3003 1365 455 105 15 1) (1 16 120 560 1820 4368 8008 11440 12870 11440 8008 4368 1820 560 120 16 1) (1 17 136 680 2380 6188 12376 19448 24310 24310 19448 12376 6188 2380 680 136 17 1) (1 18 153 816 3060 8568 18564 31824 43758 48620 43758 31824 18564 8568 3060 816 153 18 1) (1 19 171 969 3876 11628 27132 50388 75582 92378 92378 75582 50388 27132 11628 3876 969 171 19 1))) 10] ; (run-test memoized-pascal 1)
  )

  (subst-leftmost equal? ; (run-test subst-leftmost)
    [(subst-leftmost 'k 'b '() eq?) '() 1] ; (run-test subst-leftmost 1)
    [(subst-leftmost 'k 'b '(b b) eq?) '(k b) 2] ; (run-test subst-leftmost 2)
    [(subst-leftmost 'k 'b '(a b a b) eq?) '(a k a b) 4] ; (run-test subst-leftmost 3)
    [(subst-leftmost 'k 'b '(a ((b b)) a b) eq?) '(a ((k b)) a b) 6] ; (run-test subst-leftmost 4)
    [(subst-leftmost 'k 'b '((c d a (e () f b (c b)) (a b)) (b)) eq?) '((c d a (e () f k (c b)) (a b)) (b)) 6] ; (run-test subst-leftmost 5)
    [(subst-leftmost 'b 'a '(c (A e) a d) (lambda (x y) (string-ci=? (symbol->string x) (symbol->string y)))) '(c (b e) a d) 6] ; (run-test subst-leftmost 6)
  )
))

(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))


(implicit-run test) ; run tests as soon as this file is loaded
