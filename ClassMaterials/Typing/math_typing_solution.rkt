#lang racket
(require racket/trace)

(define empty-tenv (lambda (name) (raise 'missing-var)))
(define log-tenv (lambda (name)
                    (if (eqv? name 'log)
                        '(int int real)
                        (raise 'missing-var))))

(define typecheck-math
  (lambda (exp tenv)
    (cond 
      ; example: 1
      [(integer? exp) 'int]
      ; example: 1.1 (note that in this example, it must have a fractional part)
      [(real? exp) 'real]
      [(symbol? exp) (tenv exp)]
      [(list? exp)
       (case (first exp)
         ; (let pi 3.14 (* 9.9 pi))
         [(let) (let ((vtype (typecheck-math (third exp) tenv)))
                  (typecheck-math (fourth exp)
                                  (lambda (var)
                                    (if (eqv? var (second exp))
                                        vtype
                                        (tenv var)))))]
         ; example (* 1 (+ 2 3))
         [(+ *) (let ((a1 (typecheck-math (second exp) tenv))
                      (a2 (typecheck-math (third exp) tenv)))
                  (unless (eqv? a1 a2)
                    (raise 'mismatched-types))
                  a1)]
         [else
          ;; note that this version expects the return type
          ;; to be last, which makes the code a little
          ;; more complicated than the one I did live
          (let* ((all (map (lambda (e) (typecheck-math e tenv))
                             exp))
                 (proc-type (car all))
                 (actual (cdr all)))
            (unless (list? proc-type) (raise 'apply-non-proc))
            (unless (= (length proc-type) (length exp)) (raise 'bad-param-num))
            (unless (equal? (reverse (cdr (reverse proc-type)))
                             actual) (raise 'bad-param-type))
            (last proc-type))])])))
                                         
              
            

(typecheck-math '(+ 1 2) empty-tenv)
(typecheck-math '(+ 1 (+ 2 3)) empty-tenv)
;(typecheck-math '(+ 1 (+ 2.5 3)) empty-tenv)
(typecheck-math '(let pi 3.14 (* 9.9 pi)) empty-tenv)
;(typecheck-math '(let foo 3.14 (* 9.9 pi)) empty-tenv)
(typecheck-math '(log 1 2) log-tenv)
;(typecheck-math '(log 1 2.2) log-tenv)