#lang racket

(require racket/contract)

(provide sum-of-squares range my-set? union more-positives? add-quotes get-304-quine)

(define/contract (sum-of-squares a)
  (-> (listof number?) number?)
  (nyi))

(define/contract (range a b)
  (-> integer? integer? (listof integer?))
  (nyi))

(define/contract (my-set? a)
  (-> any/c boolean?)
  (nyi))

(define/contract (union a b)
  (-> (listof any/c) (listof any/c) (listof any/c))
  (nyi))

(define/contract (more-positives? lon)
  (-> (listof integer?) boolean?)
  (nyi))

(define/contract (add-quotes val num)
  (-> (or/c symbol? list?) exact-nonnegative-integer? (or/c symbol? list?))
  (nyi))

; Stuff for the final quine problem

(define/contract (get-304-quine)
  (-> string?)
  (nyi))

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
