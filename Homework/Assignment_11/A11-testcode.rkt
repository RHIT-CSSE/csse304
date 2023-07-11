#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A11.rkt")
(provide get-weights get-names individual-test test)

(define exn:parse?
  (lambda (e)
    (and (exn:fail? e)
         (or (equal? (exn-message e) "error: parse-exp")
             (equal? (substring (exn-message e) 0 10) "parse-exp:")))))

(define test (make-test ; (r)
  (bintree-add equal?
    [(bintree-to-list (bintree-add (leaf-node 3) 3)) 6 3]
    [(bintree-to-list (bintree-add (interior-node 'q (leaf-node 3) (leaf-node 4)) 3)) '(q 6 7) 3]
    [(bintree-to-list (bintree-add (interior-node 'x
                                    (interior-node 'q (leaf-node 3) (leaf-node 4))
                                    (interior-node 'v (leaf-node 0) (leaf-node 1))) 1)) '(x (q 4 5) (v 1 2)) 4]
    )
  (parse-invalid equal? ; (run-test parse-invalid)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (lambda (a))))) "parse-error" 1] ; (run-test parse-invalid 1)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (lambda x)))) "parse-error" 1] ; (run-test parse-invalid 2)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (a b . c)))) "parse-error" 1] ; (run-test parse-invalid 3)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (lambda (a b 1) c)))) "parse-error" 2] ; (run-test parse-invalid 4)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (if a)))) "parse-error" 2] ; (run-test parse-invalid 5)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (let ((a b)))))) "parse-error" 2] ; (run-test parse-invalid 6)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (letrec ((a b)))))) "parse-error" 2] ; (run-test parse-invalid 7)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (let ((a b) . c) e)))) "parse-error" 3] ; (run-test parse-invalid 8)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (let ((a b) (c d) (e . f)) g)))) "parse-error" 3] ; (run-test parse-invalid 9)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (letrec ((a b) (c d) (e (lambda x))) g)))) "parse-error" 3] ; (run-test parse-invalid 10)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (let* a b)))) "parse-error" 3] ; (run-test parse-invalid 11)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (letrec a b)))) "parse-error" 2] ; (run-test parse-invalid 12)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (let ((a b c) (d e)) f)))) "parse-error" 3] ; (run-test parse-invalid 13)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (let* ((a b c) (d e)) f)))) "parse-error" 2] ; (run-test parse-invalid 14)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (letrec ((a b) (c)) d)))) "parse-error" 2] ; (run-test parse-invalid 15)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (let ((a b) (3 c)) d)))) "parse-error" 1] ; (run-test parse-invalid 16)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (letrec ((a b) (3 c)) d)))) "parse-error" 1] ; (run-test parse-invalid 17)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (let* ((a b) (3 c)) d)))) "parse-error" 3] ; (run-test parse-invalid 18)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (let ((a (lambda (x)))))))) "parse-error" 2] ; (run-test parse-invalid 19)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp (quote (set! x)))) "parse-error" 2] ; (run-test parse-invalid 20)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp '(let ((a (let ((b (if x))) b))) a))) "parse-error" 2] ; (run-test parse-invalid 21)
    [(with-handlers ([exn:parse? (lambda (e) "parse-error")]) (parse-exp '(set! x (let ((a (set! a b c))) a)))) "parse-error" 2] ; (run-test parse-invalid 22)
  )

  (parse-unparse equal? ; (run-test parse-unparse)
    [(unparse-exp (parse-exp (quote x))) 'x 1] ; (run-test parse-unparse 1)
    [(unparse-exp (parse-exp (quote (lambda (x) (+ x 5))))) '(lambda (x) (+ x 5)) 1] ; (run-test parse-unparse 2)
    [(unparse-exp (parse-exp (quote (lambda x y z)))) '(lambda x y z) 1] ; (run-test parse-unparse 3)
    [(unparse-exp (parse-exp (quote (let ((x y)) x x x y)))) '(let ((x y)) x x x y) 1] ; (run-test parse-unparse 4)
    [(unparse-exp (parse-exp (quote (lambda (x) 1 z)))) '(lambda (x) 1 z) 1] ; (run-test parse-unparse 5)
    [(unparse-exp (parse-exp (quote (let* ((a b) (c d) (e f)) g h)))) '(let* ((a b) (c d) (e f)) g h) 1] ; (run-test parse-unparse 6)
    [(unparse-exp (parse-exp (quote (let* ((a b)) b)))) '(let* ((a b)) b) 1] ; (run-test parse-unparse 7)
    [(unparse-exp (parse-exp (quote (lambda x x y)))) '(lambda x x y) 1] ; (run-test parse-unparse 8)
    [(unparse-exp (parse-exp (quote (let ((x 1) (y (let () (let ((z t)) z)))) (+ z y))))) '(let ((x 1) (y (let () (let ((z t)) z)))) (+ z y)) 1] ; (run-test parse-unparse 9)
    [(unparse-exp (parse-exp (quote (lambda () (letrec ((foo (lambda (L) (if (null? L) 3 (if (symbol? (car L)) (cons (car L) (foo (cdr L))) (foo (cdr L))))))) foo))))) '(lambda () (letrec ((foo (lambda (L) (if (null? L) 3 (if (symbol? (car L)) (cons (car L) (foo (cdr L))) (foo (cdr L))))))) foo)) 2] ; (run-test parse-unparse 10)
    [(unparse-exp (parse-exp (quote (lambda (x) (if (boolean? x) '#(1 2 3 4) 1234))))) '(lambda (x) (if (boolean? x) '#(1 2 3 4) 1234)) 1] ; (run-test parse-unparse 11)
    [(unparse-exp (parse-exp (quote (lambda x (car x))))) '(lambda x (car x)) 1] ; (run-test parse-unparse 12)
    [(unparse-exp (parse-exp (quote (lambda (c) (if (char? c) string 12345))))) '(lambda (c) (if (char? c) string 12345)) 2] ; (run-test parse-unparse 13)
    [(unparse-exp (parse-exp (quote (lambda (datum) (or (number? datum) (boolean? datum) (null? datum) (string? datum) (symbol? datum) (pair? datum) (vector? datum)))))) '(lambda (datum) (or (number? datum) (boolean? datum) (null? datum) (string? datum) (symbol? datum) (pair? datum) (vector? datum))) 2] ; (run-test parse-unparse 14)
    [(unparse-exp (parse-exp (quote (lambda (t) (let ((L (build-list t)) (sum< (lambda (a b) (< (cdr a) (cdr b)))) (intsum? (lambda (x) (symbol? (car x))))) (car (genmax sum< (filter intsum? L)))))))) '(lambda (t) (let ((L (build-list t)) (sum< (lambda (a b) (< (cdr a) (cdr b)))) (intsum? (lambda (x) (symbol? (car x))))) (car (genmax sum< (filter intsum? L))))) 2] ; (run-test parse-unparse 15)
    [(unparse-exp (parse-exp (quote (letrec ((a (lambda () (b 2))) (b (lambda (x) (- x 4)))) (lambda () (a)))))) '(letrec ((a (lambda () (b 2))) (b (lambda (x) (- x 4)))) (lambda () (a))) 3] ; (run-test parse-unparse 16)
    [(unparse-exp (parse-exp (quote (let* ((a (lambda () (c 4))) (b a)) (lambda (b) (a)))))) '(let* ((a (lambda () (c 4))) (b a)) (lambda (b) (a))) 3] ; (run-test parse-unparse 17)
    [(unparse-exp (parse-exp (quote (lambda x (cons a x))))) '(lambda x (cons a x)) 3] ; (run-test parse-unparse 18)
    [(unparse-exp (parse-exp (quote (lambda x (let* ((a x) (b (cons x a))) b))))) '(lambda x (let* ((a x) (b (cons x a))) b)) 3] ; (run-test parse-unparse 19)
    [(unparse-exp (parse-exp (quote (lambda (a b c) (let* ((dbl (lambda x (append x x))) (lst (dbl a b c))) lst))))) '(lambda (a b c) (let* ((dbl (lambda x (append x x))) (lst (dbl a b c))) lst)) 3] ; (run-test parse-unparse 20)
    [(unparse-exp (parse-exp (quote (lambda a (letrec ((stuff (lambda (b) (if (null? b) (list) (cons (car b) (stuff (cdr b))))))) (stuff a)))))) '(lambda a (letrec ((stuff (lambda (b) (if (null? b) (list) (cons (car b) (stuff (cdr b))))))) (stuff a))) 3] ; (run-test parse-unparse 21)
    [(unparse-exp (parse-exp (quote (lambda (a b c) (let* ((a b) (d (append a c))) d))))) '(lambda (a b c) (let* ((a b) (d (append a c))) d)) 3] ; (run-test parse-unparse 22)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
