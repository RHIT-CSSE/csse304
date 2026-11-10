#lang racket
(require racket/trace)

;; count-sublists returns the number of elements of slist that are themselves
;; lists, counting at every depth.  An empty list is a list.
;;
;;    (count-sublists '(a b c))        => 0
;;    (count-sublists '(a (b c) d))    => 1
;;    (count-sublists '((a) (b (c))))  => 3
;;    (count-sublists '(a () b))       => 1
;;
;; Convert it to CPS.
;;
;; The unconverted code is commented out so that a recursive call in your
;; conversion cannot reach it by accident: writing (count-sublists (cdr slist))
;; inside count-sublists-cps reports count-sublists as unbound, instead of
;; quietly calling the original.
;
; (define count-sublists
;   (lambda (slist)
;     (cond [(null? slist) 0]
;           [(symbol? (car slist)) (count-sublists (cdr slist))]
;           [else (+ 1 (count-sublists (car slist))
;                      (count-sublists (cdr slist)))])))


(define (count-sublists-cps slist k)
  'nyi)
