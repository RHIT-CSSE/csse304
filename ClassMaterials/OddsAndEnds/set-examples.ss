
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

(define mylist '(1 2 3))
(define mylist2 (cons 4 mylist))
(set-car! mylist 99)
(display mylist)
(display mylist2)
(newline)

(set-cdr! mylist 100)
(display mylist)
(display mylist2)
(newline)