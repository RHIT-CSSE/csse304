#lang racket

(define memory
  (vector '(1 2) ;0
          '(2)   ;1
          '(3 1) ;2
          '(1)   ;3
          '()    ;4
          '(4)   ;5
          ))

; Let's start with the solution to reachable from last time

(define subtract
  (lambda (l1 l2)
    (if (null? l1)
        '()
        (if (member (car l1) l2)
            (subtract (cdr l1) l2)
            (cons (car l1) (subtract (cdr l1) l2))))))

(define union
  (lambda (l1 l2)
    (if (null? l1)
        l2
        (if (member (car l1) l2)
            (union (cdr l1) l2)
            (cons (car l1) (union (cdr l1) l2))))))

(define reach-helper
  (lambda (reachable visited)
    (let ((unvisited (subtract reachable visited)))
      (if (null? unvisited)
          reachable
          (reach-helper
           (union (vector-ref memory (car unvisited))
                  reachable)
           (cons (car unvisited) visited))))))
        
(define reachable
  (lambda (roots)
    (reach-helper roots '())))

; Ok now lets implement memory compacting.


; Utility function.  Returns the index of value in a list
; or #f if it isn't found.
(define list-index
  (lambda (lst val)
    (let recur ((pos 0) (lst lst))
           (cond [(null? lst) #f]
                 [(eqv? (car lst) val) pos]
                 [else (recur (add1 pos) (cdr lst))]))))

; rewrite takes a list of numbers and rewrites all memory references
; to use those numbers as 0 1 2 3 etc...
;
; For example if you rewrite (2 4 5) all references to 2 become 0
; all references to 4 become 1.  all references to 5 become 2.  Any
; reference not listed should be #f
;
; Note the inputs are expercted to be in sorted order.  This avoids many
; annoying problems
(define rewrite
  (lambda (reachable)
    'nyi))

; test your rewrite before you go on.  e.g.
; (rewrite '(1 2 3)) memory
; but comment them out again


; Compact moves the entries to new positions.  It expects a list
; of indexes.  compact moves the first index to index 0.  second index to
; index 1 etc.  
(define compact
  (lambda (reachable)
    'nyi))

; garbage collect is just reachable + compact + rewrite
;
; note that it might not be quite so simple for your lab, but the basic
; idea is the same
(define garbage-collect
  (lambda (roots)
    (let ((reachable (sort (reachable roots) <)))
      (compact reachable)
      (rewrite reachable)
      )))

(garbage-collect (list 1))

memory
                  
    
    
