#lang racket

(require "chez-init.rkt")

(define-datatype bintree bintree?
  (leaf (value number?))
  (internal (value symbol?)
            (left bintree?)
            (right bintree?)))

(define parse-bintree
  (lambda (lst)
    (cond [(number? lst) (leaf lst)]
          [else
           (internal (first lst)
                     (parse-bintree (second lst))
                     (parse-bintree (third lst)))])))


(define operator?
  (lambda (sym)
    (member sym '(+ - * /))))


(define mytree (internal 'q (leaf 3) (leaf 4)))

(define example '(< < 3 + a > * < 4 - y > >)) 

(define-datatype mathexp mathexp?
  (number (val number?))
  (symbol (val symbol?))
  (math (left mathexp?)
        (operator operator?)
        (right mathexp?)))

(define parse-mathexp
  (lambda (lst)
    (cond [(number? (car lst)) (cons (number (car lst))
                                     (cdr lst))]
          [(not (eqv? '< (car lst))) (cons (symbol (car lst))
                                           (cdr lst))]
          [else
           (let* ((recurse1 (parse-mathexp (cdr lst)))
                  (operator (cadr recurse1))
                  (recurse2 (parse-mathexp (cddr recurse1))))
             (cons (math (car recurse1)
                         operator
                         (car recurse2))
                   (cddr recurse2)))])))

(define leaf-sum
  (lambda (tree)
    (cases bintree tree
      [internal (value left right)
                (+ (leaf-sum left)
                   (leaf-sum right))]
      [leaf (value)
            value]
      )))
            