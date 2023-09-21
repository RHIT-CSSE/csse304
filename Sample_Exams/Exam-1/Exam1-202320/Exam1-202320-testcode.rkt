#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "Exam1-202320.rkt")
(provide get-weights get-names individual-test test)

(define equal-sublists?
  (lambda (s1 s2)
    (let* ((numsort (lambda (ls) (sort ls <)))
           (s1 (map numsort s1))
           (s2 (map numsort s2)))
      (and
       (= (length s1) (length s2))
       (subset? s1 s2)
       (subset? s2 s1)))))



(define test (make-test ; (r)
  (running-sum equal? ; (run-test running-sum)
                 [(running-sum '(1 2)) '(1 3) 1] ; (run-test running-sum 1)
                 [(running-sum '(2 20 200 2000)) '(2 22 222 2222) 1]
                 [(running-sum '(2 4 8 16)) '(2 6 14 30) 1]
                 )
  (sublists equal-sublists? ; (run-test subsets)
                 [(sublists '(1)) '(() (1)) 1] ; (run-test subsets 1)
                 [(sublists '(1 2)) '(() (1) (2) (1 2)) 1]
                 [(sublists '(1 2 3)) '(() (1) (2) (3) (1 2) (1 3) (2 3) (1 2 3)) 1]
                 )
  (queue equal?
         [(let ((q1 (make-queue))) (q1 'empty?)) #t 1]
         [(let ((q1 (make-queue)))
            (q1 'enqueue 'foo)
            (q1 'enqueue 'bar)
            (q1 'enqueue 'baz)
            (list (q1 'dequeue) (q1 'dequeue) (q1 'empty?) (q1 'dequeue) (q1 'empty?)))
          '(foo bar #f baz #t) 1]
         [(let ((q1 (make-queue))(q2 (make-queue)))
            (q1 'enqueue 'foo)
            (q2 'enqueue 'bar)
            (q1 'enqueue 'baz)
            (q2 'enqueue 'x)
            (list (q1 'dequeue) (q1 'dequeue) (q2 'dequeue) (q2 'dequeue)))
          '(foo baz bar x) 1]
         [(let ((q1 (make-queue)))
            (q1 'enqueue 1)
            (q1 'enqueue 2)
            (q1 'enqueue 3)
            (let ((r1 (q1 'dequeue))
                  (r2 (q1 'dequeue)))
              (q1 'enqueue 4)
              (q1 'enqueue 5)
              (list r1 r2 (q1 'dequeue) (q1 'dequeue) (q1 'dequeue))))
          '(1 2 3 4 5) 1]
         )
            
  (snl-type equal?
            [(snl-type 1) 'number 1]
            [(snl-type 'q) 'symbol 1]
            [(snl-type '(1 2 3 4 5)) '(number) 1]
            [(snl-type '(a b c x y z)) '(symbol) 1]
            [(snl-type '((a b) (c) (x y z))) '((symbol)) 1]
            [(snl-type '(((1 2) (3)) ((4) (5)) )) '(((number))) 1]
            [(snl-type '(1 2 a 4 5)) 'error 1]
            [(snl-type '((1 2 a) ( z 4 5))) 'error 1]
            [(snl-type '(1 2 3 (4))) 'error 1]
            [(snl-type '((1) 2 3 4)) 'error 1]
            [(snl-type '(((1 2) (3)) ((4) (5)) (6))) 'error 1]
            )
  
      (two-stream equal?
            [(let ((s (two-stream))) (list (s) (s) (s) (s))) '(2 4 8 16) 1]
            [(let ((s (two-stream))
                   (s2 (two-stream))) (list (s) (s2) (s2) (s) (s2))) '(2 2 4 4 8) 1]
            )
      (fib-stream equal?
            [(let ((s (fib-stream))) (list (s) (s) (s) (s) (s))) '(2 3 5 8 13) 1]
            [(let ((s (fib-stream))
                   (s2 (fib-stream))) (list (s) (s2) (s2) (s) (s2))) '(2 2 3 3 5) 1]
            )

      (alternate-stream equal?
            [(let ((s (alternate-stream (fib-stream) (two-stream)) )) (list (s) (s) (s) (s) (s) (s) )) '(2 2 3 4 5 8) 1]
            [(let ((s (alternate-stream (fib-stream) (alternate-stream (fib-stream) (two-stream)) )))
               (list (s) (s) (s) (s) (s) (s) (s) (s) )) '(2 2 3 2 5 3 8 4) 1]
      )
      
      (prepend-stream equal?
            [(let ((s (prepend-stream '(1 1) (fib-stream)) )) (list (s) (s) (s) (s) (s) (s) )) '(1 1 2 3 5 8) 1]
            [(let ((s (prepend-stream '(0 0) (prepend-stream '(1 1) (two-stream)) )))
               (list (s) (s) (s) (s) (s) (s) (s) (s) )) '(0 0 1 1 2 4 8 16) 1]
      )
      
   ))

(implicit-run test) ; run tests as soon as this file is loaded
