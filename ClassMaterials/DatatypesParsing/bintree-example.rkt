#lang racket

(require "chez-init.rkt")

(define-datatype bintree bintree?
  (leaf (value number?))
  (internal (value symbol?)
            (left bintree?)
            (right bintree?)))

(define-datatype mathexp mathexp?
  (number (value number?))
  (multi (left mathexp?)
         (right mathexp?))
  (add (left mathexp?)
       (right mathexp?)))

(define testdata '(< < 3 + 4 > * < 1 + 2 > >))

(define parse-mathexp
  (lambda (lst)
    (cond [(not (eqv? '< (car lst)))
           (cons (number (car lst))
                 (cdr lst))]
          [else
           (let* ((recurse1 (parse-mathexp (cdr lst)))
                  (recurse2 (parse-mathexp (cddr recurse1))))
             (case (cadr recurse1)
               [(+) (cons (add (car recurse1)
                               (car recurse2))
                          (cddr recurse2))]
               [(*) (cons (multi (car recurse1)
                               (car recurse2))
                          (cddr recurse2))]
               [else (error "bad exp")]))])))
          

(define mytree (internal 'q (leaf 3) (leaf 4)))

(define bintree-parse
  (lambda (bt)
    (cond [(number? bt) (leaf bt)]
          [else
           (internal (first bt)
                     (bintree-parse (second bt))
                     (bintree-parse (third bt)))])))



(define leaf-sum
  (lambda (tree)
    (cases bintree tree
      [internal (value left right)
                (+ (leaf-sum left)
                   (leaf-sum right))]
      [leaf (value)
            value]
      )))
            