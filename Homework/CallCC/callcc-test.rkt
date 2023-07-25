#lang racket

(require "../testcode-base.rkt")
(require "callcc.rkt")
(provide get-weights get-names individual-test test)


(define simp1
  (make-retlam (lambda (x)
                 (+ 3 (return 4)))))

(define simp2
  (make-retlam (lambda (x)
                 (+ 3 (if x 7 (return 0))))))

(define simp3
  (make-retlam (lambda (y z)
                 (cons 'bad (return (list (simp1 1) (simp2 y) (simp2 z)))))))
                 
(define retfact
  (letrec ((fact (make-retlam (lambda (n) (if (zero? n) 1 (return (* n (fact (sub1 n))))))))) fact))


(define retfib
  (lambda (n)
    (letrec ((stuck 0)
             (lst '(1 1))
             (fib (make-retlam
                   (lambda (n)

                     (when (= n 1) (return n))
                     (fib (sub1 n))
                     (set! lst (cons (+ (first lst) (second lst)) lst))
                     (set! stuck (add1 stuck))
                     (when (> stuck 99) (error "infinite-loop"))
                     (return n)))))
      (fib n)
      (reverse lst))))

(define my-func
    (make-retlam (lambda ()
                   (let ((foo 0))
                     ((make-retlam (lambda () 'dumb)))
                     (set! foo (+ foo 1))
                     (if (= foo 2) 'bad (return 'good))
                   ))))

(define test (make-test ; (r)
              (make-retlam equal? 
                 [(simp1 99) 4 4] 
                 [(simp2 #t) 10 4]
                 [(simp2 #f) 0 4]
                 [(simp3 #t #f) '(4 10 0) 4]
                 [(simp3 #f #f) '(4 0 0) 4]
                 [(simp3 #f #t) '(4 0 10) 4]
                 [(retfact 4) 24 4]
                 [(my-func) 'good 4]
                 [(retfib 5) '(1 1 2 3 5 8) 4]
              )
                (jobs equal?
            [(let ((g 0)) (jobs (lambda () (set! g 1) (go-home))) g) 1 6]
            [(let ((g '())) (jobs (lambda () (set! g (cons 1 g)) (switch-job 1))
                                  (lambda () (set! g (cons 2 g)) (switch-job 2))
                                  (lambda () (set! g (cons 3 g)) (switch-job 3))
                                  (lambda () (set! g (cons 4 g)) (go-home))

               ) g) '(4 3 2 1) 6]
            [(let ((g '())) (jobs (lambda () (set! g (cons 1 g)) (switch-job 2) (error "should not run"))
                                  (lambda () (error "should not run"))
                                  (lambda () (set! g (cons 3 g)) (switch-job 3) (error "should not run"))
                                  (lambda () (set! g (cons 4 g)) (go-home) (error "should not run"))

               ) g) '(4 3 1) 6]
            
            [(let ((g '())) (jobs (lambda () (set! g (cons 1 g)) (switch-job 1) (set! g (cons 5 g)) (switch-job 1) (error "should not run"))
                                  (lambda () (set! g (cons 1 g)) (switch-job 2) (set! g (cons 6 g)) (switch-job 2) (error "should not run"))
                                  (lambda () (set! g (cons 3 g)) (switch-job 3) (set! g (cons 7 g)) (switch-job 3) (error "should not run"))
                                  (lambda () (set! g (cons 4 g)) (switch-job 0) (set! g (cons 8 g)) (go-home) (error "should not run"))

                                  ) g) '(8 7 6 5 4 3 1 1) 6]
            [(let ((g '())) (jobs (lambda () (set! g (cons 1 g)) (switch-job 1) (set! g (cons 5 g)) (set! g (cons 3 g)) (switch-job 1) (set! g (cons 7 g)) (switch-job 1) (switch-job 1) (error "should not run"))
                                  (lambda () (set! g (cons 10 g)) (switch-job 0) (set! g (cons 6 g)) (switch-job 0)  (set! g (cons 4 g)) (switch-job 0) (set! g (cons 8 g)) (go-home) (error "should not run")(error "should not run"))
                                  ) g) '(8 4 7 6 3 5 10 1) 6]
            
            [(let ((g '())) (jobs (lambda () (set! g (cons 1 g)) (switch-job 1) (go-home) (set! g (cons 3 g)) (switch-job 1) (set! g (cons 7 g)) (switch-job 1) (switch-job 1) (error "should not run"))
                                  (lambda () (set! g (cons 10 g)) (switch-job 0) (set! g (cons 6 g)) (switch-job 0)  (set! g (cons 4 g)) (switch-job 0) (set! g (cons 8 g)) (go-home) (error "should not run")(error "should not run"))
                                  ) g) '(10 1) 6])

  ))

(implicit-run test) ; run tests as soon as this file is loaded