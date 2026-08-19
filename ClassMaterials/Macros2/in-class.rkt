#lang racket

(require racket/trace)

;; IN CLASS EXAMPLE myand

(define-syntax (myand stx)
  (syntax-case stx ()
    [(myand exp) #'exp]
    [(myand exp exps ...)
     #'(quote nyi)]))

;; EXERCISE MYLET*
;; Build an your own implementation of mylet*.
;; If you want you can build it in terms of built in let.
;; For slightly more challenge you can build in terms
;; of lambda.

(define-syntax (mylet* stx)
  #'(quote nyi))

;; Usage
;; (mylet* ((a 2) (b (+ 1 a))) (+ a b)) yields 5

;; IN CLASS EXAMPLE REPEAT
;; 
;; (repeat 3 (display "hello")) prints hellohellohello
;;
;; Note that this implementation is buggy

(define-syntax (repeat stx)
  (syntax-case stx ()
    [(_ numExp repeatExp ) #'(let repeatme ((count 0))
                               (if (= count numExp)
                                   (void)
                                   (begin
                                     repeatExp
                                     (repeatme (add1 count)))))]))

;; IN CLASS EXERCISE REPEAT
;; Make a second form of repeat that has variable parameter that you can
;; use within the body
;;
;;  (repeat i 3 (display i)) prints 123

(define-syntax (repeat2 stx)
  #'(quote nyi))


;; IN CLASS EXERCISE LIST LET
;; (listlet (a b c) mylist
       ;; in the body a is mapped to (car mylist)
       ;; b is mapped to (cadr mylist)
       ;; c is mapped to (caddr mylist))

(define-syntax (listlet stx)
  (syntax-case stx ()
    [(listlet (a) exp body ...)
     #'(quote nyi)]
    [(listlet (var vars ...) exp body ...)
     #'(quote nyi)]))

 (let ((mylist (list 1 2 3 4)))
    (listlet (a b c d) mylist (list (+ a b) (+ c d)))) 
; should yield '(3 7)

 (listlet (a b c) (list (display "x") (display "y") (display "z")) (cons a (cons b c)))
; should print xyz and return '(#<void> #<void> . #<void>)



;; IN CLASS EXAMPLE NUMED-SYMS

(define-syntax numed-syms
  (lambda (stx)
    (datum->syntax stx
                   (list 'quote (let recur ([num 0]
                                            [syms (cdr (syntax->datum stx))])
                                      (if (null? syms)
                                          '()
                                          (cons (cons (car syms) num)
                                                (recur (add1 num) (cdr syms)))))))))

(numed-syms a b c)

;; IN CLASS EXAMPLE BADSWAP

(define-syntax badswap
  (lambda (stx)
    (datum->syntax stx (let* ([orig (syntax->datum stx)]
                              [v1 (cadr orig)]
                              [v2 (caddr orig)])
                         (list 'let (list (list 'tmp v1))
                               (list 'set! v1 v2)
                               (list 'set! v2 'tmp))))))



(define a 1)
(define b 2)
(badswap a b)
(printf "a ~s b ~s~n" a b)
(define q 3)
(define tmp 99)
(badswap q tmp)
(printf "q ~s tmp ~s~n" q tmp)

;(let ((set! '(1 2 3)))
;  (badswap a b))
  

;; IN CLASS EXAMPLE PRINT-X

(define-syntax print-x
  (lambda (stx)
    (syntax-case stx ()
      [(print-x) (with-syntax ([x-in-context (datum->syntax stx 'x)])
                   #'(printf "x is ~s~n" x-in-context))])))

(let ((x 3)) (print-x))

;; ACTIVITY IF-IT

(define-syntax if-it
  (lambda (stx)
    #'(quote nyi)))

(if-it 3 it 4) ; returns 3
(if-it #f 5 it) ; returns #f

;; IN-CLASS-EXAMPLE NUMED-SYMS2

(begin-for-syntax

(define to-num-pairs
  (lambda (initial-num sym-list)
    (if (null? sym-list)
        '()
        (cons (cons (car sym-list) initial-num)
              (to-num-pairs (add1 initial-num) (cdr sym-list))))))
)

(define-syntax numed-syms2
  (lambda (stx)
    (datum->syntax stx (to-num-pairs 0 (cdr (syntax->datum stx))))))
                   
(numed-syms d e f)

;; IN-CLASS-EXAMPLE get-keys

;; we'll live code this one.
;; this starting code works but does not use macros

(define key-list '())
(define get-key
  (lambda (name)
    (let ((pos (member name key-list)))
      (if pos
          (length pos)
          (begin
            (set! key-list (cons name key-list))
            (length key-list))))))


(define example-list (list (get-key 'a) (get-key 'b) (get-key 'c)))

(define has-null-keys?
  (lambda (lst)
    (if (null? lst)
        #f
        (or (= (get-key 'null) (car lst))
            (has-null-keys? (cdr lst))))))

; (trace get-key)
(has-null-keys? example-list)

(begin-for-syntax

  (define LOG-LEVEL 1) ; this needs to be here and not a regular define
  
  )

(define-syntax log
  (lambda (stx)
    #'(quote nyi)))

(define logging-func
  (lambda (lst)
    (log 2 "starting logging func~n")
    (if (list? lst)
        (begin
          (log 2 "logging function passed a list~n")
          #t)
        (log 1 "error: logging function passed invalid param ~s~n" lst))))

(logging-func 2)