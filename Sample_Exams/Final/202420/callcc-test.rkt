#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "callcc.rkt")
(provide get-weights get-names individual-test test)



(define test (make-test ; (r)
  
  (do-threads equal?
        [(let* ((output-data '())
                (output (lambda (x) (set! output-data (cons x output-data)))))
           (do-threads (lambda () (output 1) (wait) (output 2) (done))
                       (lambda () (output 3) (wait) (output 4) (done)))
           (reverse output-data)

           ) '(1 3 2 4) 1]

        [(let* ((output-data '())
                (output (lambda (x) (set! output-data (cons x output-data)))))
           (do-threads (lambda () (output 1) (wait) (output 2) (done))
                       (lambda () (output 3) (wait) (output 4) (done))
                       (lambda () (output 5) (wait) (output 6) (done))
                       )
           (reverse output-data)

           ) '(1 3 5 2 4 6) 1]

        [(let* ((output-data '())
                (output (lambda (x) (set! output-data (cons x output-data)))))
           (do-threads (lambda () (output 1) (wait) (output 2) (wait) (output 10) (done))
                       (lambda () (output 3) (wait) (output 4) (wait) (output 20) (done))
                       (lambda () (output 5) (wait) (output 6) (wait) (output 30) (done))
                       )
           (reverse output-data)

           ) '(1 3 5 2 4 6 10 20 30) 1]
                         
        [(let* ((output-data '())
                (output (lambda (x) (set! output-data (cons x output-data)))))
           (do-threads (lambda () (output 1) (wait) (output 2) (wait) (output 10) (done) (output 'bad))
                       (lambda () (output 3) (wait) (output 4) (done) (output 'bad))
                       (lambda () (output 5) (wait) (output 6) (wait) (output 30) (wait) (output 20) (done) (output 'bad))
                       )
           (reverse output-data)

           ) '(1 3 5 2 4 6 10 30 20) 1]
        [(let* ((output-data '())
                (output (lambda (x) (set! output-data (cons x output-data)))))
           (do-threads (lambda () (output 1) (wait) (output 2) (wait) (wait) (output 10) (done) (output 'bad))
                       )
           (reverse output-data)

           ) '(1 2 10) 1]
        [(let* ((output-data '())
                (output (lambda (x) (set! output-data (cons x output-data)))))
           (do-threads (lambda () (output 1) (wait) (output 2) (wait) (output 10) (done) (output 'bad))
                       (lambda () (output 3) (done) (output 'bad))
                       (lambda () (output 20) (done) (output 'bad))
                       )
           (reverse output-data)

           ) '(1 3 20 2 10) 1]


        )
  ))

(implicit-run test) ; run tests as soon as this file is loaded
