#lang racket

(define occurs-bound?
  (lambda (var exp)
    (cond [(symbol? exp) #f]
          [(eqv? 'lambda (car exp))
           (or (occurs-bound? var (third exp))
               (and (eqv? (caadr exp) var)
                    (occurs-free? var (third exp))))
           ]
          [else (or (occurs-bound? var (first exp))
                    (occurs-bound? var (second exp)))])))

(define occurs-free?
  (lambda (var exp)
    (cond [(symbol? exp) (eqv? var exp)]
          [(eqv? 'lambda (car exp))
           (if (eqv? var (caadr exp))
               #f
               (occurs-free? var (third exp)))]
          [else (or (occurs-free? var (first exp))
                    (occurs-free? var (second exp)))])))

(occurs-bound? 'x '(x (lambda (x) y))) ; #f
(occurs-bound? 'x '(x (lambda (x) (y x)))) ; #t



(occurs-free? 'x '(x (lambda (x) y))) ; #t
(occurs-free? 'y '(x (lambda (x) (y x)))) ; #t
(occurs-free? 'y '(x (lambda (y) (y x)))) ; #f

; returns a list of all free variables an expression
; for simplicy, don't worry about duplicates in the list
(define find-all-free
  (lambda (exp)
    (find-all-free-helper exp '())))

; hint
(define find-all-free-helper
  (lambda (exp bound-vars)
    (cond [(symbol? exp) (if (member exp bound-vars) '() (list exp))]
          [(eqv? 'lambda (car exp))
           (find-all-free-helper (third exp)
                                 (cons (caadr exp) bound-vars))                                       
           ]
          [else (append (find-all-free-helper (first exp) bound-vars)
                        (find-all-free-helper (second exp) bound-vars))])))

(find-all-free '(x (lambda (x) y))) ; '(x y)
(find-all-free '((lambda (x) x) (lambda (x) y))) ; '(y)
  