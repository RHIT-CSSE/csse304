#lang racket

(require "../chez-init.rkt")
(require "cps-conversion-helper.rkt")
(provide sum-numbers-cps slist-subst-cps remove-cps free-vars-cps continuation? init-k list-k apply-k)

;; The nyi macro is what an unfinished procedure calls.  It raises "nyi", which
;; the test file reports as "Not yet implemented".
(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))


(define-datatype continuation continuation?
  [init-k]
  [list-k] ; <- leave this in we use it for testing
  )

;; apply-k is declared with define-cps-procedure, like the procedures you write,
;; so the test file can check where apply-k is called from.  Declare the
;; procedures you write the same way:
;;
;;   (define-cps-procedure (name arg ...) body ...)
;;
;; works exactly like (define (name arg ...) body ...), and keeps enough of the
;; code for that check.  The check looks the procedures up by identity, so a
;; plain define would not be found; and if you trace a procedure it is rebound to
;; a wrapper, so leave (trace ...) out while you are running the tests.
;;
;; All three problems add their continuation flavors to this one datatype and
;; their cases to this one apply-k.  This saves us the trouble of having to deal
;; with having multiple continuation types or apply-k versions where it is very
;; easy to accidentally use the wrong one.
(define-cps-procedure (apply-k k v)
  (cases continuation k
    [init-k () v]
    [list-k () (list v)] ; <- leave this in we use it for testing
    ; more cases here
    ))


;; PROBLEM 1 - convert sum-numbers to CPS
;;
;; sum-numbers adds up the numbers in a list that also contains symbols,
;; ignoring the symbols.
;;
;;     (sum-numbers '(1 a 2 b 3)) => 6
;;
;; Convert the code as written.  Do not rewrite it into a fully tail recursive
;; version first and convert that instead, even though that would be easier: a
;; version that carries the running total in an accumulator is a different
;; procedure, and converting this one is the point of the problem.

;; The unconverted code, for reference.  It is commented out so that a recursive
;; call in your conversion cannot reach it by accident: writing
;; (sum-numbers (cdr lst)) inside sum-numbers-cps reports sum-numbers as
;; unbound, instead of quietly calling the original.
;
; (define sum-numbers
;   (lambda (lst)
;     (cond [(null? lst) 0]
;           [(symbol? (car lst)) (sum-numbers (cdr lst))]
;           [else (+ (car lst) (sum-numbers (cdr lst)))])))

(define-cps-procedure (sum-numbers-cps lst k)
  (nyi))


;; PROBLEM 2 - convert slist-subst to CPS
;;
;; slist-subst takes an slist, an old value and a new value, and returns a new
;; slist with all instances of the old value replaced by the new value.
;;
;;     (slist-subst '((a b) a) 'a 'q) => '((q b) q)

;; The unconverted code, for reference, commented out for the same reason.
;
; (define slist-subst-orig
;   (lambda (slist old new)
;     (cond [(null? slist) '()]
;           [(symbol? (car slist))
;            (cons (if (eqv? (car slist) old) new (car slist))
;                  (slist-subst-orig (cdr slist) old new))]
;           [else (cons (slist-subst-orig (car slist) old new)
;                       (slist-subst-orig (cdr slist) old new))])))

(define-cps-procedure (slist-subst-cps slist old new k)
  (nyi))


;; I'm not gonna make you convert union to cps, just so you
;; have a little less to do.  Lets call it a built in
;; function :)
(define union
    (lambda (s1 s2)
        (let loop ([s1  s1])
            (cond [(null? s1) s2]
                [(memq (car s1) s2) (loop (cdr s1))]
                [else (cons (car s1) (loop (cdr s1)))]))))


;; PROBLEM 3 - convert remove and free-vars to CPS
;;
;; Convert remove first.

;; The unconverted code, for reference, commented out for the same reason.  Note
;; that this came from Chez Scheme: in Racket 1st/2nd/3rd are car/cadr/caddr.
;
; (define remove ; removes the first occurrence of sym from los.
;   (lambda (sym los)
;     (cond [(null? los) '()]
;           [(eq? sym (car los)) (cdr los)]
;           [else (cons (car los) (remove sym (cdr los)))])))
;
; (define free-vars ; finds the free variables of a lambda calculus expression.
;   (lambda (exp)
;     (cond [(symbol? exp) (list exp)]
;           [(eq? (car exp) 'lambda)
;            (remove (car (cadr exp))
;                    (free-vars (caddr exp)))]
;           [else (union (free-vars (car exp))
;                        (free-vars (cadr exp)))])))

(define-cps-procedure (remove-cps sym los k)
  (nyi))

(define-cps-procedure (free-vars-cps exp k)
  (nyi))
