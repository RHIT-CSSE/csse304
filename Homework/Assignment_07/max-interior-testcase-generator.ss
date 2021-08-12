(define num-letters 26)

(define char-list 
  (map integer->char
       (map (lambda (n) (+ (char->integer #\a) n))
	    (iota num-letters))))

(define (double-charlist cycles)
  (map string->symbol
       (let cycle-list ([cycle 0] 
			[big-list '()])
	 (let ([first-char (list-ref char-list cycle)])
	   (if (= cycle cycles)
	       (reverse big-list)
	       (let inner-cycle ([next 0]
				 [inner-list '()])
		 (if (= next num-letters)
		     (cycle-list (+ 1 cycle)
				 (append inner-list big-list))
		     (inner-cycle (+ 1 next)(cons (string (list-ref char-list cycle)
							  (list-ref char-list next))
						  inner-list)))))))))

(define (make-test-case max-depth)
  (let* ([symbols (double-charlist 6)]
	 [char-list  (map integer->char
			  (map (lambda (n) (+ (char->integer #\a) n))
			       (iota num-letters)))]
	 [num-list (map (lambda (x) (- x (/ (length symbols) 2))) (iota (length symbols)))]
	 )
    (let loop ([depth 0])
      (let ([pos (random (length num-list))])
	(if (or (= 0 (modulo pos 6)) (= depth max-depth))
	    (let ([num (list-ref num-list pos)])
	      (set! num-list (remove num num-list))
	      num)
	    (let ([sym (car symbols)])
	      (set! symbols (cdr symbols))
	      (list sym (loop (+ 1 depth)) (loop (+ 1 depth))))))))))

(make-test-case 4)
		      


(bt-max-interior 
 '(aa (ab -7
        (ac 0 (ad (ae (af -2 -10) 
		      (ag 1 -9)) 
		  (ah 5 
		      (ai -3 -12)))))
    (aj -1
        (ak (al (am (an -4 -8) 
		    (ao -5 12)) 
		(ap (aq 2 11) 
		    (ar 7 6)))
            (as 9 10)))))

(bt-max-interior 
 '(aa (ab (ac (ad (ae (af -25 62) 
		    (ag -4 -5))
                (ah (ai -1 -41) 
		    -54))
            (aj (ak (al 35 8) 
		    (am -55 59)) 
		(an (ao -77 76) 
		    (ap -9 48))))
        (aq (ar (as (at 5 74) 
		    (au -26 0))
                (av (aw 51 -56) 
		    (ax 39 70)))
            (ay (az -2 
		    (ba 58 -47)) 
		(bb (bc -11 -76) 
		    (bd -37 -15)))))
    (be -20 55)))

(bt-max-interior 
 '(aa (ab (ac (ad (ae (af (ag 5 74) 
			37) 
		    31)
                (ah (ai (aj 29 -34) 
			(ak -67 18)) 
		    (al (am -41 27) 16)))
            (an (ao (ap (aq 2 -12) 
			(ar -66 59))
                    (as (at -27 -59) 
			(au -32 43)))
                (av (aw (ax -56 -2) 
			(ay 36 40))
                    (az (ba -65 76) 
			(bb -48 -47)))))
        (bc (bd (be (bf 15 
			(bg 75 -77)) 
		    (bh (bi -24 -45) 
			(bj 64 1)))
                (bk (bl (bm -70 -3) 
			(bn -71 35)) 
		    45))
            (bo -78 47)))
    (bp (bq (br (bs (bt (bu 39 49) 
			(bv -11 63))
                    (bw (bx 48 -42) 
			(by 25 33)))
                (bz (ca (cb 38 66) 
			(cc -40 -37))
                    (cd (ce 26 30) 
			(cf -26 58))))
            (cg 28 -39))
        (ch (ci (cj (ck (cl -15 -31) 
			(cm -62 32))
                    (cn (co -54 -57) 
			(cp 13 -73)))
                (cq (cr (cs 68 62) 
			42) 
		    65))
            (ct (cu (cv (cw -8 -49) 
			(cx 24 -60))
                    (cy (cz 73 -5) 
			(da 46 -43)))
                20)))))

(bt-max-interior 
 '(aa (ab (ac (ad 74 46) 
	      (ae 26 -62))
	  (af (ag 23 -27) 
	      (ah -32 15)))
    -9))


(bt-max-interior 
 '(aa (ab (ac (ad 43 -46) 
	      (ae 9 -69))
	  (af (ag -76 32) 
	      (ah 64 7)))
      (ai (aj (ak -55 -24) 
	      (al 21 -2))
	  (am (an -50 -30) 
	      (ao -35 -58)))))

(bt-max-interior 
 '(aa (ab -54 
	  (ac (ad (ae 2 -45) 
		  -10) 
	      -9))
    (af (ag (ah 71 
		(ai -58 5)) 
	    (aj (ak 9 -18) 
		(al 12 60)))
        (am (an (ao 23 74) 
		(ap 33 -73)) 
	    -59))))

(bt-max-interior
 '(aa (ab (ac (ad -46 -22) 
	      (ae 1 -51)) 
	  (af -78 
	      (ag -26 -59)))
    (ah (ai (aj 65 -52) 
	    (ak -73 -28)) 
	(al 22 
	    (am 51 2)))))

(bt-max-interior
 '(aa (ab (ac (ad (ae 24 -75) 
		  (af 55 34))
	      (ag (ah 15 -78) 
		  (ai -31 -11)))
        (aj (ak (al 40 -55) 
		(am 48 -21)) 
	    -77))
      (an (ao (ap -76 
		  (aq 41 67)) 
	      (ar 50 (as 60 -27)))
	  (at 16 
	      (au (av 62 -58) 
		  (aw -9 72))))))

(define (transform-for-A11 a7-test)
  (let loop ([test a7-test])
    (cond [(number? test) (list 'leaf-node test)]
	  [(eq? (car test) 'bt-max-interior)
	   `(max-interior (quote ,(transform-for-A11 (cadadr test))))]
	  [else (list 'interior-node (car test) 
		      (transform-for-A11 (cadr test))
		      (transform-for-A11 (caddr test)))])))
