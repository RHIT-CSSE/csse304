#lang racket

(require "chez-init.rkt")
(require racket/trace)

(define-datatype person person?
  [student (id number?)
           (name string?)
           (gpa number?)]
  [professor (name string?)
             (department symbol?)]
  [lawyer (name string?)
          (briefcase-weight number?)])

(define steve (student 3 "steve" 1.8))
(define buffalo (professor "buffalo" 'csse))

(define is-smart?
  (lambda (p)
    (cases person p
      [student (id name gpa)
               (> gpa 1.0)]
      [professor (name department)
                 (eqv? 'engineering-design department)]
      )))

(define-datatype bintree bintree?
  [leaf (val number?)]
  [interior (sym symbol?)
            (left bintree?)
            (right bintree?)])

(define sum-leaves
  (lambda (t)
    (cases bintree t
      [leaf (val) val]
      [interior (sym left right) (+ (sum-leaves left)
                                    (sum-leaves right))])))

(define parse-bintree
  (lambda (tree)
    (cond [(number? tree) (leaf tree)]
          [else
           (interior (car tree)
                     (parse-bintree (second tree))
                     (parse-bintree (third tree)))])))

(define-datatype math math?
  [num (value number?)]
  [exp (left math?)
       (op symbol?)
       (right math?)])

(define parse-math
  (lambda (lst)
    (cond [(number? (car lst)) (list (num (car lst)) (cdr lst))]
          [else (let* ((left-pair (parse-math (cdr lst)))
                       (left (first left-pair))
                       (rest1 (second left-pair))
                       (op (car rest1))
                       (right-pair (parse-math (cdr rest1)))
                       (right (first right-pair))
                       (rest2 (second right-pair)))
                  (list (exp left op right)
                        (cdr rest2)))])))
                       

(parse-math '( < < 5 + 3 > * 2 > ))
  
;(parse-math '(11 12))