#lang racket

(require "../testcode-base.rkt")
(require "garbage-collect.rkt")
(require "gc-interpret.rkt")

(provide get-weights get-names individual-test test)

; this type is actually defined in garbage-collect.rkt
; but I use it here
;
; (define-memstruct test-type ptrs: (p1 p2) vals: (v1))

(define scenario1
  (lambda ()
    (reset-memory 20)
    (let* ((p1 (put! 'test-type null-ptr null-ptr 1))
           (p2 (put! 'test-type null-ptr null-ptr 2))
           (p3 (put! 'test-type null-ptr p1 3)))
      (values p1 p2 p3))))

(define scenario2
  (lambda ()
    (reset-memory 60)
    (let* ((p1 (put! 'test-type null-ptr null-ptr 1))
           (p2 (put! 'test-type null-ptr null-ptr 2))
           (p3 (put! 'test-type null-ptr p1 3))
           (p4 (put! 'test-type null-ptr p2 4))
           (p5 (put! 'test-type null-ptr p3 5))
           (p6 (put! 'test-type null-ptr p4 6)))
      (values p1 p2 p3 p4 p5 p6))))

(define scenario3
  (lambda ()
    (reset-memory 60)
    (let* ((p1 (put! 'test-type null-ptr null-ptr 1))
           (p2 (put! 'test-type null-ptr p1 2))
           (p3 (put! 'test-type null-ptr p2 3))
           (p4 (put! 'test-type null-ptr p3 4))
           (p5 (put! 'test-type null-ptr p2 5))
           (p6 (put! 'test-type null-ptr null-ptr 6)))
      (set-field! 'test-type 'p1 p1 p4)
      (set-field! 'test-type 'p1 p3 p6)
      (values p1 p2 p3 p4 p5 p6))))

(define to-v1-unsorted
  (lambda (ptr-lst)
    (map (lambda (ptr) (get-val 'test-type 'v1 ptr)) ptr-lst)))


(define to-v1
  (lambda (ptr-lst)
    (sort (to-v1-unsorted ptr-lst) < )))


(define test (make-test ; (r)
  (all-reachable equal? ; (run-test all-reachable)
    [(let-values ([(p1 p2 p3) (scenario1)]) (to-v1 (all-reachable (list p1)))) '(1) 3]
    [(let-values ([(p1 p2 p3) (scenario1)]) (to-v1 (all-reachable (list p3)))) '(1 3) 3]
    [(let-values ([(p1 p2 p3) (scenario1)]) (to-v1 (all-reachable (list p1 p2)))) '(1 2) 3]
    [(let-values ([(p1 p2 p3) (scenario1)]) (to-v1 (all-reachable (list p2 p3)))) '(1 2 3) 3]
    [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario2)]) (to-v1 (all-reachable (list p5)))) '(1 3 5) 3]
    [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario2)]) (to-v1 (all-reachable (list p6)))) '(2 4 6) 3]
    [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario2)]) (to-v1 (all-reachable (list p1 p2)))) '(1 2) 3]
    [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario3)]) (to-v1 (all-reachable (list p1)))) '(1 2 3 4 6) 3]
    [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario3)]) (to-v1 (all-reachable (list p5)))) '(1 2 3 4 5 6) 3]
    [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario3)]) (to-v1 (all-reachable (list p6)))) '(6) 3]
    )
  (garbage-collect equal?
    [(let-values ([(p1 p2 p3) (scenario1)])
       (let* ((basis (garbage-collect (list p1 p3)))
              (num-objs (validate-memory)))
       (cons num-objs (to-v1 basis))))
     '(2 1 3) 2]
    [(let-values ([(p1 p2 p3) (scenario1)])
       (let* ((basis (garbage-collect (list p3)))
              (num-objs (validate-memory)))
       (list num-objs (to-v1 basis) (get-val 'test-type
                                             'v1
                                             (get-ptr 'test-type 'p2 (car basis))))))
     '(2 (3) 1) 3]
    [(let-values ([(p1 p2 p3) (scenario1)])
       (let* ((basis (garbage-collect (list p1)))
              (num-objs (validate-memory)))
         (list num-objs (to-v1 basis))))
     '(1 (1)) 3]

    [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario2)])
       (let* ((basis (garbage-collect (list p5)))
              (num-objs (validate-memory))
              (p5 (car basis))
              (p3 (get-ptr 'test-type 'p2 p5))
              (p1 (get-ptr 'test-type 'p2 p3)))
         (cons num-objs (to-v1-unsorted (list p5 p3 p1))))) '(3 5 3 1) 3]
  [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario2)])
       (let* ((basis (garbage-collect (list p3)))
              (num-objs (validate-memory))
              (p3 (car basis))
              (p1 (get-ptr 'test-type 'p2 p3)))
         (cons num-objs (to-v1-unsorted (list p3 p1))))) '(2 3 1) 3]
  [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario2)])
       (let* ((basis (garbage-collect (list p6)))
              (num-objs (validate-memory))
              (p6 (car basis))
              (p4 (get-ptr 'test-type 'p2 p6))
              (p2 (get-ptr 'test-type 'p2 p4)))
         (cons num-objs (to-v1-unsorted (list p6 p4 p2))))) '(3 6 4 2) 3]

    [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario3)])
       (let* ((basis (garbage-collect (list p1)))
              (num-objs (validate-memory))
              (p1 (car basis))
              (p4 (get-ptr 'test-type 'p1 p1))
              (p3 (get-ptr 'test-type 'p2 p4))
              (p6 (get-ptr 'test-type 'p1 p3))
              (p2 (get-ptr 'test-type 'p2 p3))
              (p1b (get-ptr 'test-type 'p2 p2)))
         (cons num-objs (to-v1-unsorted (list p1 p1b p2 p3 p4 p6))))) '(5 1 1 2 3 4 6) 3]
    [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario3)])
       (let* ((basis (garbage-collect (list p3)))
              (num-objs (validate-memory))
              (p3 (car basis))
              (p6 (get-ptr 'test-type 'p1 p3))
              (p2 (get-ptr 'test-type 'p2 p3))
              (p1 (get-ptr 'test-type 'p2 p2))
              (p4 (get-ptr 'test-type 'p1 p1))
              (p6 (get-ptr 'test-type 'p1 p3))
              )
         (cons num-objs (to-v1-unsorted (list p1 p2 p3 p4 p6))))) '(5 1 2 3 4 6) 3]
    [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario3)])
       (let* ((basis (garbage-collect (list p5)))
              (num-objs (validate-memory))
              (p5 (car basis))
              (p2 (get-ptr 'test-type 'p2 p5))
              (p1 (get-ptr 'test-type 'p2 p2))
              (p4 (get-ptr 'test-type 'p1 p1))
              (p3 (get-ptr 'test-type 'p2 p4))
              (p6 (get-ptr 'test-type 'p1 p3))
              )
         (cons num-objs (to-v1-unsorted (list p1 p2 p3 p4 p5 p6))))) '(6 1 2 3 4 5 6) 3]
    [(let-values ([(p1 p2 p3 p4 p5 p6) (scenario3)])
       (let* ((basis (garbage-collect (list p6)))
              (num-objs (validate-memory))
              )
         num-objs)) 1 3]
    [(null-ptr? (car (garbage-collect (list null-ptr)))) #t 1] ; as odd as nulls in the basis set is, we should handle it
    
    )
  (gc-interpreter equal?
   [(begin
      (reset-memory 500)
      (let* ((paused-state (eval-one '(+ (+ 1 2) (+ (pause (+ 3 4)) (+ 5 6)))))
             (num-objs1 (validate-memory))
             (new-paused-state (gc-before-continue paused-state))
             (num-objs2 (validate-memory))
             (overall-result (eval-continue new-paused-state)))
        (if (<= num-objs1 num-objs2)
            'gc-did-not-work
            (if (= overall-result 21)
                'success
                overall-result)))) 'success 5]
     [(begin
      (reset-memory 500)
      (let* ((paused-state (eval-one '((lambda (make-pair)
                                         ((make-pair 1) (pause 2)))
                                       (lambda (a) (lambda (b) (cons a (cons b '())))))))
             (num-objs1 (validate-memory))
             (new-paused-state (gc-before-continue paused-state))
             (num-objs2 (validate-memory))
             (overall-result (eval-continue new-paused-state)))
        (if (<= num-objs1 num-objs2)
            'gc-did-not-work
            (if (equal? overall-result '(1 2))
                'success
                overall-result)))) 'success 5])
     
  ))

(implicit-run test)
