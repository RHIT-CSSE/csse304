#lang racket

(require "../chez-init.rkt")
(provide sel-sort-d-cps init-k)

;; CPS QUESTION - 10 points

;; So here is an implementation of a sorting algorithm that is pretty similar to the classic
;; selection sort.

; bub (short for bubble) takes a list and returns a new list
; where the smallest element has been sorted to the front
; but the list is otherwise unchanged
(define bub
  (lambda (lst)
    (if (null? (cdr lst))
        lst
        (let ((recurse (bub (cdr lst))))
          (if (<= (car lst) (car recurse))
              lst
              (cons (car recurse) (cons (car lst) (cdr recurse))))))))

; actual sort - that relies on bub
(define sel-sort
  (lambda (lst)
    (if (null? lst)
        lst
        (let ((bub-result (bub lst)))
          (cons (car bub-result) (sel-sort (cdr bub-result)))))))


;; Here's the same code, converted to lambda-style cps.  Note I'ved
;; added a -l suffix so its clear these are the lambda versions.

;; bub, sel-sort, and apply-k are considered substantial procedures
;; all others are-non-substaintial

(define apply-k-l
  (lambda (k v)
    (k v)))

(define make-k-l    ; lambda is the "real" continuation 
  (lambda (v) v)) ; constructor here.

(define bub-l-cps
  (lambda (lst k)
    (if (null? (cdr lst))
        (apply-k-l k lst)
        (bub-l-cps (cdr lst) (make-k-l (lambda (recurse)
                                         (apply-k-l k (if (<= (car lst) (car recurse))
                                                          lst
                                                          (cons (car recurse) (cons (car lst) (cdr recurse)))))))))))

(define sel-sort-l-cps
  (lambda (lst k)
    (if (null? lst)
        (apply-k-l k lst)
        (bub-l-cps lst (make-k-l (lambda (bub-result)
                                   (sel-sort-l-cps (cdr bub-result) (make-k-l (lambda (sel-sort-result)

                                                                                (apply-k-l k (cons (car bub-result) sel-sort-result)))))))))))

;; Convert the given lambda style cps to datatype continuations
;;
;; Your init-k cotinuation should just return the passed in value.
;;
;; See the testcases for how sel-sort-d-cps is called
;;
;; You are required to convert my solution, not create a sort algorithm of your own design.

(define-datatype continuation continuation?
  [init-k]
  ; your other cases here
  )

(define apply-k-d
  (lambda (k v)
    (nyi)))
      

(define bub-d-cps
  (lambda (lst k)
    (nyi)))

(define sel-sort-d-cps
  (lambda (lst k)
    (nyi)))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
