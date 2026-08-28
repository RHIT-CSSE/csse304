#lang racket

(require "../chez-init.rkt")
(provide slist-subst-cps remove-cps free-vars-cps continuation? init-k list-k)


(define-datatype continuation continuation? 
  [init-k] 
  [list-k] ; <- leave this in we use it for testing
  )


(define apply-k
  (lambda (k v)
    (cases continuation k
      [init-k () v]
      [list-k () (list v)] ; <- leave this in we use it for testing
      ; more cases here
      )))

(define slist-subst-cps
  (lambda (slist old new k)
    'nyi))

; I'm not gonna make you convert union to cps, just so you
; have a little less to do.  Lets call it a built in 
; function :)
(define union 
    (lambda (s1 s2)    
        (let loop ([s1  s1])
            (cond [(null? s1) s2]
                [(memq (car s1) s2) (loop (cdr s1))]
                [else (cons (car s1) (loop (cdr s1)))]))))


(define free-vars-cps
  (lambda (a b)
    (nyi)))


(define remove-cps
  (lambda (a b c)
    (nyi)))


;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))
