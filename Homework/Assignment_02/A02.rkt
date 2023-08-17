#lang racket

(provide sum-of-squares range my-set? union more-positives? add-quotes get-304-quine)

(define sum-of-squares
  (lambda (a)
    (nyi)))

(define range
  (lambda (a b)
    (nyi)))

(define my-set?
  (lambda (a)
    (nyi)))

(define union
  (lambda (a b)
    (nyi)))
    
(define more-positives?
  (lambda (lon)
    (nyi)))

(define add-quotes
  (lambda (val num)
    (nyi)))
           
; Stuff for the final quine problem

(define get-304-quine
  (lambda ()
    (nyi)))

(define eval-string
  (lambda (str)
    (let ((outp (open-output-string)))
      (parameterize ([current-output-port outp])
        (printf "~s" (eval (read (open-input-string str)) (make-base-namespace))))
      (get-output-string outp))))

(define is-quine-string?
 (lambda (str)
   (let ((result (eval-string str)))
     (if (equal? result str)
         #t
         (begin
           (printf "NOT QUINE~nIn : ~s~nOut: ~s" str result)
           #f)))))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
