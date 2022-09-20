(define (matrix-transpose m)
  (apply map list m))
(define symmetric?
  (lambda (matrix)
    (equal? matrix (matrix-transpose matrix))))
(define (sum-of-depths slist) 
  (let sum ([slist slist]
	    [depth 1])
    (cond [(null? slist) 0]
	  [(symbol? (car slist))
	   (+ depth (sum (cdr slist) depth))]
	  [else  ; the car is an s-list
	   (+ (sum (car slist) (+ 1 depth))
	      (sum (cdr slist) depth))])))
(define (notate-depth slist) 
  (let notate ([slist slist]
	       [depth 1])
    (cond [(null? slist) '()]
	  [(symbol? (car slist))
	   (cons (list (car slist) depth)
		 (notate (cdr slist) depth))]
	  [else  ; the car is an s-list
	   (cons (notate (car slist) (+ 1 depth))
		 (notate (cdr slist) depth))])))
(define un-notate
  (lambda (ls)
    (if (null? ls)
	'()
	(let ([un-cdr (un-notate (cdr ls))])
	  (cond [(null? (car ls))
		 (cons '() un-cdr)]
		[(symbol? (caar ls))
		 (cons (caar ls) un-cdr)]
		[else (cons (un-notate (car ls))
			    un-cdr)])))))
(define path-to
	(lambda (slist sym)
	  (let pathto ([slist slist] [path-so-far '()])
	    (cond [(null? slist) #f]
		  [(eq? (car slist) sym)
		   (reverse (cons 'car path-so-far))]
		  [(symbol? (car slist))
		   (pathto (cdr slist) (cons 'cdr path-so-far))]
		  [else
		   (or (pathto (car slist) (cons 'car path-so-far))
		       (pathto (cdr slist) (cons 'cdr path-so-far)))]))))
(define compose
  (case-lambda
    [() (lambda (x) x)]
    [(first . rest)
     (let ([composed-fns 
              (apply compose rest)])
	(lambda (x)
	  (first (composed-fns x))))]))
(define find-by-path
  (lambda (path-list slist)
    ((apply compose (map eval (reverse path-list))) slist)))
(define make-vec-iterator
  (lambda (v)
    (let ([pos 0] [len (vector-length v)])
      (lambda (msg . args)
	(case msg
	  [(next) (if (< pos (- len 1))
		     (set! pos (+ 1 pos))
		     (errorf 'next "position is past end of vector"))]
	  [(prev) (if (positive? pos)
		     (set! pos (- pos 1))
		     (errorf 'next "position is past end of vector"))]
	  [(val) (vector-ref v pos)]
	  [(set-val!) (vector-set! v pos (car args))])))))
