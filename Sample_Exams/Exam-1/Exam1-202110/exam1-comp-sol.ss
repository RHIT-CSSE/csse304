; You were not required to use map, 
; but I present some solutions that use it, 
; so you will have additional map examples.

(define alternating-reverse
  (lambda (lol)
    (alt-rev lol #t)))

(define alt-rev
  (lambda (lol rev?)
    (if (null? lol)
	'()
	(cons (if rev?
		  (reverse (car lol))
		  (car lol))
	      (alt-rev (cdr lol) (not rev?))))))
		  
(define member-n?
  (lambda (a n ls)
    (cond
      ((zero? n) #t)
      ((null? ls) #f)
      ((eq? (car ls) a) (member-n? a (sub1 n) (cdr ls)))
      (else (member-n? a n (cdr ls))))))

(define (opposites-attract ls) 
  (map list ls (reverse ls)))

(define (symmetric? rel)
  (andmap (lambda (x)
	          (not (not (member (list (cadr x) (car x)) rel))))
	   rel))
		
(define (lower-triangular? mat)
  (let ([len (length mat)])
    (let row-loop ([i 0])
      (if (= i len) 
	        #t
	        (let col-loop ([j (+ i 1)])
	          (if (= j len)
		            (row-loop (+ i 1))
		            (and (zero? (matrix-ref mat i j))
		                        (col-loop (+ j 1)))))))))

(define matrix-ref  ; helper from the homework
  (lambda (m row col)
    (list-ref (list-ref m row) col)))

; A different version of opposites-attract without reverse, which is O(n^2).  
; Not sure how to do an O(n) solution without reverse.
(define oa  ; short for opposites-attract.
  (lambda (ls)
    (let ([len (- (length ls) 1)])
      (let helper ([sub ls] [i len])
	(if (null? sub)
	    '()
	    (cons (list (car sub) (list-ref ls i))
		  (helper (cdr sub) (- i 1))))))))
	  

(define make-BST
  (lambda ()
    (let ([tree '()])
      (lambda (method . args)
	(case method
	  [(empty?) (null? tree)]
	  [(insert) (set! tree (BST-insert (car args) tree))]
	  [(remove) (set! tree (BST-remove (car args) tree))]
          [(preorder) (BST-preorder tree)]
          [(inorder) (BST-inorder tree)]
	  [(height) (BST-height tree)]
	  [(contains?) (BST-contains? tree (car args))]
	  [(display) (list (BST-preorder tree) (BST-inorder tree) tree)]
	  [else "illegal method call"])))))

;--------- BST procedures fromm HW7, some slightly modified  -------------

(define BST-node list)

(define (BST-leafnode n) ; make a new leaf node
  (BST-node n (empty-BST) (empty-BST)))


; Accessors for part of a node
(define BST-element car)
(define BST-left cadr)
(define BST-right caddr)

; empty tree functions
(define (empty-BST) '())   ; make one
(define empty-BST? null?)  ; test one


(define (BST-insert num bst)
  (cond [(empty-BST? bst) (BST-leafnode num)]
	[(not (integer? num)) 
	 (error 'BST-insert 
		"attempt to insert non-integer into BST")]
	[(= num (BST-element bst)) bst]
	[(< num (BST-element bst))
	 (BST-node (BST-element bst) 
		   (BST-insert num 
			       (BST-left bst)) 
		   (BST-right bst))]
	[else 	 
	 (BST-node (BST-element bst) 
		   (BST-left bst) 
		   (BST-insert num 
			       (BST-right bst)))]))



(define (BST-preorder bst)
  (if (empty-BST? bst)
      '()
      (append (list (BST-element bst)) 
	      (BST-preorder (BST-left bst))
	      (BST-preorder (BST-right bst)))))

(define (BST-inorder bst)
  (if (empty-BST? bst)
      '()
      (append (BST-inorder (BST-left bst)) 
	      (list (BST-element bst))
	      (BST-inorder (BST-right bst)))))

(define (BST-contains? bst num)
  (cond [(empty-BST? bst) #f]
	[(= (BST-element bst) num) #t]
	[(< (BST-element bst) num) (BST-contains? (BST-right bst) num)]
	[else (BST-contains? (BST-left bst) num)]))

(define (BST-height bst)
  (if (empty-BST? bst)
      -1
      (+ 1 (max (BST-height (BST-left bst))
		(BST-height (BST-right bst))))))

(define BST-remove
  (lambda (val node)
       (cond
	[(null? node) '()]
	[(= (BST-element node) val) (actual-remove node)]
	[(< (BST-element node) val)
	 (list (BST-element node)
	       (BST-left node)
	       (BST-remove val (BST-right node)))]
	[else
	 (list (BST-element node)
	       (BST-remove val (BST-left node))
	       (BST-right node))])))

(define actual-remove
  (lambda (node) ; this node has the element to be removed
    (cond [(null? (BST-left node)) (BST-right node)]
	  [(null? (BST-right node)) (BST-left node)]
	  [else (let ([successor (inorder-successor node)])
		  (list successor
			(BST-left node)
			(BST-remove successor (BST-right node))))])))

(define inorder-successor
  (lambda (node)
    (let leftmost ([node (BST-right node)])
      (if (null? (BST-left node))
	  (BST-element node)
	  (leftmost (BST-left node))))))

		
