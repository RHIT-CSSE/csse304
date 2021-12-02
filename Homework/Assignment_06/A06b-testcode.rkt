#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A06.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
  (let->application equal? ; (run-test let->application)
    [(let->application (quote (let ((a 4) (b 5)) (let ((c b)) (+ a b c))))) '((lambda (a b) (let ((c b)) (+ a b c))) 4 5) 5] ; (run-test let->application 1)
    [(let->application '(let () (+ 2 3))) '((lambda () (+ 2 3))) 2] ; (run-test let->application 2)
    [(let->application '(let ((a 2) (b 1) (c 5)) (let ((d 3)) (+ a b c d)))) '((lambda (a b c) (let ((d 3)) (+ a b c d))) 2 1 5) 3] ; (run-test let->application 3)
  )

  (let*->let equal? ; (run-test let*->let)
    [(let*->let (quote (let* ((x 0)) x))) '(let ((x 0)) x) 3] ; (run-test let*->let 1)
    [(let*->let (quote (let* ((x 50) (y (+ x 50)) (z (+ y 50))) z))) '(let ((x 50)) (let ((y (+ x 50))) (let ((z (+ y 50))) z))) 4] ; (run-test let*->let 2)
    [(let*->let (quote (let* ((x (let ((y 1)) y)) (z x)) x))) '(let ((x (let ((y 1)) y))) (let ((z x)) x)) 3] ; (run-test let*->let 3)
  )

  (qsort equal? ; (run-test qsort)
    [(qsort <= (quote ())) '() 1] ; (run-test qsort 1)
    [(qsort >= (quote (7 2 5 9 4))) '(9 7 5 4 2) 2] ; (run-test qsort 2)
    [(qsort >= (quote (6 3 2 4 1 5))) '(6 5 4 3 2 1) 3] ; (run-test qsort 3)
    [(qsort >= (quote (1 6 5 4 3 2 1 5))) '(6 5 5 4 3 2 1 1) 3] ; (run-test qsort 4)
    [(qsort string>=? (quote ("a" "great" "day" "at" "rose-hulman"))) '("rose-hulman" "great" "day" "at" "a") 3] ; (run-test qsort 5)
    [(qsort < (quote (1 2 2 2 1 1 2 1))) '(1 1 1 1 2 2 2 2) 4] ; (run-test qsort 6)
    [(qsort < (quote (7 7 8 5 6))) '(5 6 7 7 8) 4] ; (run-test qsort 7)
  )

  (sort-list-of-symbols equal? ; (run-test sort-list-of-symbols)
    [(sort-list-of-symbols '(b c d g ab f b r m)) '(ab b b c d f g m r) 13] ; (run-test sort-list-of-symbols 1)
    [(sort-list-of-symbols '(b)) '(b) 1] ; (run-test sort-list-of-symbols 2)
    [(sort-list-of-symbols '()) '() 1] ; (run-test sort-list-of-symbols 3)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
