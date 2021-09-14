; <s-list>      ::= ( {<symbol-exp>}* )
; <symbol-exp>  ::= <symbol> | <s-list>

; Based on this grammar, there are three cases for an s-list s:
;   1. s is the empty list
;   2. The car of s is a symbol
;   3. The car of s is an s-list

;-------------------------------------------------------------
; Does slist contain sym (at any level)?
(define (contains? slist sym)
  (let in-list? ([slist slist]) ; We'll use named-let a lot today
    (cond [(null? slist)




(contains? '() 'a)                          ; #f
(contains? '(b a) 'a)                       ; #t
(contains? '(( b (a)) ()) 'a)               ; #t
(contains? '((c b ()) ( b (c a)) ()) 'a)    ; #t
(contains? '((c b ()) ( b (c a)) ()) 'p)    ; #f


;-------------------------------------------------------------
; how many times does sym occur in slist?
(define  (count-occurrences slist sym)
  (let count ([slist slist])
    (cond [(null? slist)
	  


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
    (cond [(null? slist) 



(flatten '( () (a ((b) c () ((d e ((f))) g) h)) ()))  ; (a b c d e f g h)



;-------------------------------------------------------------
; Replace each symbol with a 2-list - that symbol and its depth within slist
(define (notate-depth slist) 
  (let notate ([slist slist]
	       [depth 1])
    (cond [(null? slist) 



(notate-depth '())                          ; ()
(notate-depth '(a))                         ; ((a 1)) 
(notate-depth '((a b) c))                   ; (((a 2) (b 2)) (c 1))
(notate-depth '( () (a (b)) c ((d) () e)))  ; (() ((a 2) ((b 3))) (c 1) (((d 3)) () (e 2)))
(notate-depth '((() (a (b)) c ((d) () e)))) ; ((() ((a 3) ((b 4))) (c 2) (((d 4)) () (e 3))))


;-------------------------------------------------------------
; replace each occurrence of symbol s1 in slist by symbol s2
(define  (subst s1 s2 slist) 
  (let subst ([slist slist])
    (cond [(null? slist) 
  

(subst 'a 'b '(() a (c ((a) a) (c (((c a)))))))  ; (() b (c ((b) b) (c (((c b)))))
  
