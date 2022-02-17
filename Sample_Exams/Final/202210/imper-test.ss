(define (test-sublist?-impr-tester)
  (let ([correct '(#t #t #t #f #f #t #f #t #t)]
        [answers 
         (list (sublist?-impr-tester '(1 2 3) '(1) )
               (sublist?-impr-tester '(1 2 3) '(1 2) )
               (sublist?-impr-tester '(1 2 3) '(1 2 3) )
               (sublist?-impr-tester '(1 2 3) '(1 4) )
               (sublist?-impr-tester '(1 2 3) '(2 1) )
               (sublist?-impr-tester '(1 1 2 3) '(1 2) )
               (sublist?-impr-tester '(2 2 1 2 1 2 1 2 1 2) '(1 2 2) )
               (sublist?-impr-tester '(1 2) '() )
               (sublist?-impr-tester '(1 1 2 3 4) '(1 2 3 4) ))])
               
    (display-results correct answers equal?)))

(define display-results
  (lambda (correct results test-procedure?)
     (display ": ")
     (pretty-print 
      (if (andmap test-procedure? correct results)
          'All-correct
          `(correct: ,correct yours: ,results)))))
