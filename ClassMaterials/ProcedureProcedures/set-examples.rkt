#lang racket

(define myvar 3)

(set! myvar 4)

(display myvar)
(newline)

(let ((myvar 5))
    (display myvar)
    (newline)
    (set! myvar 6)
    (display myvar)
    (newline))

(display myvar)
(newline)

;; (delete this to display list examples)

(define mylist (mcons 1 (mcons 2 (mcons 3 '()))))
(define mylist2 (mcons 4 mylist))
(set-mcar! mylist 99)
(display mylist)
(display mylist2)
(newline)

(set-mcdr! mylist 100)
(display mylist)
(display mylist2)
(newline)