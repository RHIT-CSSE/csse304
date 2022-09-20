#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "testcode-base.rkt")
(require "Exam1-202220.rkt")
(provide get-weights get-names individual-test test)

(define (equal-boolcare a b)
  (if (eq? b #t)
      (if a #t #f)
      (equal? a b)))

(define test (make-test ; (r)
  (largest-range equal? ; (run-test largest-range)
                 [(largest-range '((1 3) (9 10))) '(1 3) 1] ; (run-test largest-range 1)
                 [(largest-range '((1 3) (9 10) (11 15))) '(11 15) 1] ; (run-test largest-range 2)
                 [(largest-range '((100 200) (1 3) (9 10) (11 15))) '(100 200) 1] ; (run-test largest-range 3)
                 [(largest-range '((1 3) (3 4))) '(1 3) 1] ; (run-test largest-range 4)
                 [(largest-range '()) '(0 0) 1] ; (run-test largest-range 5)                                  
                 )
  (combine-consec equal? ; (run-test combine-consec)
                 [(combine-consec '(1 5)) '((1 1) (5 5)) 1] ; (run-test combine-consec 1)
                 [(combine-consec '(1 2 3 4 5)) '((1 5)) 1] ; (run-test combine-consec 2)
                 [(combine-consec '(1 2 3 4 5 7 8 9)) '((1 5) (7 9)) 1] ; (run-test combine-consec 3)
                 [(combine-consec '(1 2 4 7 8 9 20)) '((1 2) (4 4) (7 9) (20 20)) 1] ; (run-test combine-consec 4)
                 [(combine-consec '()) '() 1] ; (run-test combine-consec 5)                  
                  )
  (make-group-basic equal-boolcare ; (run-test make-group-basic)
                    [(let ((g1 (make-group)))
                       (g1 'has-member? 'buffalo))
                     #f
                     1] ; (run-test make-group-basic 1)
                    [(let ((g1 (make-group)))
                       (g1 'add-member 'buffalo)
                       (g1 'has-member? 'buffalo))
                     #t
                     1] ; (run-test make-group-basic 2)
                    [(let ((g1 (make-group)))
                       (g1 'add-member 'buffalo)
                       (g1 'add-member 'robert)
                       (g1 'has-member? 'buffalo))
                     #t
                     1] ; (run-test make-group-basic 3)
                    [(let ((g1 (make-group)))
                       (g1 'add-member 'buffalo)
                       (g1 'add-member 'robert)
                       (g1 'has-member? 'robert))
                     #t
                     1] ; (run-test make-group-basic 4)
                    [(let ((g1 (make-group)))
                       (g1 'add-member 'buffalo)
                       (g1 'add-member 'robert)
                       (g1 'has-member? 'yiji))
                     #f
                     1] ; (run-test make-group-basic 5)
                    )

    (make-group-subgroup equal-boolcare ; (run-test make-group-subgroup)
                    [(let ((g1 (make-group)))
                       (g1 'add-member 'buffalo)
                       (let ((g2 (g1 'make-subgroup)))
                         (g2 'add-member 'buffalo)
                         (g2 'has-member? 'buffalo)))
                     #t
                     1] ; (run-test make-group-subgroup 1)
                    [(let ((g1 (make-group)))
                       (g1 'add-member 'buffalo)
                       (let ((g2 (g1 'make-subgroup)))
                         (g2 'has-member? 'buffalo)))
                     #f
                     1] ; (run-test make-group-subgroup 2)
  
                    [(let ((g1 (make-group)))
                       (g1 'add-member 'robert)
                       (let ((g2 (g1 'make-subgroup)))
                         (g2 'add-member 'buffalo)
                         (g2 'has-member? 'buffalo)))
                     #f
                     1] ; (run-test make-group-subgroup 3)
                    [(let ((g1 (make-group)))
                       (g1 'add-member 'robert)
                       (let ((g2 (g1 'make-subgroup)))
                         (g2 'add-member 'robert)
                         (let ((g3 (g2 'make-subgroup)))
                           (g2 'add-member 'robert)
                           (g2 'has-member? 'robert))))
                     #t
                     1] ; (run-test make-group-subgroup 4)
                    [(let ((g1 (make-group)))
                       (g1 'add-member 'robert)
                       (let ((g2 (g1 'make-subgroup)))
                         (let ((g3 (g2 'make-subgroup)))
                           (g3 'add-member 'robert)
                           (g3 'has-member? 'robert))))
                     #f
                     1] ; (run-test make-group-subgroup 5)
                    )

    (rename-free equal? ; (run-test rename-free)
                 [(rename-free 'old 'new 'old) 'new 1] ; (run-test rename-free 1)
                 [(rename-free 'o 'n '(o o)) '(n n) 1] ; (run-test rename-free 2)
                 [(rename-free 'o 'n '(o (x o))) '(n (x n)) 1] ; (run-test rename-free 3)
                 [(rename-free 'o 'n '(o (lambda (x) (x o)))) '(n (lambda (x) (x n))) 1] ; (run-test rename-free 4)
                 [(rename-free 'o 'n '(o (lambda (o) (x o)))) '(n (lambda (o) (x o))) 1] ; (run-test rename-free 5)
                 [(rename-free 'o 'n '((lambda (o) o)  (lambda (y) (x o)))) '((lambda (o) o) (lambda (y) (x n))) 1] ; (run-test rename-free 6)
                 [(rename-free 'o 'n '((lambda (o) (lambda (y) o)) o)) '((lambda (o) (lambda (y) o)) n) 7] ; (run-test rename-free 7)
                 )

    
    (listbox-func equal? ; (run-test listbox-func)
                  [(let ((L+ (listbox-func +))) (L+ '(1) '(2) '(3))) '(6)  1] ; (run-test listbox-func 1)
                  [(let ((L+ (listbox-func +))) (L+ '(1) (L+ '(2) '(3)))) '(6)  1] ; (run-test listbox-func 2)
                  [(let ((L+ (listbox-func +))
                         (Lsquare (listbox-func (lambda (x) (* x x)))))
                     (L+ '(1) (L+ '(2) (Lsquare '(3))))) '(12)  1] ; (run-test listbox-func 3)
                 )
    
))

(implicit-run test) ; run tests as soon as this file is loaded
