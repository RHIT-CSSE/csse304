#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A10.rkt")
(provide get-weights get-names individual-test test)


(define sequal?-grading
  (lambda (l1 l2)
    (cond
     ((null? l1) (null? l2))
     ((null? l2) (null? l1))
     ((or (not (set?-grading l1))
          (not (set?-grading l2)))
      #f)
     ((member (car l1) l2) (sequal?-grading
                            (cdr l1)
                            (rember-grading
                             (car l1)
                             l2)))
     (else #f))))

(define rember-grading
  (lambda (a ls)
    (cond
     ((null? ls) ls)
     ((equal? a (car ls)) (cdr ls))
     (else (cons (car ls) (rember-grading a (cdr ls)))))))

(define test (make-test ; (r)

    (is-shadowed? equal?
                  [(is-shadowed? 'x '(lambda (x) (lambda (x) y))) #t 1]
                  [(is-shadowed? 'y '(lambda (x) (lambda (x) y))) #f 1]
                  [(is-shadowed? 'x '(lambda (x) (lambda (y) y))) #f 1]
                  [(is-shadowed? 'x '(lambda (x) (lambda (y) (lambda (x) y)))) #t 1]
                  [(is-shadowed? 'y '(lambda (y) (lambda (y) (lambda (x) y)))) #t 1]
                  [(is-shadowed? 'x '(lambda (y) (lambda (x) (lambda (x) y)))) #t 1]
                  [(is-shadowed? 'x '(q (lambda (x) (lambda (x) y)))) #t 1]
                  [(is-shadowed? 'x '((lambda (x) x) (lambda (x) (lambda (y) y)))) #f 1]
                  [(is-shadowed? 'x '((lambda (x) x) (lambda (x) (y (lambda (x) y))))) #t 2]
                  )


  (convert-multip-calls equal?
                        [(convert-multip-calls '(a b c)) '((a b) c) 3]
                        [(convert-multip-calls '(a b)) '(a b) 1]
                        [(convert-multip-calls 'x) 'x 1]                                                
                        [(convert-multip-calls '(a b c d)) '(((a b) c) d) 3]
                        [(convert-multip-calls '(a b c d e f)) '(((((a b) c) d) e) f) 4]
                        [(convert-multip-calls '((a b) (c d))) '((a b) (c d)) 3]
                        [(convert-multip-calls '((a b c) (e f g) (h i j)))
                         '((((a b) c) ((e f) g)) ((h i) j)) 4]
                        [(convert-multip-calls '(lambda (x) (x y z)))
                         '(lambda (x) ((x y) z)) 3]
                        [(convert-multip-calls '((lambda (x) ( a b c)) (lambda (x) (e f g))))
                         '((lambda (x) ((a b) c)) (lambda (x) ((e f) g))) 3]

                        )

  (convert-multip-lambdas equal?
                          [(convert-multip-lambdas '(lambda (x y) x)) '(lambda (x) (lambda (y) x)) 3]
                          [(convert-multip-lambdas '(lambda (x) x)) '(lambda (x) x) 1]
                          [(convert-multip-lambdas '(lambda (x y z) x))
                           '(lambda (x) (lambda (y) (lambda (z) x))) 3]
                          [(convert-multip-lambdas '(lambda (x y) (lambda (a b) (a x))))
                           '(lambda (x) (lambda (y) (lambda (a) (lambda (b) (a x))))) 3]
                          [(convert-multip-lambdas '((lambda (x y) x) q))
                           '((lambda (x) (lambda (y) x)) q) 3]
                          [(convert-multip-lambdas '(u ((lambda (x y) x) q)))
                           '(u ((lambda (x) (lambda (y) x)) q)) 2]
                          )


  (convert-ifs equal?
               [(convert-ifs '(#f #t))
                '((lambda (thenval elseval) elseval) (lambda (thenval elseval) thenval)) 3]
               [(convert-ifs '(lambda (input) (if input #f #t)))
                '(lambda (input) (input (lambda (thenval elseval) elseval) (lambda (thenval elseval) thenval))) 4]
               [(convert-ifs '(lambda (a b) (if a (if b #t #f) #f)))
                '(lambda (a b)
                   (a (b (lambda (thenval elseval) thenval) (lambda (thenval elseval) elseval)) (lambda (thenval elseval) elseval))) 4]
               [(convert-ifs '(lambda (a b) (if a #t b)))
                '(lambda (a b) (a (lambda (thenval elseval) thenval) b)) 4]
               )
   
))

(define set?-grading
  (lambda (s)
    (cond [(null? s) #t]
          [(not (list? s)) #f]
          [(member (car s) (cdr s)) #f]
          [else (set?-grading (cdr s))])))

(implicit-run test) ; run tests as soon as this file is loaded
