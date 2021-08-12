(define interval-contains?
    (lambda (interval value)
        (let ((lowb (car interval)) (highb (cadr interval)))
            (or (and (equal? lowb highb) (equal? lowb value)) (and (>= value lowb) (< value highb)))
        )
    ))