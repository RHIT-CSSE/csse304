#lang racket

(require racket/trace)
(require "chez-init.rkt")

(define-datatype person person?
  [student (name string?)
           (id number?)
           (gpa number?)]
  [professor (name string?)
             (salary number?)]
  )

(define print-name
  (lambda (p)
    (cases person p
      [student (name id gpa)
               (display name)]
      [professor (name salary)
                 (display "Dr.")
                 (display name)]
      )))