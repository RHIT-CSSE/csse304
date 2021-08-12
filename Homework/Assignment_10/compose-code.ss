(define compose2
  (lambda (f g)
    (lambda (x)
      (f (g x)))))

(define h
  (let ([g (lambda (x) (+ 1 x))]
	[f (lambda (y) (* 2 y))])
    (compose2 g f)))

(h 4)

