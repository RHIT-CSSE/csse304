#lang racket

(require racket/trace)

(define has-1-even?
  (lambda (lst)
    (= 1 (let recurse ((lst lst) (count 0))
           (cond [(null? lst) count]
                 [(even? (car lst))
                  (if (zero? count)
                      (recurse (cdr lst) (add1 count))
                      2)]
                 [else (recurse (cdr lst) count)])))))