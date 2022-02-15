#lang racket

; CSSE 304:  A19

; IN THIS FILE:
; Starting-code - CPS with continuations represented by Scheme procs
; Trace-it code - may be useful for debugging imperative-form code.


; NOTES ABOUT THE ASSIGNMENT
; Requirements for imperative form:
;  These procedures in CPS (all are thunks - take no arguments):
;    append-cps, cons-cps, +-cps, apply-k, flatten-cps,
;    list-sum-cps, helper procedure in cps-snlist-recur,
;  the procedures that are arguments to cps-snlist-recur.
;  You must define these global variables:  slist, k
;    The test code sets those variables in each test case. 
;    You may want the other variables used by imperative form
;    to also be global.

; You are allowed to go straight to imperative form without
;   first doing the intermediate DS-continuations form,
;   but I do not recommend it.

;;--------------- Starting code ----------------

(require "../chez-init.rkt")
(provide set!-slist set!-k id-k list-k length-k sum-cps flatten-cps)

; TODO: Convert lambda cps below to define-datatype CPS. Since the goal
; is imperative form, the continuation datatypes shouldn't have fields.
(define make-k
  (lambda (k) k))

(define id-k (make-k (lambda (v) v)))
(define list-k (make-k list))
(define length-k (make-k length))

(define apply-k
  (lambda (k args)
    (k args)))

(define cps-snlist-recur
  (lambda (base car-item-proc-cps car-list-proc-cps)
    (letrec
        ([helper
          (lambda (L k)
            (cond [(null? L)(apply-k k base)]
                  [(not (or (null? (car L)) (pair? (car L))))
                   (helper (cdr L)
                           (make-k (lambda (helped-cdr)
                                     (car-item-proc-cps
                                      (car L)
                                      helped-cdr
                                      k))))]
                  [else
                   (helper (car L)
                           (make-k
                            (lambda (helped-car)
                              (helper (cdr L) (make-k (lambda (helped-cdr)
                                                        (car-list-proc-cps helped-car
                                                                           helped-cdr
                                                                           k)))))))]))])
      helper)))
				    
(define read-flatten-print
  (lambda ()
    (display "enter slist to flatten: ")
    (let ([slist (read)])
      (unless (eq? slist 'exit)
        (flatten-cps slist 
                     (lambda (val)
                       (pretty-print val)
                       (read-flatten-print)))))))
(define append-cps 
  (lambda (a b k)
    (if (null? a)
        (apply-k k b)
        (append-cps (cdr a)
                    b
                    (make-k (lambda (appended-cdr)
                              (apply-k k (cons (car a)
                                               appended-cdr))))))))
(define cons-cps
  (lambda (a b k)
    (apply-k k (cons a b))))

(define +-cps
  (lambda (a b k)
    (apply-k k (+ a b))))

(define flatten-cps
  (cps-snlist-recur '() cons-cps append-cps))

(define sum-cps
  (cps-snlist-recur 0 +-cps +-cps))

;------------------------------------------------
;  Some code that may help in your imperative form code.

; Required definitions:
(define slist #f)  ; it's actually an snlist.
(define k #f)      ; the continuation, of course!

; Other variables that you need may be defined 
; globally like these, or you can define them inside
; a letrec that also contains definitions of all of
; your cps procedures.  I recommend global for this assignment.
; This is because you only have a few days to complete A19.
; I only needed three other variables, a, b, and v.
; None of those need to be initialized before
; starting a new computation.

; I found the following code to be invaluable for 
; tracing and debugging my imperative-form code.
; Simply place a (trace-it "procedureName") call as the first body
; of each CPS procedure (including helper and apply-k)

(define *tracing* #f) ; set this to true when you want to use trace everything.

(define trace-it       ; Adjust this for whatever 
  (lambda (proc-name)  ; variables you have 
    (when *tracing*
      (printf "slist=~s" slist) ; Add more variables you define here
      (printf "k=~s~%" k))))


;-----------------------------------------------
;  Used by the tests.

(define set!-slist (lambda (new-slist) (set! slist new-slist)))
(define set!-k (lambda (new-k) (set! k new-k)))
