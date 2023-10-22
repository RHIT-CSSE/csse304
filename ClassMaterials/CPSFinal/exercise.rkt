#lang racket
(require "chez-init.rkt")

;; Below I've provided my solution to combine-conseq.  Most of the work
;; is actually done in a helper function - combine-consec-helper.  Convert
;; both functions to CPS.

;; To remind you, here's the description of combine-conseq

;; ;; combine-consec takes a *sorted* list of integers and combines them
;; ;; into a series of ranges.  It compresses sequences of consecutive
;; ;; numbers into ranges - so for example the list (1 2 3 4) becomes ((1
;; ;; 4)) representing the single range 1-4.  However, when numbers are
;; ;; missing then there must be multiple ranges - e.g. (1 2 3 6 7 8)
;; ;; becomes ((1 3) (6 8)) representing 1-3,6-8.  If a number is by
;; ;; itself (i.e. it is not consecutive with either its successor or
;; ;; predecessor) it can be in a range by itself so (1 2 4 7) becomes
;; ;; ((1 2) (4 4) (7 7)).


(define (combine-consec-orig lst)
  (if (null? lst)
      '()
      (combine-consec-helper-orig
       (car lst)
       (car lst)
       (cdr lst))))


(define (combine-consec-helper-orig first last lst)
  (cond [(null? lst) (list (list first last))]
        [(= (add1 last) (car lst))
         (combine-consec-helper-orig first (add1 last) (cdr lst))]
        [else (cons (list first last) (combine-consec-helper-orig (car lst) (car lst) (cdr lst)))]))


(define-datatype continuation continuation?
  [init-k]
  [step1 (first number?)
         (last number?)
         (k continuation?)]
  ; more types here 
  )

(define apply-k
  (lambda (k v)
	(cases continuation k
          [init-k () v]
          [step1 (first last k) ; v is comb consec helper on cdr
                 (apply-k k (cons (list first last) v))]
          ; more code here
          )))

(define (combine-consec lst k)
  (if (null? lst)
      (apply-k k '())
      (combine-consec-helper-cps
       (car lst)
       (car lst)
       (cdr lst)
       k)))

(define (combine-consec-helper-cps first last lst k)
  (cond [(null? lst) (apply-k k (list (list first last)))]
        [(= (add1 last) (car lst))
         (combine-consec-helper-cps first (add1 last) (cdr lst) k)]
        [else (combine-consec-helper-cps (car lst)
                                         (car lst)
                                         (cdr lst)
                                         (step1 first last k))]))


(combine-consec-orig '(1 2 3 6 7 8 13))
(combine-consec '(1 2 3 6 7 8 13) (init-k))