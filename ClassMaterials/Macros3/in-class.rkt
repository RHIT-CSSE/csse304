#lang racket

(require racket/trace)

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