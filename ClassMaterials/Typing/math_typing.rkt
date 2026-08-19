#lang racket
(require racket/trace)

(define empty-tenv
  (lambda (id)
    (raise (list 'missing-id id))))

(define extend-tenv
  (lambda (name type parent)
    (lambda (id)
      (if (eqv? id name)
          type
          (parent id)))))

(define typecheck-math
  (lambda (exp tenv)
    (cond 
      ; example: 1
      [(integer? exp) 'int]
      ; example: 1.1 (note that in this example, it must have a fractional part)
      [(real? exp) 'real]
      ; example: myvar
      [(symbol? exp) (tenv exp)]
      [(list? exp)
       (case (first exp)
         ; (let pi 3.14 (* 9.9 pi))
         [(let) (let ((new-env (extend-tenv (second exp)
                                           (typecheck-math (third exp) tenv)
                                           tenv)))
                  (typecheck-math (fourth exp) new-env))]
         ; example (* 1 (+ 2 3))
         [(+ *) (let ((left-t (typecheck-math (second exp) tenv))
                      (right-t (typecheck-math (third exp) tenv)))
                  (if (eqv? left-t right-t)
                      left-t
                      (raise 'mismatched-types)))]
         ; example: (log 1 2)
         [else
          (let* ((op-t (typecheck-math (car exp) tenv))
                 (rand-ts (map (lambda (e) (typecheck-math e tenv)) (cdr exp))))
            (unless (list? op-t) (raise (list 'not-proc op-t)))
            (unless (equal? rand-ts (cdr op-t)) (raise (list 'bad-params rand-ts (cdr op-t))))
            (car op-t))
          ])])))

(define log-tenv (extend-tenv 'log '(real int int) empty-tenv))
            

;(typecheck-math '(+ 1 2) )
;(typecheck-math '(+ 1.1 (+ 2.1 3.1)) )
;(typecheck-math '(+ 1 (+ 2 3)) empty-tenv)
;(typecheck-math '(let pi 3.14 (* 9.9 pi)) empty-tenv)
;(typecheck-math '(let foo 3.14 (* 9.9 pi)) empty-tenv)
(typecheck-math '(log 1 2) log-tenv)
(typecheck-math '(log 1 2.2) log-tenv)