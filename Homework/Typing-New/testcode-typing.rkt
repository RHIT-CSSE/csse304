#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "typing.rkt")
(provide get-weights get-names individual-test test)

(define exn:check?
  (lambda (e)
    (and (exn:fail? e)
         (or (equal? (exn-message e) "type-check")
             (equal? (substring (exn-message e) 0 10) "type-check")))))



(define test (make-test ; (r)

  (check-invalid equal?           
       [(with-handlers ([exn:check? (lambda (e) "type-check")]) (check '(+ #t 1)))  "type-check" 2]
       [(with-handlers ([exn:check? (lambda (e) "type-check")]) (check '(+ #t #f)))  "type-check" 2]
       [(with-handlers ([exn:check? (lambda (e) "type-check")]) (check '(- #t 1)))  "type-check" 2]

       [(with-handlers ([exn:check? (lambda (e) "type-check")]) (check '(if 1 2 3)))  "type-check" 2]
       [(with-handlers ([exn:check? (lambda (e) "type-check")]) (check '(if #t 1 #f)))  "type-check" 2]

       [(with-handlers ([exn:check? (lambda (e) "type-check")]) (check '(1 2)))  "type-check" 2]
       [(with-handlers ([exn:check? (lambda (e) "type-check")]) (check '((fun (x : Num) : Num (+ x 1)) #t)))  "type-check" 3]
       [(with-handlers ([exn:check? (lambda (e) "type-check")]) (check '(fun (x : Num) : Bool (+ x 1))))  "type-check" 3]
       [(with-handlers ([exn:check? (lambda (e) "type-check")]) (check 'x))  "type-check" 2]
       
   )

                  
  (check-valid equal?
    [(check '5) '(tnum) 1]
    [(check -3) '(tnum) 1]
    [(check '#t) '(tbool) 1]
    [(check '#f) '(tbool) 1]
    [(check '(+ 3 4)) '(tnum) 1]
    [(check '(- 10 5)) '(tnum) 2]
    [(check '(+ (- 3 1) (+ 4 5))) '(tnum) 2]

    [(check '(if #t 1 2)) '(tnum) 1]
    [(check '(if #f #t #f)) '(tbool) 2]
    [(check '(if #t (if #f 1 2) 3)) '(tnum) 2]
    [(check '(+ (if #t 1 2) 3)) '(tnum) 2]

    [(check '(fun (x : Num) : Num (+ x 1))) '(tfun (tnum) (tnum)) 1]            
    [(check '(fun (x : Num) : Num x)) '(tfun (tnum) (tnum)) 1]               
    [(check '(fun (b : Bool) : Bool b)) '(tfun (tbool) (tbool)) 1]
    [(check '(fun (x : Num) : Bool #t)) '(tfun (tnum) (tbool)) 1]
    [(check '(fun (x : Num) : Num (if #t (+ x 1) (- x 1)))) '(tfun (tnum) (tnum)) 2]
    [(check '((fun (x : Num) : Num (+ x 1)) 5)) '(tnum) 2]
    [(check '((fun (b : Bool) : Num (if b 1 0)) #t)) '(tnum) 2]               
    [(check '(fun (f : (Num -> Num)) : Num (f 5))) '(tfun (tfun (tnum) (tnum)) (tnum)) 2]
    [(check '((fun (f : (Num -> Num)) : Num (f 5))
                  (fun (x : Num) : Num (+ x 1)))) '(tnum) 2]               
    [(check '(fun (x : Num) : (Num -> Num)
                   (fun (y : Num) : Num (+ x y)))) '(tfun (tnum) (tfun (tnum) (tnum))) 2]        
    [(check '(((fun (x : Num) : (Num -> Num)
                     (fun (y : Num) : Num (+ x y))) 3) 4)) '(tnum) 2]

    [(check '(let ((x 5)) (+ x 1))) '(tnum) 1]
    [(check '(let ((f (fun (x : Num) : Num (+ x 1)))) (f 5))) '(tnum) 2]
    [(check '(let ((x 5)) (let ((y (+ x 1))) (+ x y)))) '(tnum) 2]
    [(check '(let ((b #t)) (if b 1 2))) '(tnum) 2]
    [(check '(let ((f (fun (x : Num) : Num (+ x 1)))) f)) '(tfun (tnum) (tnum)) 2]         
    [(check '(let ((y 10))
                   ((fun (x : Num) : Num (+ x y)) 5))) '(tnum) 2]
  )


))

(implicit-run test) ; run tests as soon as this file is loaded
