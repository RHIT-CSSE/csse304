; evaluator for simple expressions.
; Possible starting point for first interpreter assignment.
;                  
; Claude Anderson.  Last modified January 2020.
; 
; Your names here: 

(load "chez-init.ss") 

(define load-all ; make it easy to reload the files
  (lambda ()
    (load "datatypes.ss")
    (load "parse-procs.ss")
    (load "syntax-expand.ss")
    (load "env-procs.ss")
    (load "continuations.ss")
    (load "interpreter.ss")))

(load-all)

(define l load-all) ; even easier!
