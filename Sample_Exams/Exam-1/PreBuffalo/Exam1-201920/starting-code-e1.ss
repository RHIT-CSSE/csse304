; This code should be part of your solution, since the 
; test-cases depend on it.

(define path-to
  (lambda (slist sym)
    (let pathto ([slist slist] [path-so-far '()])
      (cond [(null? slist) #f]
	    [(eq? (car slist) sym)
	     (reverse (cons 'car path-so-far))]
            [(symbol? (car slist))
	     (pathto (cdr slist) (cons 'cdr path-so-far))]
	    [else
	     (or (pathto (car slist) 
                         (cons 'car path-so-far))
		 (pathto (cdr slist) 
                         (cons 'cdr path-so-far)))]))))

; Put yout Problem 1 solution here




; Put yout Problem 2 solution here




; Put yout Problem 3 solution here



; Put yout Problem 4 solution here




; Put yout Problem 5 solution here




