
(define run-pausable
  (lambda (function)
    (call/cc (lambda (pause-cont)
               (function (lambda ()
                           (call/cc (lambda (resume-cont)
                                    (pause-cont (lambda () (resume-cont #f)))))))))))

(run-pausable (lambda (pause-me)
                (display "1")
                (newline)
                (pause-me)
                (display "2")
                (newline)
                (display "3")))

