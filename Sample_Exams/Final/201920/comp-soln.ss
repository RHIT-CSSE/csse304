
(define transitive-closure
  (lambda (rel)
    (if (null? rel)
	rel
	(let ([added (set-of (append rel (t-c rel)
				     (t-c (reverse rel))))])
	  ;(set! count (+ 1 count))
	  (if (equal? (length rel) (length added))
	      rel
	      (transitive-closure added))))))

(define set-of   ; removes duplicates to make a set
  (lambda (s)
    (cond [(null? s) '()]
	  [(member (car s) (cdr s))
	   (set-of (cdr s))]
	  [else (cons (car s)
		      (set-of (cdr s)))])))


(define t-c
  (lambda (rel)
    (let ([first-pair (car rel)])
      (if (null? (cdr rel))
	  '()
	  (let extended ([extended (t-c (cdr rel))])
	    (let inner ([rel-tail (cdr rel)])
	      (if (null? rel-tail)
		  extended
		  (let ([second-extended (inner (cdr rel-tail))]
			[second-pair (car rel-tail)])
		    (if (equal? (cadr first-pair) (car second-pair))
			(cons (list (car first-pair)
				    (cadr second-pair))
			      second-extended)
			second-extended)))))))))



'( ; don't execute when loading
(transitive-closure '())
(transitive-closure '((a a) (a b)))
(transitive-closure '((a a) (a b) (b c)))
(transitive-closure '((a b) (b c) (d a)))
(transitive-closure '((a b) (b c) (d a) (c a)))
(transitive-closure '((a b) (b c) (a c)))       
(transitive-closure '((a b) (b c) (d a) (c a) (e d)))
(transitive-closure '((a b) (c b)))
(transitive-closure '((a a) (a b)))
(transitive-closure '((a a) (a b) (b a)))
(transitive-closure '((a b) (b a)))
)



;-----------  original -----------------------------

(define pascal-triangle
  (lambda (n)
    (cond [(< n 0) '()]
          [(= n 0) '((1))]
          [else (let ([triangle-n-1 (pascal-triangle (- n 1))]) 
                  (cons (new-row triangle-n-1) triangle-n-1))])))

;; create the kth row for a pascal triangle that already has k-1 rows.
(define new-row
  (lambda (triangle-list) ; triangle-list contains rows of triangle up to n-1
     (cons 1 (row-helper (car triangle-list)))))
      
;; Uses the formula that (for all but the first and last numbers of the row)
;; each number is the sum of the two numbers "above" it in the triangle.
(define row-helper
  (lambda (prev-row)
    (if (null? (cdr prev-row)) ;; I could write (if (< (length prev-row) 2),
        '(1)                   ;; but that greatly increases the running time.
        (cons (+ (car prev-row) (cadr prev-row))
              (row-helper (cdr prev-row))))))

; -------------------  CPS  ---- ;

(load "chez-init.ss")

(define-datatype continuation continuation?
  [init-k]
  [car-k]
  [pt-k (kk continuation?)]
  [new-row-k (triangle-n-1 list?)
	     (kk continuation?)]
  [row-helper-k (kk continuation?)]
  [row-helper-rec-k (prev-row list?)
		    (kk continuation?)]
  )

(define apply-k
  (lambda (k v)
    (cases continuation k
	   [init-k () v]
	   [car-k () (car v)]
	   [pt-k (kk)
	     (new-row-cps v
			  (new-row-k v kk))]
	   [new-row-k (triangle-n-1 kk)
		      (apply-k kk (cons v triangle-n-1))]
	   [row-helper-k (kk)
			 (apply-k kk (cons 1 v))]
	   [row-helper-rec-k (prev-row kk)
			     (apply-k kk (cons (+ (car prev-row) (cadr prev-row)) v))]
	   )))


(define pascal-triangle-cps
  (lambda (n k)
    (pt-cps n k)))

(define pt-cps
  (lambda (n k)
    (cond [(< n 0) (apply-k k '())]
	  [(= n 0) (apply-k k '((1)))]
	  [else (pt-cps (- n 1) (pt-k k))])))

(define new-row-cps
  (lambda (triangle-list k) ; triangle-list contains rows of triangle up to n-1
    (row-helper-cps (car triangle-list)
		    (row-helper-k k))))

(define row-helper-cps
  (lambda (prev-row k)
    (if (null? (cdr prev-row)) 
        (apply-k k '(1))
	(row-helper-cps (cdr prev-row)
			(row-helper-rec-k prev-row k)))))

'(pascal-triangle-cps 4 (init-k))
'(pascal-triangle-cps  12 (car-k))

;--------------- imperative -----------


(load "chez-init.ss")

(define-datatype continuation continuation?
  [init-k]
  [car-k]
  [pt-k (kk continuation?)]
  [new-row-k (triangle-n-1 list?)
	     (kk continuation?)]
  [row-helper-k (kk continuation?)]
  [row-helper-rec-k (prev-row list?)
		    (kk continuation?)]
  )

(define n)
(define k)
(define triangle-n-1)
(define triangle-list)
(define prev-row)
(define v)



(define apply-k-imp
  (lambda ()
    (trace-it "apply-k")	  
    (cases continuation k
	   [init-k () v]
	   [car-k () (car v)]
	   [pt-k (kk)
		 (set! triangle-list v)
		 (set! k (new-row-k v kk))
		 (new-row-imp)]
	   [new-row-k (triangle-n-1 kk)
		      (set! v (cons v triangle-n-1))
		      (set! k kk)
		      (apply-k-imp)]
	   [row-helper-k (kk)
			 (set! k kk)
			 (set! v (cons 1 v))
			 (apply-k-imp)]
	   [row-helper-rec-k (prev-row kk)
			     (set! v (cons (+ (car prev-row) (cadr prev-row)) v))
			     (set! k kk)
			     (apply-k-imp)]
	   )))

(define pt-imp
  (lambda ()
    (trace-it "pt        ")	  
    (cond [(< n 0) (set! v '()) (apply-k-imp)]
	  [(= n 0) (set! v '((1)))(apply-k-imp)]
	  [else (set! n (- n 1))
		(set! k (pt-k k))
		(pt-imp)])))

(define new-row-imp
  (lambda () ; triangle-list contains rows of triangle up to n-1
    (trace-it "new-row  ")	  
    (set! prev-row (car triangle-list))
    (set! k (row-helper-k k))
    (row-helper-imp)))

(define row-helper-imp
  (lambda ()
    (trace-it "row-helper")	  
    (if (null? (cdr prev-row))
	(begin
	  (set! v '(1))
          (apply-k-imp))
	(begin
	  (set! k (row-helper-rec-k prev-row k))
	  (set! prev-row (cdr prev-row))
	  (row-helper-imp)))))

(define trace-it
  (lambda (sym)
    (when (top-level-bound? '*tracing*)
      (printf "~a " sym)
      (printf "   n=~s" n)
      (printf "   v=~s" v)
      (printf "  tri-n-1=~s" triangle-n-1)
      (printf "  tri-list=~s" triangle-list)
      (printf "  prev-row=~s~%" prev-row)
      (printf "           k=~s~%" k))))

'(begin
  (set! k (init-k))
  (set! n 5)
  (pt-imp))

'(begin
  (set! k (car-k))
  (set! n 9)
  (pt-imp))



'(define *tracing*)



 	   


