#lang racket

(define make-adder
  (lambda (add-num)
    (lambda (n)
      (+ add-num n))))

(define add3
  (make-adder 3))

(add3 4)

(define make-counter
  (lambda ()
    (let [(num 0)]
      (lambda ()      
        (set! num (add1 num))
        num))))

(define counter1 (make-counter))
(define counter2 (make-counter))

(define make-weird-counter
  (let ((supply 5)) ; think about how many times this let is run
    (lambda ()
      (let [(num 0)] ; how many times this let is run
        (lambda ()
          (if (zero? supply) 'supply-empty
              (begin
                (set! num (add1 num))
                (set! supply (sub1 supply))
                (list supply num))))))))

(define wc1 (make-weird-counter))
(define wc2 (make-weird-counter))
