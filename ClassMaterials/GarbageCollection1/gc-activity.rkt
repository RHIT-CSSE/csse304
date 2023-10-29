#lang racket

(define memory
  #((1 2) ;0
    (2)   ;1
    (3 1) ;2
    (1)   ;3
    ()    ;4
    (4)   ;5
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


; two handy set operations to make your life easier
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

; there are other ways to build this if you don't like this
; particular helper
(define reach-helper
  (lambda (reachable visited)
    'nyi))
        
(define reachable
  (lambda (roots)
    (reach-helper roots '())))
    
    