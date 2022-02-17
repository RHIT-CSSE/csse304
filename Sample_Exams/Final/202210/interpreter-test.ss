;; NOTE THAT WE'RE USING A SLIGHTLY SPECIAL ENVIRONMENT HERE

(define (special-eval-one exp)
  (reset-global-env)
  (eval-one-exp '(define foo 99))
  (eval-one-exp exp))
  

(define (test-unbind)
    (let ([correct '(
             9
             6
             3
             12
             3
             16
             100
             0
             102
             200
             )]
          [answers
            (list
         (special-eval-one '
          (let ((+ *)) (+ 3 3))) ;; just checking your interpreter works for redefining globals
         (special-eval-one '
          (let ((+ *)) (unbind (+) (+ 3 3))))
         (special-eval-one '
          (let ((+ *)) (unbind (+) (+ 3 (- 3 3)))))
         (special-eval-one '
          (let ((+ *) (- *)) (unbind (+) (+ 3 (- 3 3)))))
         (special-eval-one '
          (let ((+ *) (- *)) (unbind (+ -) (+ 3 (- 3 3)))))
         (special-eval-one '
          (let ((+ *) (- *)) (unbind (+ -) (+ 3 (- 3 3))) (+ 4 4)))
         (special-eval-one
          '(begin (let ((foo 0)) (unbind (foo) (set! foo 100))) foo))
         (special-eval-one
          '(let ((foo 0)) (unbind (foo) (set! foo 100)) foo))
         (special-eval-one
          '(let ((foo 0)) (unbind (foo) (+ foo (let ((foo 3)) 3)))))
         (special-eval-one
          '(let ((foo 0)) (unbind (foo) (+ foo (let ((foo 2)) (+ (unbind (foo) foo) foo ))))))
         )])
      (display-results correct answers equal?)))


(define display-results
  (lambda (correct results test-procedure?)
     (display ": ")
     (pretty-print 
      (if (andmap test-procedure? correct results)
          'All-correct
          `(correct: ,correct yours: ,results)))))

