#lang racket

(require racket/trace)

(define fact1
  (lambda (n)
    (if (zero? n)
        1
        (* n (fact1 (- n 1))))))

(define fact2
  (lambda (n)
    (if (or (not (number? n)) (negative? n))
        "error"
        (fact-acc n 1))))

; tail recursive
(define fact-acc
  (lambda (n acc)
    (if (zero? n)
        acc
        (fact-acc (- n 1) (* n acc)))))

(trace fact1 fact2 fact-acc)