#lang racket

;; My Example

(lexical-address '(lambda (a b c)
                    (if (eq? b c)
                        ((lambda (c)
                           (cons a c))
                         a)
                        b)))

;; Exercise 1

(lexical-address
 '((lambda (x y)
     (((lambda (z)
         (lambda (w y)
           (+ x z w y)))
       (list w x y z))
      (+ x y z)))
   (y z)))           

;; Exercise 2

(lexical-address '(let ([a 3] [b 4])
    (let ([a (+ b 2)] [c a])
      (+ a b c))))      



;; solution from slides
;; (lambda (a b c)
;;  (if ((: free eq?) (: 0 1) (: 0 2))
;;      ((lambda (c) ((: free cons) (: 1 0) (: 0 0)))
;;       (: 0 0))
;;      (: 0 1)))
