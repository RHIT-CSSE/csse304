#lang racket

(require racket/trace)

(define has-1-even?
  (lambda (lst)
    (= 1 (let recurse ((lon lst) (count 0))
           (cond [(null? lon) count]
                 [(not (zero? (car lon))) (recurse (cdr lon) count)]
                 [(even? count) (recurse (cdr lon) 1)]
                 [else 2])))))