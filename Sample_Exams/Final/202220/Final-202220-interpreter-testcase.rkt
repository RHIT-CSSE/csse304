#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "Final-202220-interpreter.rkt")
(provide get-weights get-names individual-test test)


(define test (make-test ; (r)
              
              (point equal? ; (run-test point)
                     [(eval-one-exp '(let ((p (make-point 1 2))) p.x)) 1 1] ; (run-test point 1)
                     [(eval-one-exp '(let ((p (make-point 1 2))) p.y)) 2 1] ; (run-test point 2)
                     [(eval-one-exp '(let* ((val 7)
                                            (p (make-point 1 val))) p.y)) 7 1] ; (run-test point 3)
                     [(eval-one-exp '(let* ((p (make-point 1 7))
                                            (p2 p)) p2.y)) 7 1] ; (run-test point 4)
                     [(eval-one-exp '(let ((p (make-point 1 7))
                                           (p2 (make-point 3 4))) (+ p.x p.y p2.x p2.y))) 15 1] ; (run-test point 5)
                     )

              (point-set equal? ; (run-test point-set)
                         [(eval-one-exp '(let ((p (make-point 1 2))) (set! p.x 99) p.x)) 99 1] ; (run-test point-set 1)
                         [(eval-one-exp '(let ((p (make-point 1 2))) (set! p.y 100) p.y)) 100 1] ; (run-test point-set 2)
                         [(eval-one-exp '(let ((p (make-point 1 2))) (set! p.y (+ p.x p.y)) p.y)) 3 1] ; (run-test point-set 3)
                         [(eval-one-exp '(let ((p (make-point 1 2))) (let ((q 100)) (set! p.y (+ q q)) p.y))) 200 1] ; (run-test point-set 4)
                         [(eval-one-exp '(let ((p (make-point 1 2))) (let ((p2 p)) (set! p2.y 300) p.y))) 300 1] ; (run-test point-set 5)
                         [(eval-one-exp '(begin (set! * (make-point 7 8)) (set! *.x 100) (+ *.x *.y))) 108  1] ; (run-test point-set 6)
                         )
              
  ))

(implicit-run test) ; run tests as soon as this file is loaded
