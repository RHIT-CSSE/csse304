#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "Final-202420.rkt")
(provide get-weights get-names individual-test test)

(define expect-raise
  (lambda (exp)
    (with-handlers ([symbol? (lambda (sym) sym)])
      (letset-type exp)
      'no-raise)))

(define test (make-test ; (r)


              (macro-myloop equal? 
                      [(call/cc (lambda (k) (myloop #t 42 k 7))) 42 1]
                      [(call/cc (lambda (k) (let ([n 3]) (myloop (= n 0) n k (set! n (- n 1)))))) 0 1]
                      [(call/cc (lambda (k) (let ([n 3][count 0]) (myloop (= n 0) count k (set! n (- n 1)) (set! count (+ count 2)))))) 6 1] 
                      [(call/cc (lambda (k) (+ (let ([n 3][count 0]) (myloop (= n 0) count k (set! n (- n 1)) (set! count (+ count 3)))) 21))) 9 1]                                                               
                      [(+ (call/cc (lambda (k) (let ([n 3][count 0]) (myloop (= n 0) count k (set! n (- n 1)) (set! count (+ count 3)))))) 21)  30 1]
                      )

      (typing-letset equal?
          [(letset-type #t) 'bool 1]
          [(letset-type 3) 'num 1]
          [(expect-raise 'foo) 'unknown-variable 1]
          [(expect-raise '(set! x 1)) 'unknown-variable 1]
          [(letset-type '(let ((x 1)) x)) 'num 1]
          [(expect-raise '(let ((x 1)) (set! x #t))) 'bad-set 1]
          [(letset-type '(let ((x 1)(y #t)) x y)) 'bool 1]
          [(letset-type '(let ((x 1)(y #t)) x y (set! y #f))) 'void 1]
          [(expect-raise '(let ((x 1)(y #t)) x y (set! y 1))) 'bad-set 1]
          [(expect-raise '(let ((x 1)(y #t)) x y (set! x #t))) 'bad-set 1]
          [(letset-type '(let ((x 1)(y (let ((q 3)) q))) x y)) 'num 1]
          [(expect-raise '(let ((x 1)(y (let ((q 3)) q))) q y)) 'unknown-variable 1]
          [(letset-type '(let ((x 1)) (let ((y x)) y))) 'num 1]
          [(letset-type '(let ((x 1)) (let ((y (set! x 3))) y))) 'void 1]
          [(letset-type '(let ((x 1)) (let ((y 1)) (let ((z #t)) z)))) 'bool 1 ]
          [(letset-type '(let ((x 1)) (let ((y 1)) (let ((z #t)) y)))) 'num 1]
          [(letset-type '(let ((x 1)) (let ((y 1)) (let ((z #t)) x)))) 'num 1]
          [(expect-raise '(let ((x 1)) (let ((y 1)) (let ((z #t)) a)))) 'unknown-variable 1]
          [(letset-type '(let ((x 1)) (let ((y 1)) (let ((z #t)) (set! x 3))))) 'void 1]
          [(expect-raise '(let ((x 1)) (let ((y 1)) (let ((z #t)) (set! x #f))))) 'bad-set 1]
          [(expect-raise '(let ((x 1)) (let ((y 1)) (let ((z #t)) (set! y #f))))) 'bad-set 1]
          [(letset-type '(let ((x 1)) (let ((y x)) (set! x 3) (set! y 3)))) 'void 1]
          [(letset-type '(let ((x 1)) (let ((x #t)) x))) 'bool 1]
          [(letset-type '(let ((x 1)) (let ((x #t)) x) x)) 'num 1]
          [(letset-type '(let ((x 1)) (let ((x #t)) (set! x #f) x) x (set! x 3))) 'void 1]
          [(expect-raise '(let ((x #t)) (let ((x 1)) (set! x #f) x) x)) 'bad-set 1]
          [(expect-raise '(let ((x 1)) (let ((x #t)) (set! x #f) x) x (set! x #f))) 'bad-set 1]
          
        )

    
  (interpreter-dict equal?
        [(eval-one-exp '(get-dict (make-dict (a 1)) a)) 1 1]
        [(eval-one-exp '
          (let ((q 17))
            (get-dict (make-dict (a q)) a))) 17 1]
        [(eval-one-exp '(get-dict (make-dict (a (let ((z 1)) (+ z 1)))) a)) 2 1]

        [(eval-one-exp '(let ((my-dict (make-dict (a 99) (b 2) (c 3) (d 4))))
                          (list (get-dict my-dict a)
                                (get-dict my-dict b)
                                (get-dict my-dict c)
                                (get-dict my-dict d))))
                                '(99 2 3 4) 1]
        [(eval-one-exp '(let ((my-dict (make-dict (foo 99) (bar 100) (c 3) (d 4)))
                              (my-dict2 (make-dict (foo 'x) (bar 'y) (c 3) (d 4))))
                          (list (get-dict my-dict foo)
                                (get-dict my-dict2 foo)
                                (get-dict my-dict2 bar)
                                (get-dict my-dict bar))))
         '(99 x y 100) 1]
        [(eval-one-exp '(let ((my-dict (make-dict (foo 99) (bar 100) (c 3) (d 4))))
                          (list (get-dict my-dict foo)
                                (let ((my-dict (make-dict (foo 1)))) (get-dict my-dict foo))
                                (get-dict my-dict foo))))
         '(99 1 99) 1]
        [(eval-one-exp '(get-dict (let ((my-dict (make-dict (foo 99) (bar 100) (c 3) (d 4)))) my-dict) d)) 4 1]
        [(eval-one-exp '(let ((my-dict (make-dict (a 99) (b 2) (c 3) (d 4))))
                          (set-dict! my-dict c 'updated)
                          (get-dict my-dict c)))
         'updated 1]
        [(eval-one-exp '(let ((x 100)
                              (my-dict (make-dict (foo 99) (bar 100) (c 3) (d 4)))
                              (my-dict2 (make-dict (foo 'x) (bar 'y) (c 3) (d 4))))
                          (set-dict! my-dict foo 'foo)
                          (set-dict! my-dict2 foo (+ x 1))
                          (list (get-dict my-dict foo)
                                (get-dict my-dict2 foo)
                                (get-dict my-dict bar)
                                (get-dict my-dict2 bar)))) '(foo 101 100 y) 1]






        )
  ))

(implicit-run test) ; run tests as soon as this file is loaded
