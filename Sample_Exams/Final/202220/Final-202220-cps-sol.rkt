#lang racket

(require "chez-init.rkt")
(provide sel-sort-d-cps init-k)
  
(define bub
  (lambda (lst)
    (if (null? (cdr lst))
        lst
        (let ((recurse (bub (cdr lst))))
          (if (<= (car lst) (car recurse))
              lst
              (cons (car recurse) (cons (car lst) (cdr recurse))))))))

(define sel-sort
  (lambda (lst)
    (if (null? lst)
        lst
        (let ((bub-result (bub lst)))
          (cons (car bub-result) (sel-sort (cdr bub-result)))))))


;; Here's the same code, converted to lambda-style cps.  Note I'ved
;; added a -l suffix so its clear these are the lambda versions.

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
(define-datatype continuation continuation?
  [init-k]
  [recurse-k (lst list?) (k continuation?)]
  [sel-sort-result-k (bub-result list?) (k continuation?)]
  [bub-result-k (k continuation?)]
  )

(define apply-k-d
  (lambda (k v)
    (cases continuation k
      [init-k () v]
      [sel-sort-result-k (bub-result k)
                         (apply-k-d k (cons (car bub-result) v))]
      [bub-result-k (k)
                    (sel-sort-d-cps (cdr v) (sel-sort-result-k v k))]
      [recurse-k (lst k)
                 (apply-k-d k (if (<= (car lst) (car v))
                                  lst
                                  (cons (car v) (cons (car lst) (cdr v)))))])))
      

(define bub-d-cps
  (lambda (lst k)
    (if (null? (cdr lst))
        (apply-k-d k lst)
        (bub-d-cps (cdr lst) (recurse-k lst k)))))

(define sel-sort-d-cps
  (lambda (lst k)
    (if (null? lst)
        (apply-k-d k lst)
        (bub-d-cps lst (bub-result-k k)))))

