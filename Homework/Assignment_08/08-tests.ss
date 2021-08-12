; These are some tests that I plan t oeventually incorporate into the
; ususal test-case format(s), but that is unlikely to happen until 
; after the exam.  If you are working ahead on Assignment 8, 
; you can use these tests for now.

; As of 3/23, there is a problem with the server that prevents me
; making new assignments and test cases there


;; You can paste these tests into Scheme individually.
;; if you want to run all of them, uncomment the next two lines and 
;; last line of this file.

;; (map (lambda (x) (display x) (newline))
;; (list
  (slist-map symbol? '())
  (slist-map symbol? '())
  (slist-map symbol? '(a b (c) () d))
  (slist-map (lambda (x) (list x 'x))  '(a b (c) () d))
  (slist-map 
    (lambda (x) 
      (let ([s (symbol->string x)]) 
        (string->symbol(string-append s s)))) 
    '((b (c) d) e ((a)) () e))

  ' reverse
  (slist-reverse '())
  (slist-reverse '(a b))
  (slist-reverse '((a b) c))
  (slist-reverse '((a b) c ((d) e) () f))

  'paren-count
  (slist-paren-count '())
  (slist-paren-count '((a)))
  (slist-paren-count '((a ((b)))))
  (slist-paren-count '((a ((b) ()))))
  (slist-paren-count '((a ((b c d e) () f))))

  'depth
  (slist-depth '())
  (slist-depth '(a))
  (slist-depth '((a)))
  (slist-depth '(() (((())))))
  (slist-depth '( () (a) ((s b (c) ()))))
  (slist-depth '(a (b c (d (x x) e)) ((f () g h))))

  'symbols-at-depth
  (slist-symbols-at-depth '(a (b c) d) 2)
  (slist-symbols-at-depth '(a (b c) d) 1)
  (slist-symbols-at-depth '(a (b c) d) 3)
  (slist-symbols-at-depth '(a (b c (d (x x) e)) ((f () g h))) 1)

  'subst-leftmost
  (subst-leftmost 'k 'b '() eq?)
  (subst-leftmost 'k 'b '(b b) eq?)
  (subst-leftmost 'k 'b '(a b a b) eq?)
  (subst-leftmost 'k 'b '(a ((b b)) a b) eq?)
  ( subst-leftmost 'k 'b '((c d a (e () f b (c b)) (a b)) (b)) eq?)
  (subst-leftmost 'b 'a '(c (A e) a d) 
     (lambda (x y) (string-ci<=? (symbol->string x) (symbol->string y))))

  'bt-leaf-sum

  (bt-leaf-sum 0) 
  (bt-leaf-sum '(a 2 3))
  (bt-leaf-sum '(a 5 (b 4 7)))
  (bt-leaf-sum '(m (l (h 0 (u 1 2)) 3) (n (a 4 5 ) 6)))
  (bt-leaf-sum '(l (s (r (f 0 (i 1 2))
			     3)
			  (t 4 (c 5 6)))
		       (s (a 7 (s 8 9)) 10)))
  'bt-inorder-list

  (bt-inorder-list 0)
  (bt-inorder-list '(a 4 5))
  (bt-inorder-list '(m (l (h 0 (u 1 2)) 3) (n (a 4 5 ) 6)))
  (bt-inorder-list '(l (s (r (f 0 (i 1 2))
			     3)
			  (t 4 (c 5 6)))
		       (s (a 7 (s 8 9)) 10)))

  'bt-max

  (bt-max -1)   (bt-max '(a 2 3))
  (bt-max '(a 5 (b 4 7)))
  (bt-max '(m (l (h 100 (u 1 2)) 3) (n (a 4 5 ) 6)))
  (bt-max '(l (s (r (f 0 (i 1 2))
			     3)
			  (t 4 (c 1200 6)))
		       (s (a 7 (s 8 9)) 10)))
  'bt-max-interior

  (bt-max-interior '(a -5 -4))
  (bt-max-interior '(a (b 1 2) -4))
  (bt-max-interior '(a (b -1 -2) (c -2 -2)))
  (bt-max-interior '(a (b -1 -3) (c -2 -2)))
  (bt-max-interior '(a (b (c (d (e 3 2) -1) 4) -2) (f 0 (g 0 1))))
  (bt-max-interior '(b (a -3000 -4000) -2000))

;;))

