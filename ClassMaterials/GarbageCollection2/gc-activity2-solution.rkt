#lang racket

(define memory
  (vector '(1 2) ;0
          '(2)   ;1
          '(3 1) ;2
          '(1)   ;3
          '()    ;4
          '(4)   ;5
          ))

; Imagine this array represents objects 0-5 in memory.
; Each of these objects has references to other objects,
; represented as the stored list.
;
; Q1 If we start with O5 as our root, what objects are reachable?
; Q2 If we start with O2 as our root, what objects are reachable?
; Q3 If we start with O2 and O5 as our roots, what objects are reachable?

; OK now lets implement reachable, which does this work for us.  To help you,
; I've included a set subtract and a set union operation.  My solution works
; with a helper which takes a current list of reachable nodes and a current
; list of visited nodes - and returns the set of all reachable once
; reachable - visited = the empty set.


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
; Note the inputs are expercted to be in sorted order
(define rewrite
  (lambda (reachable)
    (let rewrite-entry ((entry 0))
      (vector-set! memory entry (map (lambda (x) (list-index reachable x))
                                     (vector-ref memory entry)))
      (if (= entry 5)
          (void)
          (rewrite-entry (add1 entry))))))

(define compact
  (lambda (reachable)
    (let move-entry ((entry 0))
      (if (< entry (length reachable))
          (vector-set! memory entry (vector-ref memory (list-ref reachable entry)))
          (vector-set! memory entry '()))
      (if (= 5 entry)
          (void)
          (move-entry (add1 entry))))))

(define garbage-collect
  (lambda (roots)
    (let ((reachable (sort (reachable roots) <)))
      (compact reachable)
      (rewrite reachable)
      )))

(garbage-collect (list 1))

memory
                  
    
    