
(define (test-suffix-sums-ds-cps)
    (let ([correct '(
		     (4)
		     (11 10 7 2)
		     (21 20 18 15 11 6)
		     (6 3 1 1 6)
                     ((6 3 1 1 6))
		     )]
          [answers 
            (list 
	     (suffix-sums-ds-cps '(4) (init-k))
	     (suffix-sums-ds-cps '(1 3 5 2) (init-k))
	     (suffix-sums-ds-cps '(1 2 3 4 5 6) (init-k))
	     (suffix-sums-ds-cps '(3 2 0 -5 6) (init-k))
             (suffix-sums-ds-cps '(3 2 0 -5 6) (list-init-k))
	     )])
      (display-results correct answers equal?)))

(define display-results
  (lambda (correct results test-procedure?)
     (display ": ")
     (pretty-print 
      (if (andmap test-procedure? correct results)
          'All-correct
          `(correct: ,correct yours: ,results)))))
