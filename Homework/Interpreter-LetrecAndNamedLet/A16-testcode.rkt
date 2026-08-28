#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "interpreter.rkt")
(provide get-weights get-names individual-test test)

(define my-odd?
  (lambda (my-odd? my-even?)
    (lambda (num)
      (if (zero? num)
          #f
          (my-even? (sub1 num))))))
                      
(define my-even?
  (lambda (my-odd? my-even?)
    (lambda (num)
      (if (zero? num)
          #t
          (my-odd? (sub1 num))))))


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
  (basics equal? ; (run-test basics)
    [(eval-one-exp ' (letrec ((fact (lambda (x) (if (zero? x) 1 (* x (fact (- x 1))))))) (map fact '(0 1 2 3 4 5)))) '(1 1 2 6 24 120) 6] ; (run-test basics 1)
    [(eval-one-exp ' (let f ((n 8) (acc 1)) (if (= n 0) acc (f (sub1 n) (* acc n))))) 40320 6] ; (run-test basics 2)
    [(eval-one-exp ' (let ((n 5)) (let f ((n n) (acc 1)) (if (= n 0) acc (f (sub1 n) (* acc n)))))) 120 6] ; (run-test basics 3)
    [(eval-one-exp ' (letrec ((even? (lambda (n) (if (zero? n) #t (odd? (- n 1))))) (odd? (lambda (m) (if (zero? m) #f (even? (- m 1)))))) (list (odd? 3) (even? 3) (odd? 4) (even? 4)))) '(#t #f #f #t) 6] ; (run-test basics 4)
  )

  (answers-are-sets sequal?-grading ; (run-test answers-are-sets)
    [(eval-one-exp ' (letrec ((union (lambda (s1 s2) (cond ((null? s1) s2) ((member? (car s1) s2) (union (cdr s1) s2)) (else (cons (car s1) (union (cdr s1) s2)))))) (member? (lambda (sym ls) (cond ((null? ls) #f) ((eqv? (car ls) sym) #t) (else (member? sym (cdr ls))))))) (union '(a c e d k) '(e b a d c)))) '(k e b d a c) 8] ; (run-test answers-are-sets 1)
    [(eval-one-exp ' (letrec ((product (lambda (x y) (if (null? y) '() (let loop ((x x) (accum '())) (if (null? x) accum (loop (cdr x) (append (map (lambda (s) (list (car x) s)) y) accum)))))))) (product '(1 2 3) '(a b)))) '((3 a) (2 b) (3 b) (2 a) (1 a) (1 b)) 8] ; (run-test answers-are-sets 2)
  )

  (additional equal? ; (run-test additional)
    [(eval-one-exp ' (letrec ((sort (lambda (pred? l) (if (null? l) l (dosort pred? l (length l))))) (merge (lambda (pred? l1 l2) (cond ((null? l1) l2) ((null? l2) l1) ((pred? (car l2) (car l1)) (cons (car l2) (merge pred? l1 (cdr l2)))) (else (cons (car l1) (merge pred? (cdr l1) l2)))))) (dosort (lambda (pred? ls n) (if (= n 1) (list (car ls)) (let ((mid (quotient n 2))) (merge pred? (dosort pred? ls mid) (dosort pred? (list-tail ls mid) (- n mid)))))))) (sort > '(3 8 1 4 2 5 6)))) '(8 6 5 4 3 2 1) 10] ; (run-test additional 1)
  )

  (subst-leftmost equal? ; (run-test subst-leftmost)
    [(eval-one-exp ' (letrec ( (apply-continuation (lambda (k val) (k val))) (subst-left-cps (lambda (new old slist changed unchanged) (let loop ((slist slist) (changed changed) (unchanged unchanged)) (cond ((null? slist) (apply-continuation unchanged #f)) ((symbol? (car slist)) (if (eq? (car slist) old) (apply-continuation changed (cons new (cdr slist))) (loop (cdr slist) (lambda (changed-cdr) (apply-continuation changed (cons (car slist) changed-cdr))) unchanged))) (else (loop (car slist) (lambda (changed-car) (apply-continuation changed (cons changed-car (cdr slist)))) (lambda (t) (loop (cdr slist) (lambda (changed-cdr) (apply-continuation changed (cons (car slist) changed-cdr))) unchanged))))))))) (let ((s '((a b (c () (d e (f g)) h)) i))) (subst-left-cps 'new 'e s (lambda (changed-s) (subst-left-cps 'new 'q s (lambda (wont-be-changed) 'whocares) (lambda (r) (list changed-s)))) (lambda (p) "It's an error to get here"))))) '(((a b (c () (d new (f g)) h)) i)) 10] ; (run-test subst-leftmost 1)
  )

  (y2 equal?
      [(let ([o? (y2 my-odd? my-odd? my-even?)]
             [e? (y2 my-even? my-odd? my-even?)])
         (list (o? 0) (o? 1) (o? 5) (o? 6) (e? 0) (e? 1) (e? 5) (e? 6))) '(#f #t #t #f #t #f #f #t) 0.5])
  (advanced-letrec equal?
                   [(advanced-letrec
                     ((o? (lambda (num)
                            (if (zero? num)
                                #f
                                (e? (sub1 num)))))
                      (e? (lambda (num)
                            (if (zero? num)
                                #t
                                (o? (sub1 num))))))
                     (list (o? 0) (o? 1) (o? 5) (o? 6) (e? 0) (e? 1) (e? 5) (e? 6))) '(#f #t #t #f #t #f #f #t) 0.25]
                   [(advanced-letrec
                     ([a (lambda (lst) (if (null? lst) '() (cons (+ 1 (car lst)) (b (cdr lst)))))]
                      [b (lambda (lst) (if (null? lst) '() (cons (+ 2 (car lst)) (c (cdr lst)))))]
                      [c (lambda (lst) (if (null? lst) '() (cons (+ 3 (car lst)) (d (cdr lst)))))]
                      [d (lambda (lst) (if (null? lst) '() (cons (+ 4 (car lst)) (a (cdr lst)))))])
                     (a '(0 0 0 0 0 0 0 0 0))) '(1 2 3 4 1 2 3 4 1) 0.25]
                   )
))

(define set?-grading
  (lambda (s)
    (cond [(null? s) #t]
          [(not (list? s)) #f]
          [(member (car s) (cdr s)) #f]
          [else (set?-grading (cdr s))])))

(implicit-run test) ; run tests as soon as this file is loaded
