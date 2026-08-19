#lang racket

(define occurs-bound?
  (lambda (var exp)
    (cond [(symbol? exp) 'nyi]
          [(eqv? 'lambda (car exp)) 'nyi]
          [else 'nyi])))

(occurs-bound? 'x '(x (lambda (x) y))) ; #f
(occurs-bound? 'x '(x (lambda (x) (y x)))) ; #t

(define occurs-free?
  (lambda (var exp)
    (cond [(symbol? exp) 'nyi]
          [(eqv? 'lambda (car exp)) 'nyi]
          [else 'nyi])))

(occurs-free? 'x '(x (lambda (x) y))) ; #t
(occurs-free? 'y '(x (lambda (x) (y x)))) ; #t
(occurs-free? 'y '(x (lambda (y) (y x)))) ; #f

; returns a list of all free variables an expression
; for simplicy, don't worry about duplicates in the list
(define find-all-free
  (lambda (exp)
    'nyi))

; hint
(define find-all-free-helper
  (lambda (exp bound-vars)
    'nyi))

(find-all-free '(x (lambda (x) y))) ; '(x y)
(find-all-free '((lambda (x) x) (lambda (x) y))) ; '(y)
  