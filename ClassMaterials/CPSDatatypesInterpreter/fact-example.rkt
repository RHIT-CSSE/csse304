#lang racket

(require racket/trace)

(define abc #f)
(define fact
  (lambda (n)
    (if (= n 1)
        (call/cc (lambda (k)
                   (set! abc k)
                   (k 1)))
        (* n (fact (- n 1))))))

(trace fact)