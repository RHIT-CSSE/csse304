#lang racket
; <s-list>      ::= ( {<symbol-exp>}* )
; <symbol-exp>  ::= <symbol> | <s-list>

; Based on this grammar, there are three cases for an s-list s:
;   1. s is the empty list
;   2. The car of s is a symbol
;   3. The car of s is an s-list

;-------------------------------------------------------------
; Does slist contain sym (at any level)?
(define (contains? slist sym) ; (define contains? (lambda (slist sym)...
  (let in-list? ([slist slist]) ; We'll use named-let a lot today
    (cond [(null? slist) #f]
	  [(symbol? (car slist))
	   (or (eq? sym (car slist))
	       (in-list? (cdr slist)))]
	  [else ; car is an s-list
	   (or (in-list? (car slist))
	       (in-list? (cdr slist)))])))


(contains? '() 'a)                          ; #f
(contains? '(b a) 'a)                       ; #t
(contains? '(( b (a)) ()) 'a)               ; #t
(contains? '((c b ()) ( b (c a)) ()) 'a)    ; #t
(contains? '((c b ()) ( b (c a)) ()) 'p)    ; #f


;-------------------------------------------------------------
; how many times does sym occur in slist?
(define  (count-occurrences slist sym)
  (let count ([slist slist])
    (cond [(null? slist) 0]
	  [(symbol? (car slist))
	   (+  (if (eq? sym (car slist))
		   1
		   0)
	       (count (cdr slist)))]
	  [else ; car is an s-list
	   (+ (count (car slist))
	      (count (cdr slist)))])))	  

(count-occurrences '() 'a)                      ; 0
(count-occurrences '(b a b () a b) 'a)          ; 2
(count-occurrences '(b a b () a b) 'a)          ; 2
(count-occurrences '(b ((a) a) b () a b) 'a)    ; 3
(count-occurrences '((b ((a) a) b () a b)) 'a)  ; 3 

;-------------------------------------------------------------
; From the s-list produce a sinlge flat list whose symbols are printed
; in the same order as the original s-list
(define  (flatten slist)
  (let flatten ([slist slist])
    (cond [(null? slist) '()]
	  [(symbol? (car slist))
	   (cons (car slist)
		 (flatten (cdr slist)))]
	  [else ; car is an s-list
	   (append (flatten (car slist))
	       (flatten (cdr slist)))])))


(flatten '( () (a ((b) c () ((d e ((f))) g) h)) ()))  ; (a b c d e f g h)



;-------------------------------------------------------------
; Replace each symbol with a 2-list - that symbol and its depth within slist
(define (notate-depth slist) 
  (let notate ([slist slist]
	       [depth 1])
    (cond [(null? slist) '()]
	  [(symbol? (car slist))
	   (cons (list (car slist) depth)
		 (notate (cdr slist) depth))]
	  [else ; car is an s-list
	   (cons (notate (car slist) (+ 1 depth))
		 (notate (cdr slist) depth))])))


(notate-depth '())                          ; ()
(notate-depth '(a))                         ; ((a 1)) 
(notate-depth '((a b) c))                   ; (((a 2) (b 2)) (c 1))
(notate-depth '( () (a (b)) c ((d) () e)))  ; (() ((a 2) ((b 3))) (c 1) (((d 3)) () (e 2)))
(notate-depth '((() (a (b)) c ((d) () e)))) ; ((() ((a 3) ((b 4))) (c 2) (((d 4)) () (e 3))))


;-------------------------------------------------------------
; replace-free

(define (replace-free code var value)
  (cond [(symbol? code) (if (eqv? code var) value code)]
        [(eqv? (car code) 'lambda)
         (if (eqv? (caadr code) var)
             code
             (list 'lambda
                   (second code)
                   (replace-free (third code) var value)))]
        [else
         (list
          (replace-free (first code) var value)
          (replace-free (second code) var value))]))

(replace-free 'pi 'pi 3.14) ; 3.14
(replace-free '(y pi) 'pi 3.14) ; (y 3.14)

; these two require explaination
(replace-free '(lambda (pi) pi) 'pi 3.14) ; (lambda (pi) pi)
(replace-free '((lambda (pi) pi) (lambda (x) pi)) 'pi 3.14) ; ((lambda (pi) pi) (lambda (x) 3.14))

