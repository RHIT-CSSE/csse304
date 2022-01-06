#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A11.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)
  (my-let equal? ; (run-test my-let)
    [(my-let ((a 1)) a) 1 1] ; (run-test my-let 1)
    [(my-let loop ((L (quote (1 2 3 4 5 6 7 8 9 10))) (A 0)) (if (null? L) A (loop (cdr L) (+ (car L) A)))) 55 1] ; (run-test my-let 2)
    [(my-let ((a 5)) (+ 3 (my-let fact ((n a)) (if (zero? n) 1 (* n (fact (- n 1))))))) 123 4] ; (run-test my-let 3)
    [(my-let ((a (lambda () 3))) (my-let ((a (lambda () 5)) (b a)) (b))) 3 1] ; (run-test my-let 4)
  )

  (my-or equal? ; (run-test my-or)
    [(begin (define a #f) (my-or #f (begin (set! a (not a)) a) #f)) #t 1] ; (run-test my-or 1)
    [(let loop ((L (quote (a b 2 5 #f (a b c) #(2 s c) foo a))) (A (quote ()))) (if (null? L) A (loop (cdr L) (if (my-or (number? (car L)) (vector? (car L)) (char? (car L))) (cons (car L) A) A)))) '(#(2 s c) 5 2) 1] ; (run-test my-or 2)
    [(let loop ((L (quote (1 2 3 4 5 a 6)))) (if (null? L) #f (my-or (symbol? (car L)) (loop (cdr L))))) #t 1] ; (run-test my-or 3)
    [(my-or) #f 2] ; (run-test my-or 4)
    [(let ((x 0)) (if (my-or #f 4 (begin (set! x 12) #t)) (set! x (+ x 1)) (set! x (+ x 3))) x) 1 2] ; (run-test my-or 5)
    [(my-or #f 4 3) 4 1] ; (run-test my-or 6)
    [(let ((x 0)) (my-or (begin (set! x (+ 1 x)) x) #f)) 1 2] ; (run-test my-or 7)
    [(my-or 6) 6 2] ; (run-test my-or 8)
  )

  (+= equal? ; (run-test +=)
    [(let ((a 5)) (+= a 10) (+ a 10)) 25 3] ; (run-test += 1)
    [(begin (let* ((a 10) (b 21) (c (+= a (+= b a)))) (list a b c))) '(41 31 41) 3] ; (run-test += 2)
  )

  (return-first equal? ; (run-test return-first)
    [(return-first 2) 2 1] ; (run-test return-first 1)
    [(begin (define a 3) (return-first (+ a 2) (set! a 7) a)) 5 1] ; (run-test return-first 2)
    [(return-first (return-first 3 4 5) 1 2) 3 2] ; (run-test return-first 3)
    [(let ((a 4)) (let ((b (return-first 3 (set! a 5) 2))) (list a b))) '(5 3) 1] ; (run-test return-first 4)
  )

  (bintree-to-list equal? ; (run-test bintree-to-list)
    [(bintree-to-list (leaf-node 3)) '(leaf-node 3) 2] ; (run-test bintree-to-list 1)
    [(bintree-to-list (interior-node (quote a) (interior-node (quote b) (interior-node (quote c) (leaf-node 1) (interior-node (quote d)(leaf-node 2) (leaf-node 3))) (interior-node (quote e) (leaf-node 5) (leaf-node 6))) (interior-node (quote f) (interior-node (quote g) (interior-node (quote h) (interior-node (quote i) (leaf-node 7) (leaf-node 8)) (leaf-node 9)) (leaf-node 10)) (leaf-node 11)))) '(interior-node a (interior-node b (interior-node c (leaf-node 1) (interior-node d (leaf-node 2) (leaf-node 3))) (interior-node e (leaf-node 5) (leaf-node 6))) (interior-node f (interior-node g (interior-node h (interior-node i (leaf-node 7) (leaf-node 8)) (leaf-node 9)) (leaf-node 10)) (leaf-node 11))) 4] ; (run-test bintree-to-list 2)
    [(bintree-to-list (interior-node (quote a) (interior-node (quote b) (interior-node (quote c) (interior-node (quote d) (interior-node (quote e) (interior-node (quote f) (interior-node (quote g) (interior-node (quote h) (interior-node (quote i) (interior-node (quote j) (interior-node (quote k) (interior-node (quote l) (interior-node (quote m) (interior-node (quote n) (interior-node (quote o) (interior-node (quote p) (interior-node (quote q) (interior-node (quote r) (interior-node (quote s) (interior-node (quote t) (interior-node (quote u) (interior-node (quote v) (interior-node (quote w) (interior-node (quote x) (interior-node (quote y) (interior-node (quote z) (leaf-node 1) (leaf-node 2)) (leaf-node 3)) (leaf-node 4)) (leaf-node 5)) (leaf-node 6)) (leaf-node 7)) (leaf-node 8)) (leaf-node 9)) (leaf-node 10)) (leaf-node 11)) (leaf-node 12)) (leaf-node 13)) (leaf-node 14)) (leaf-node 15)) (leaf-node 16)) (leaf-node 17)) (leaf-node 18)) (leaf-node 19)) (leaf-node 20)) (leaf-node 21)) (leaf-node 22)) (leaf-node 23)) (leaf-node 24)) (leaf-node 25)) (leaf-node 26)) (leaf-node 27))) '(interior-node a (interior-node b (interior-node c (interior-node d (interior-node e (interior-node f (interior-node g (interior-node h (interior-node i (interior-node j (interior-node k (interior-node l (interior-node m (interior-node n (interior-node o (interior-node p (interior-node q (interior-node r (interior-node s (interior-node t (interior-node u (interior-node v (interior-node w (interior-node x (interior-node y (interior-node z (leaf-node 1) (leaf-node 2)) (leaf-node 3)) (leaf-node 4)) (leaf-node 5)) (leaf-node 6)) (leaf-node 7)) (leaf-node 8)) (leaf-node 9)) (leaf-node 10)) (leaf-node 11)) (leaf-node 12)) (leaf-node 13)) (leaf-node 14)) (leaf-node 15)) (leaf-node 16)) (leaf-node 17)) (leaf-node 18)) (leaf-node 19)) (leaf-node 20)) (leaf-node 21)) (leaf-node 22)) (leaf-node 23)) (leaf-node 24)) (leaf-node 25)) (leaf-node 26)) (leaf-node 27)) 4] ; (run-test bintree-to-list 3)
  )

  (max-interior equal? ; (run-test max-interior)
    [(max-interior (interior-node (quote a) (interior-node (quote b) (leaf-node -21) (interior-node (quote d) (leaf-node 4) (interior-node (quote e) (leaf-node 5) (leaf-node 6)))) (interior-node (quote q) (leaf-node 4) (interior-node (quote r) (leaf-node -2) (leaf-node 70))))) 'q 3] ; (run-test max-interior 1)
    [(max-interior (interior-node (quote a) (interior-node (quote b) (leaf-node -3) (leaf-node -4)) (interior-node (quote c) (leaf-node -1) (interior-node (quote d) (leaf-node -1) (interior-node (quote e) (leaf-node -1) (leaf-node -5)))))) 'e 3] ; (run-test max-interior 2)
    [(max-interior (interior-node (quote a) (leaf-node -100) (leaf-node -50))) 'a 3] ; (run-test max-interior 3)
    [(max-interior (interior-node (quote a) (interior-node (quote b) (interior-node (quote e) (leaf-node -10) (leaf-node -100)) (leaf-node 100)) (interior-node (quote c) (leaf-node 100) (interior-node (quote f) (leaf-node -100) (leaf-node -11))))) 'b 3] ; (run-test max-interior 4)
    [(max-interior (interior-node (quote a) (interior-node (quote b) (interior-node (quote e) (leaf-node -10) (leaf-node 100)) (leaf-node -100)) (interior-node (quote c) (leaf-node -100) (interior-node (quote f) (leaf-node 100) (leaf-node 10))))) 'f 3] ; (run-test max-interior 5)
    [(max-interior (interior-node (quote a) (interior-node (quote b) (interior-node (quote c) (leaf-node 1) (interior-node (quote d) (leaf-node 2) (leaf-node 3))) (interior-node (quote e) (leaf-node 5) (leaf-node 6))) (interior-node (quote f) (interior-node (quote g) (interior-node (quote h) (interior-node (quote i) (leaf-node 7) (leaf-node 8)) (leaf-node 9)) (leaf-node 10)) (leaf-node 11)))) 'a 3] ; (run-test max-interior 6)
    [(max-interior (interior-node (quote a) (leaf-node -3) (interior-node (quote b) (leaf-node 2) (interior-node (quote c) (leaf-node -1234567890) (leaf-node (* -123099487598375943759874 98734598743598585024320)))))) 'b 3] ; (run-test max-interior 7)
    [(max-interior '(interior-node aa (interior-node ab (interior-node ac (interior-node ad (interior-node ae (leaf-node 24) (leaf-node -75)) (interior-node af (leaf-node 55) (leaf-node 34))) (interior-node ag (interior-node ah (leaf-node 15) (leaf-node -78)) (interior-node ai (leaf-node -31) (leaf-node -11)))) (interior-node aj (interior-node ak (interior-node al (leaf-node 40) (leaf-node -55)) (interior-node am (leaf-node 48) (leaf-node -21))) (leaf-node -77))) (interior-node an (interior-node ao (interior-node ap (leaf-node -76) (interior-node aq (leaf-node 41) (leaf-node 67))) (interior-node ar (leaf-node 50) (interior-node as (leaf-node 60) (leaf-node -27)))) (interior-node at (leaf-node 16) (interior-node au (interior-node av (leaf-node 62) (leaf-node -58)) (interior-node aw (leaf-node -9) (leaf-node 72))))))) 'an 6] ; (run-test max-interior 8)
    [(max-interior '(interior-node aa (interior-node ab (interior-node ac (interior-node ad (interior-node ae (interior-node af (interior-node ag (leaf-node 5) (leaf-node 74)) (leaf-node 37)) (leaf-node 31)) (interior-node ah (interior-node ai (interior-node aj (leaf-node 29) (leaf-node -34)) (interior-node ak (leaf-node -67) (leaf-node 18))) (interior-node al (interior-node am (leaf-node -41) (leaf-node 27)) (leaf-node 16)))) (interior-node an (interior-node ao (interior-node ap (interior-node aq (leaf-node 2) (leaf-node -12)) (interior-node ar (leaf-node -66) (leaf-node 59))) (interior-node as (interior-node at (leaf-node -27) (leaf-node -59)) (interior-node au (leaf-node -32) (leaf-node 43)))) (interior-node av (interior-node aw (interior-node ax (leaf-node -56) (leaf-node -2)) (interior-node ay (leaf-node 36) (leaf-node 40))) (interior-node az (interior-node ba (leaf-node -65) (leaf-node 76)) (interior-node bb (leaf-node -48) (leaf-node -47)))))) (interior-node bc (interior-node bd (interior-node be (interior-node bf (leaf-node 15) (interior-node bg (leaf-node 75) (leaf-node -77))) (interior-node bh (interior-node bi (leaf-node -24) (leaf-node -45)) (interior-node bj (leaf-node 64) (leaf-node 1)))) (interior-node bk (interior-node bl (interior-node bm (leaf-node -70) (leaf-node -3)) (interior-node bn (leaf-node -71) (leaf-node 35))) (leaf-node 45))) (interior-node bo (leaf-node -78) (leaf-node 47)))) (interior-node bp (interior-node bq (interior-node br (interior-node bs (interior-node bt (interior-node bu (leaf-node 39) (leaf-node 49)) (interior-node bv (leaf-node -11) (leaf-node 63))) (interior-node bw (interior-node bx (leaf-node 48) (leaf-node -42)) (interior-node by (leaf-node 25) (leaf-node 33)))) (interior-node bz (interior-node ca (interior-node cb (leaf-node 38) (leaf-node 66)) (interior-node cc (leaf-node -40) (leaf-node -37))) (interior-node cd (interior-node ce (leaf-node 26) (leaf-node 30)) (interior-node cf (leaf-node -26) (leaf-node 58))))) (interior-node cg (leaf-node 28) (leaf-node -39))) (interior-node ch (interior-node ci (interior-node cj (interior-node ck (interior-node cl (leaf-node -15) (leaf-node -31)) (interior-node cm (leaf-node -62) (leaf-node 32))) (interior-node cn (interior-node co (leaf-node -54) (leaf-node -57)) (interior-node cp (leaf-node 13) (leaf-node -73)))) (interior-node cq (interior-node cr (interior-node cs (leaf-node 68) (leaf-node 62)) (leaf-node 42)) (leaf-node 65))) (interior-node ct (interior-node cu (interior-node cv (interior-node cw (leaf-node -8) (leaf-node -49)) (interior-node cx (leaf-node 24) (leaf-node -60))) (interior-node cy (interior-node cz (leaf-node 73) (leaf-node -5)) (interior-node da (leaf-node 46) (leaf-node -43)))) (leaf-node 20)))))) 'br 6] ; (run-test max-interior 9)
    [(max-interior '(interior-node aa (interior-node ab (leaf-node -7) (interior-node ac (leaf-node 0) (interior-node ad (interior-node ae (interior-node af (leaf-node -2) (leaf-node -10)) (interior-node ag (leaf-node 1) (leaf-node -9))) (interior-node ah (leaf-node 5) (interior-node ai (leaf-node -3) (leaf-node -12)))))) (interior-node aj (leaf-node -1) (interior-node ak (interior-node al (interior-node am (interior-node an (leaf-node -4) (leaf-node -8)) (interior-node ao (leaf-node -5) (leaf-node 12))) (interior-node ap (interior-node aq (leaf-node 2) (leaf-node 11)) (interior-node ar (leaf-node 7) (leaf-node 6)))) (interior-node as (leaf-node 9) (leaf-node 10)))))) 'ak 7] ; (run-test max-interior 10)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
