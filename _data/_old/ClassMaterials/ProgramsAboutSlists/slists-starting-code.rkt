#lang racket
; <s-list>      ::= ( {<symbol-exp>}* )
; <symbol-exp>  ::= <symbol> | <s-list>

; Based on this grammar, there are three cases for an s-list s:
;   1. s is the empty list
;   2. The car of s is a symbol
;   3. The car of s is an s-list

;-------------------------------------------------------------
; Does slist contain sym (at any level)?
(define (contains? slist sym)
  (let recurse ([slist slist]) ; We'll use named-let a lot today
    (cond [(null? slist) 'nyi])))

; I'll do this one with you.  Then go on and do either count
; occurances or flatten yourself


(contains? '() 'a)                          ; #f
(contains? '(b a) 'a)                       ; #t
(contains? '(( b (a)) ()) 'a)               ; #t
(contains? '((c b ()) ( b (c a)) ()) 'a)    ; #t
(contains? '((c b ()) ( b (c a)) ()) 'p)    ; #f


;-------------------------------------------------------------
; how many times does sym occur in slist?
(define  (count-occurrences slist sym)
  (let count ([slist slist])
    (cond [(null? slist) 'nyi])))
	  


(count-occurrences '() 'a)                      ; 0
(count-occurrences '(b a b () a b) 'a)          ; 2
(count-occurrences '(b a b () a b) 'a)          ; 2
(count-occurrences '(b ((a) a) b () a b) 'a)    ; 3
(count-occurrences '((b ((a) a) b () a b)) 'a)  ; 3 

;-------------------------------------------------------------
; From the s-list produce a sinlge flat list whose symbols are printed
; in the same order as the original s-list
(define  (flatten slist)
  (cond [(null? slist) 'nyi]))



(flatten '( () (a ((b) c () ((d e ((f))) g) h)) ()))  ; (a b c d e f g h)



;-------------------------------------------------------------
; Replace each symbol with a 2-list - that symbol and its depth within slist
;
; wont get to this one, but it gets talked about in the video
(define (notate-depth slist) 
  (let notate ([slist slist]
	       [depth 1])
    (cond [(null? slist) 'nyi])))



(notate-depth '())                          ; ()
(notate-depth '(a))                         ; ((a 1)) 
(notate-depth '((a b) c))                   ; (((a 2) (b 2)) (c 1))
(notate-depth '( () (a (b)) c ((d) () e)))  ; (() ((a 2) ((b 3))) (c 1) (((d 3)) () (e 2)))
(notate-depth '((() (a (b)) c ((d) () e)))) ; ((() ((a 3) ((b 4))) (c 2) (((d 4)) () (e 3))))


;-------------------------------------------------------------
; Ok now lets try one with lambda calculus
;
; remember the language
; LcExp ::= <Identifier> |
;           (lambda (<Identifier>) <LcExp>) |
;           (<LcExp> <LcExp>)
;
; As to the problem, lets write code that replaces all
; uses of a free variable var with a particular value.
; For example, if I replace pi with 3.14 in this expression:
;
; (lambda (x) (pi not-pi)) I get (lambda (x) (3.14 not-pi))
;
; Note that 3.14 is not a valid lc-expression really, but
; it makes for easier test cases - it'be more realistic to
; say replace true with (lambda (a) (lambda (b) a)).

(define (replace-free code var value)
  'nyi)

; Some examples of output:
; 
(replace-free 'pi 'pi 3.14) ; 3.14
(replace-free '(y pi) 'pi 3.14) ; (y 3.14)

; these two require explaination
(replace-free '(lambda (pi) pi) 'pi 3.14) ; (lambda (pi) pi)
(replace-free '((lambda (pi) pi) (lambda (x) pi)) 'pi 3.14) ; ((lambda (pi) pi) (lambda (x) 3.14))

