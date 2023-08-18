#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A07.rkt")
(provide get-weights get-names individual-test test)

(define test (make-test ; (r)

  (group-by-two equal? ; (run-test group-by-two)
    [(group-by-two '()) '() 1] ; (run-test group-by-two 1)
    [(group-by-two '(a)) '((a)) 1] ; (run-test group-by-two 2)
    [(group-by-two '(a b)) '((a b)) 2] ; (run-test group-by-two 3)
    [(group-by-two '(a b c)) '((a b) (c)) 2] ; (run-test group-by-two 4)
    [(group-by-two '(a b c d e f g)) '((a b) (c d) (e f) (g)) 2] ; (run-test group-by-two 5)
    [(group-by-two '(a b c d e f g h)) '((a b) (c d) (e f) (g h)) 2] ; (run-test group-by-two 6)
  )

  (group-by-n equal? ; (run-test group-by-n)
    [(group-by-n '() 3) '() 1] ; (run-test group-by-n 1)
    [(group-by-n '(a b c d e f g) 3) '((a b c) (d e f) (g)) 2] ; (run-test group-by-n 2)
    [(group-by-n '(a b c d e f g) 4) '((a b c d) (e f g)) 3] ; (run-test group-by-n 3)
    [(group-by-n '(a b c d e f g h) 4) '((a b c d) (e f g h)) 4] ; (run-test group-by-n 4)
    [(group-by-n '(a b c d e f g h i j k l m n o) 7) '((a b c d e f g) (h i j k l m n) (o)) 4] ; (run-test group-by-n 5)
    [(group-by-n '(a b c d e f g h) 17) '((a b c d e f g h)) 3] ; (run-test group-by-n 6)
    [(group-by-n '(a b c d e f g h i j k l m n o p q r s t) 17) '((a b c d e f g h i j k l m n o p q) (r s t)) 3] ; (run-test group-by-n 7)
  )

  (bt-leaf-sum equal? ; (run-test bt-leaf-sum)
    [(bt-leaf-sum -4) '-4 1] ; (run-test bt-leaf-sum 1)
    [(bt-leaf-sum '(a 2 3)) 5 1] ; (run-test bt-leaf-sum 2)
    [(bt-leaf-sum '(a 5 (b 4 7))) 16 2] ; (run-test bt-leaf-sum 3)
    [(bt-leaf-sum '(m (l (h 0 (u 1 2)) 3) (n (a 4 5 ) 6))) 21 2] ; (run-test bt-leaf-sum 4)
    [(bt-leaf-sum '(l (s (r (f 0 (i 1 2)) 3) (t 4 (c 5 6))) (s (a 7 (s 8 9)) 10))) 55 4] ; (run-test bt-leaf-sum 5)
  )

  (bt-inorder-list equal? ; (run-test bt-inorder-list)
    [(bt-inorder-list 0) '() 1] ; (run-test bt-inorder-list 1)
    [(bt-inorder-list '(a 4 5)) '(a) 1] ; (run-test bt-inorder-list 2)
    [(bt-inorder-list '(m (l (h 0 (u 1 2)) 3) (n (a 4 5 ) 6))) '(h u l m a n) 4] ; (run-test bt-inorder-list 3)
    [(bt-inorder-list '(l (s (r (f 0 (i 1 2)) 3) (t 4 (c 5 6))) (s (a 7 (s 8 9)) 10))) '(f i r s t c l a s s) 4] ; (run-test bt-inorder-list 4)
  )

  (bt-max equal? ; (run-test bt-max)
    [(bt-max -1) '-1 1] ; (run-test bt-max 1)
    [(bt-max '(a 2 3)) 3 1] ; (run-test bt-max 2)
    [(bt-max '(a 5 (b 4 7))) 7 2] ; (run-test bt-max 3)
    [(bt-max '(m (l (h 100 (u 1 2)) 3) (n (a 4 5 ) 6))) 100 3] ; (run-test bt-max 4)
    [(bt-max '(l (s (r (f 0 (i 1 2)) 3) (t 4 (c 1200 6))) (s (a 7 (s 8 9)) 10))) 1200 3] ; (run-test bt-max 5)
  )

  (bt-max-interior equal? ; (run-test bt-max-interior)
    [(bt-max-interior '(a -5 -4)) 'a 2] ; (run-test bt-max-interior 1)
    [(bt-max-interior '(a (b 1 2) -4)) 'b 2] ; (run-test bt-max-interior 2)
    [(bt-max-interior '(a (b -1 -2) (c -2 -2))) 'b 3] ; (run-test bt-max-interior 3)
    [(bt-max-interior '(a (b (c (d (e 3 2) -1) 4) -2) (f 0 (g 0 1)))) 'c 3] ; (run-test bt-max-interior 4)
    [(bt-max-interior '(b (a -3000 -4000) -2000)) 'a 4] ; (run-test bt-max-interior 5)
    [(bt-max-interior '(a (b -1 -2) (c -1 -2))) 'b 2] ; (run-test bt-max-interior 6)
    [(bt-max-interior '(a 2 (c (d -1 -2) (e -1 -2)))) 'd 2] ; (run-test bt-max-interior 7)
    [(bt-max-interior (quote (a (b (d 5 5) -10) (c (e 5 5) -10)))) 'd 2] ; (run-test bt-max-interior 8)
  )

  (bt-max-interior-harder equal? ; (run-test bt-max-interior-harder)
    [(bt-max-interior '(aa (ab -7 (ac 0 (ad (ae (af -2 -10) (ag 1 -9)) (ah 5 (ai -3 -12))))) (aj -1 (ak (al (am (an -4 -8) (ao -5 12)) (ap (aq 2 11) (ar 7 6))) (as 9 10))))) 'ak 1] ; (run-test bt-max-interior-harder 1)
    [(bt-max-interior '(aa (ab (ac (ad (ae (af -25 62) (ag -4 -5)) (ah (ai -1 -41) -54)) (aj (ak (al 35 8) (am -55 59)) (an (ao -77 76) (ap -9 48)))) (aq (ar (as (at 5 74) (au -26 0)) (av (aw 51 -56) (ax 39 70))) (ay (az -2 (ba 58 -47)) (bb (bc -11 -76) (bd -37 -15))))) (be -20 55))) 'ar 1] ; (run-test bt-max-interior-harder 2)
    [(bt-max-interior '(aa (ab (ac (ad (ae (af (ag 5 74) 37) 31) (ah (ai (aj 29 -34) (ak -67 18)) (al (am -41 27) 16))) (an (ao (ap (aq 2 -12) (ar -66 59)) (as (at -27 -59) (au -32 43))) (av (aw (ax -56 -2) (ay 36 40)) (az (ba -65 76) (bb -48 -47))))) (bc (bd (be (bf 15 (bg 75 -77)) (bh (bi -24 -45) (bj 64 1))) (bk (bl (bm -70 -3) (bn -71 35)) 45)) (bo -78 47))) (bp (bq (br (bs (bt (bu 39 49) (bv -11 63)) (bw (bx 48 -42) (by 25 33))) (bz (ca (cb 38 66) (cc -40 -37)) (cd (ce 26 30) (cf -26 58)))) (cg 28 -39)) (ch (ci (cj (ck (cl -15 -31) (cm -62 32)) (cn (co -54 -57) (cp 13 -73))) (cq (cr (cs 68 62) 42) 65)) (ct (cu (cv (cw -8 -49) (cx 24 -60)) (cy (cz 73 -5) (da 46 -43))) 20))))) 'br 1] ; (run-test bt-max-interior-harder 3)
    [(bt-max-interior '(aa (ab (ac (ad 74 46) (ae 26 -62)) (af (ag 23 -27) (ah -32 15))) -9)) 'ad 1] ; (run-test bt-max-interior-harder 4)
    [(bt-max-interior '(aa (ab (ac (ad 43 -46) (ae 9 -69)) (af (ag -76 32) (ah 64 7))) (ai (aj (ak -55 -24) (al 21 -2)) (am (an -50 -30) (ao -35 -58))))) 'ah 1] ; (run-test bt-max-interior-harder 5)
    [(bt-max-interior '(aa (ab (ac (ad -46 -22) (ae 1 -51)) (af -78 (ag -26 -59))) (ah (ai (aj 65 -52) (ak -73 -28)) (al 22 (am 51 2))))) 'al 1] ; (run-test bt-max-interior-harder 6)
    [(bt-max-interior '(aa (ab (ac (ad (ae 24 -75) (af 55 34)) (ag (ah 15 -78) (ai -31 -11))) (aj (ak (al 40 -55) (am 48 -21)) -77)) (an (ao (ap -76 (aq 41 67)) (ar 50 (as 60 -27))) (at 16 (au (av 62 -58) (aw -9 72)))))) 'an 1] ; (run-test bt-max-interior-harder 7)
  )
))

(implicit-run test) ; run tests as soon as this file is loaded
