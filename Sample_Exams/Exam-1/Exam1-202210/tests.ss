(define (test-set-subtract)
  (let ([correct '((c a) (c) () () (a b c) (a c f g h))]
        [answers 
         (list (set-subtract '(a b c) '(b))
               (set-subtract '(a b c) '(a b d e))
               (set-subtract '(a b c) '(c a b))
               (set-subtract '() '(c a b))
               (set-subtract '(a b c) '())
               (set-subtract '(a b c e f g h i) '(e i b)))])
               
    (display-results correct answers set-equals?)))

(define (test-sublist?)
  (let ([correct '(#t #t #t #f #f #t #f #t #t)]
        [answers 
         (list (sublist? '(1 2 3) '(1))
               (sublist? '(1 2 3) '(1 2))
               (sublist? '(1 2 3) '(1 2 3))
               (sublist? '(1 2 3) '(1 4))
               (sublist? '(1 2 3) '(2 1))
               (sublist? '(1 1 2 3) '(1 2))
               (sublist? '(2 2 1 2 1 2 1 2 1 2) '(1 2 2))
               (sublist? '(1 2) '())
               (sublist? '(1 1 2 3 4) '(1 2 3 4)))])
               
    (display-results correct answers equal?)))

(define curried-subtract
  (lambda (a)
    (lambda (b)
      (- a b))))

(define curried-cons
  (lambda (a)
    (lambda (b)
      (cons a b))))

(define (test-swap-two-params)
  (let ([correct '(-2 50 (100 . 50))]
        [answers 
         (list (((swap-two-params curried-subtract) 5) 3)
               (((swap-two-params curried-subtract) 50) 100)
               (((swap-two-params curried-cons) 50) 100)) ])
    (display-results correct answers equal?)))

(define (test-remove-depth)
  (let ([correct '((a b c d e)
                   (a (b) c d ((e)))
                   (a (b c) (d (e)))
                   (a ((b) c) (d (e)))
                   (a ((b) c) (d ((e))))
                   )]
        [answers 
         (list (remove-depth 2 '(a (b c) (d e)))
               (remove-depth 2 '(a ((b) c) (d ((e)))))
               (remove-depth 3 '(a ((b) c) (d ((e)))))
               (remove-depth 4 '(a ((b) c) (d ((e)))))
               (remove-depth 5 '(a ((b) c) (d ((e)))))
               )])

    (display-results correct answers equal?)))


(define (repeatedly-call-proc proc how-many-times)
  (if (zero? how-many-times)
      proc
      (repeatedly-call-proc (proc 'trash-parameter) (sub1 how-many-times))))

(define curried-add
  (lambda (a)
    (lambda (b)
      (+ a b))))


(define (test-add-unused)
  (let ([correct '(21 31 42 71 999)]
        [answers 
         (list (((add-unused add1 1) 10) 20)
               ((((add-unused add1 2) 10) 20) 30)
               (((((add-unused add1 3) 10) 20) 30) 41)
               (((((add-unused curried-add 2) 10) 20) 30) 41)
               ((repeatedly-call-proc (add-unused sub1 100) 100) 1000)
               )])

    (display-results correct answers equal?)))

(define (test-bag)
  (let ([b1 (make-bag)] [b2 (make-bag)])
    (b1 'add 'x)
    (b1 'add 'y)
    (b1 'add 'x)
    (b2 'add 'x)
    (b2 'add 'x)
    (b2 'add 'y)
    (b2 'add 'y)
    (b2 'add 'y)
    (b2 'add 'x)
    (let ([correct '(2 1 0 3 3)]
          [answers 
           (list (b1 'count 'x)
                 (b1 'count 'y)
                 (b1 'count 'z)
                 (b2 'count 'x)
                 (b2 'count 'y)
                 )])

      (display-results correct answers equal?))))


;;--------  Procedures used by the testing mechanism   ------------------

(define display-results
  (lambda (correct results test-procedure?)
     (display ": ")
     (pretty-print 
      (if (andmap test-procedure? correct results)
          'All-correct
          `(correct: ,correct yours: ,results)))))
(define set-equals?  ; are these list-of-symbols equal when
  (lambda (s1 s2)    ; treated as sets?
    (if (or (not (list? s1)) (not (list? s2)))
        #f
        (not (not (and (is-a-subset? s1 s2) (is-a-subset? s2 s1)))))))

(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))


;; You can run the tests individually, or run them all
;; by loading this file (and your solution) and typing (r)

(define (run-all)
  (display 'test-set-subtract) 
  (test-set-subtract)
  (display 'test-sublist?) 
  (test-sublist?)
  (display 'test-remove-depth) 
  (test-remove-depth)
  (display 'test-bag)
  (test-bag)
  (display 'test-swap-two-params)
  (test-swap-two-params)
  (display 'test-add-unused)
  (test-add-unused)
  )

(define r run-all)
