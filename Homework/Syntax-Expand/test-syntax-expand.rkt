#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "testcode-base.rkt")
(require "interpreter.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)

              
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
  (return-first equal? ; (run-test literals)
    [(eval-one-exp '(return-first)) (void) 1] ; (run-test literals 1)
    [(eval-one-exp '(return-first 3)) 3 1] ; (run-test literals 2)
    [(eval-one-exp '(return-first 3 4 5)) 3 1] ; (run-test literals 3)
    [(eval-one-exp '(return-first (return-first (return-first 3 4 5)))) 3 2] ; (run-test literals 4)
    [(eval-one-exp '((lambda (w) (return-first w
                                               (vector-set! w 0 (+ (vector-ref w 0) 1))
                                               (vector-set! w 0 (+ (vector-ref w 0) 1))))
                     (vector 5))) '#(7) 3] ; (run-test literals 5)
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
    (case equal? ; (run-test literals)
    [(eval-one-exp '(case 3)) (void) 2] ; (run-test literals 1)
    [(eval-one-exp '(case 3 ['(4) 5])) (void) 2] ; (run-test literals 2)
    [(eval-one-exp '(case 3 ['(3) 4])) 4 2] ; (run-test literals 3)
    [(eval-one-exp '(case 3 ['(4 5 3) 6])) 6 3]
    [(eval-one-exp '(case 3 ['(4 5 3) 6 7])) 7 3]
    [(eval-one-exp '(case 8 ['(4 5 3) 6 7] ['(9 8) 10])) 10 3]
    [(eval-one-exp '(case 42 ['(4 5 3) 6 7] ['(9 8) 10][else 24])) 24 3]
    [(eval-one-exp '(case 42 ['(4 5 3) 6 7] ['(9 8) 10][else 24]['(42) 88])) 24 3]
    [(eval-one-exp '((lambda (x) (case (+ x 2) ['(4 5 3) 6 7] ['(9 8) 10][else 24]['(42) 88])) 2)) 7 3]
    [(eval-one-exp '((lambda (x) (case (list x 2) ['(4 5 3) 6 7] ['(9 (2 2) 8) 10][else 24]['(42) 88])) 2)) 10 3]
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
