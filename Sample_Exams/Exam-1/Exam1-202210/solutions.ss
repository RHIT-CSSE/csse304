
(define (set-subtract set subtractme)
  (filter (lambda (item) (not (member item subtractme))) set))

(define (sort-by-length list)
  (sort (lambda (x y)
          (< (length x) (length y))) list))

(define (sublist? big little)
  (cond [(< (length big) (length little)) #f]
        [(let head-matches ((big big) (little little))
           (cond [(null? little) #t]
                 [(null? big) #f]
                 [(equal? (car little) (car big)) (head-matches (cdr big) (cdr little))]
                 [else #f])) #t]
        [else (sublist? (cdr big) little)]))
              
(define (add-unused curried-func num)
  (if (zero? num)
      curried-func
      (lambda (unused) (add-unused curried-func (sub1 num)))))

(define (remove1 symbol list)
  (cond [(null? list) #f]
        [(eq? (car list) symbol) (cdr list)]
        [else
         (let ([recurse (remove1 symbol (cdr list))])
           (if recurse
               (cons (car list) recurse)
               #f))]))
(define (count symbol list)
  (cond [(null? list) 0]
        [(eq? (car list) symbol) (add1 (count symbol (cdr list)))]
        [else (count symbol (cdr list))]))
         

(define make-bag
  (lambda ()
    (let ([contents '()])
      (lambda (command symbol)
        (case command
          [(add) (set! contents (cons symbol contents))]
          [(remove)
           (if (not (remove1 symbol contents))
               (display "error")
               (set! contents (remove1 symbol contents)))]
          [(count) (count symbol contents )]
          [(dump) contents])))))

(define (add-unused2 curried-func num)
  (if (zero? num)
      curried-func
      (lambda (used)
        (lambda (unused)
          ((add-unused2 curried-func (sub1 num)) used)))))



;; ((1 2 (3)) 4 5) => remove depth 2 => (1 2 (3) 4 5)
;; the thing to note is that depth 1 is actually the list
;; that is modified here

(define (remove-depth depth slist)
  (cond
   [(null? slist) '()]
   [(symbol? (car slist)) (cons (car slist) (remove-depth depth (cdr slist)))]
   [else (if (= depth 2)
             (append (car slist) (remove-depth depth (cdr slist)))
             (cons (remove-depth (sub1 depth) (car slist)) (remove-depth depth (cdr slist))))]))

(define swap-two-params
  (lambda (cur-fun)
    (lambda (a)
      (lambda (b)
        ((cur-fun b) a)))))

(define make-thingy
  (let ((a 'apple))
    (lambda ()
      (let ((b 'banana))
        (lambda (a2 b2 c2)
          (let ((c 'cherry))
            (display (list a b c))
            (set! a a2)
            (set! b b2)
            (set! c c2)))))))

(let ([thingy1 (make-thingy)] [thingy2 (make-thingy)])
  (thingy1 'atlanta 'boston 'chicago)
  (thingy2 'ant 'bear 'cat)
  (thingy1 'aaa 'bbb 'ccc))
      

  
