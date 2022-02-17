
(define (test-remove-ands)
  (let ([correct '(q
                   (a or b)
                   (not a)
                   (not ((not a) or (not b)))
                   (not (not ((not a) or (not b))))
                   ( x or (not ((not y) or (not z))))
                   (not ( (not x) or (not (not ((not y) or (not z))))))
                 )]
        [answers 
         (list (remove-ands 'q)
               (remove-ands '(a or b))
               (remove-ands '(not a))
               (remove-ands '(a and b))
               (remove-ands '(not (a and b)))
               (remove-ands '(x or (y and z)))
               (remove-ands '(x and (y and z)))
               )])
               
    (display-results correct answers equal?)))


;;--------  Procedures used by the testing mechanism   ------------------

(define display-results
  (lambda (correct results test-procedure?)
     (display ": ")
     (pretty-print 
      (if (andmap test-procedure? correct results)
          'All-correct
          `(correct: ,correct yours: ,results)))))
(define set-equals?  ; are these list-of-symbols equal when
  (lambda (s1 s2)    ; treated as sets?
    (if (or (not (list? s1)) (not (list? s2)))
        #f
        (not (not (and (is-a-subset? s1 s2) (is-a-subset? s2 s1)))))))

(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))


;; You can run the tests individually, or run them all
;; by loading this file (and your solution) and typing (r)

(define (run-all)
  (display 'test-set-subtract) 
  (test-set-subtract)
  (display 'test-sublist?) 
  (test-sublist?)
  (display 'test-remove-depth) 
  (test-remove-depth)
  (display 'test-bag)
  (test-bag)
  (display 'test-swap-two-params)
  (test-swap-two-params)
  (display 'test-add-unused)
  (test-add-unused)
  )

(define r run-all)
