#lang racket
(require racket/trace)

(define typecheck-math
  (lambda (exp )
    (cond 
      ; example: 1
      [(integer? exp) 'int]
      ; example: 1.1 (note that in this example, it must have a fractional part)
      [(real? exp) 'real]
      ; example: myvar
      [(symbol? exp) 'nyi]
      [(list? exp)
       (case (first exp)
         ; (let pi 3.14 (* 9.9 pi))
         [(let) 'nyi]
         ; example (* 1 (+ 2 3))
         [(+ *) (let ((a1 (typecheck-math (second exp) ))
                      (a2 (typecheck-math (third exp) )))
                  (unless (eqv? a1 a2)
                    (raise 'mismatched-types))
                  a1)]
         ; example: (log 1 2)
         [else 'nyi
          ])])))
                                         
              
            

(typecheck-math '(+ 1 2) )
(typecheck-math '(+ 1 (+ 2 3)) )
;;(typecheck-math '(+ 1 (+ 2.5 3)) empty-tenv)
;(typecheck-math '(let pi 3.14 (* 9.9 pi)) empty-tenv)
;;(typecheck-math '(let foo 3.14 (* 9.9 pi)) empty-tenv)
;(typecheck-math '(log 1 2) log-tenv)
;;(typecheck-math '(log 1 2.2) log-tenv)