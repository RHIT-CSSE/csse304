
#lang racket

; (ins-sort lon) returns a sorted list of the nubers 
; that are in lon. Because it is easier to add to the front 
; of a Scheme list than to the end, the sorting starts at the 
; end of the list.

(define ins-sort
  (lambda (lon)
    
    (if (or (null? lon) (null? (cdr lon))) ; NOTE: (length lon) would (maybe) be inefficient here
        lon ; too small to need sorting
        (let ([sorted-cdr (ins-sort (cdr lon))]) ; NOTE let makes this easier to understand
          (insert (car lon) sorted-cdr)))
    ))

(define insert
  (lambda (n sorted-list) ; fill in the details
    (cond
     [(null? sorted-list) (cons n '())]
     [(<= n (car sorted-list)) (cons n sorted-list)]
     [else (cons (car sorted-list) (insert n (cdr sorted-list)))]
    )))


(ins-sort '())
(ins-sort '(3 7 -2 9 7 6 4))

