#lang racket

(require racket/trace)

;; IN CLASS EXAMPLE myand

(define-syntax (myand stx)
  (syntax-case stx ()
    [(myand exp) #'exp]
    [(myand exp exps ...)
     #'(if exp (myand exps ... ) #f)]))

;; EXERCISE MYLET*
;; Build an your own implementation of mylet*.
;; If you want you can build it in terms of built in let.
;; For slightly more challenge you can build in terms
;; of lambda.

(define-syntax (mylet* stx)
  (syntax-case stx ()
    [(mylet* (mapping) bodies ...) #'(let (mapping) bodies ...)]
    [(mylet* (mapping more-mappings ...) bodies ...)
     #'(let (mapping) (mylet* (more-mappings ...) bodies ...))]))

;; Usage
;; (mylet* ((a 2) (b (+ 1 a))) (+ a b)) yields 5


;; IN CLASS EXERCISE REPEAT
;; Make a second form of repeat that has variable parameter that you can
;; use within the body
;;
;;  (repeat i 3 (display i)) prints 123

(define-syntax (repeat2 stx)
  (syntax-case stx ()
    [(_ numExp repeatExp ) #'(repeat2 count numExp repeatExp)]
    [(_ var numExp repeatExp ) #'
                               (let ((max numExp))
                                 (let repeatme ((var 1))
                                   (if (> var max)
                                       (void)
                                       (begin
                                         repeatExp
                                         (repeatme (add1 var))))))]))

(define-syntax (listlet stx)
  (syntax-case stx ()
    [(listlet (a) exp body ...)
     #'(let ((a (car exp)))
         body ...)]
    [(listlet (var vars ...) exp body ...)
     #'(let* ((lst exp)
              (var (car lst)))
         (listlet (vars ...) (cdr lst)
                  body ...))]))


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
    (syntax-case stx ()
      [(if-it test then else)
       (with-syntax ([local-it (datum->syntax stx 'it)])
         #'(let ((local-it test))
             (if local-it then else)))])))

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

;; we'll live code this one

(begin-for-syntax

(define key-list '())
(define get-key-internal
  (lambda (name)
    (let ((pos (member name key-list)))
      (if pos
          (length pos)
          (begin
            (set! key-list (cons name key-list))
            (length key-list))))))

)

(define-syntax get-key
  (lambda (stx)
    (syntax-case stx ()
      [(get-key sym)
       (datum->syntax stx (get-key-internal (syntax->datum #'sym)))])))


(define example-list (list (get-key a) (get-key b) (get-key c)))

(define has-null-keys?
  (lambda (lst)
    (if (null? lst)
        #f
        (or (= (get-key null) (car lst))
            (has-null-keys? (cdr lst))))))


(begin-for-syntax

  (define LOG-LEVEL 1) ; this needs to be here and not a regular define
  (define should-log?
    (lambda (level)
      (<= level LOG-LEVEL)))
  )

(define-syntax log
  (lambda (stx)
    (let ((level (cadr (syntax->datum stx))))
      (if (should-log? level)
          (syntax-case stx ()
            [(log level params ...)
             #'(printf params ...)])
          #'(void)))))

(define logging-func
  (lambda (lst)
    (log 2 "starting logging func~n")
    (if (list? lst)
        (begin
          (log 2 "logging function passed a list~n")
          #t)
        (log 1 "error: logging function passed invalid param ~s~n" lst))))

(logging-func 2)