;-----------------------------------------------
; CONTINUATIONS REPRESENTED BY SCHEME PROCEDURES
;-----------------------------------------------

(define apply-k
  (lambda (k v)
    (k v)))

(define make-k    ; lambda is the "real" continuation 
  (lambda (v) v)) ; constructor here.

(define (remove-depth depth slist)
  (if (null? slist)
      '()
      (let ((recurse (remove-depth depth (cdr slist))))
        (if (symbol? (car slist))
            (cons (car slist) recurse)
            (if (= depth 2)
                (append (car slist) recurse)
                (cons (remove-depth (sub1 depth) (car slist)) recurse))))))

;;only works for 2 parameters but that's all we need here
(define (append-cps  l1 l2 k)
  (if (null? l1)
      (apply-k k l2)
      (append-cps (cdr l1) l2 (make-k (lambda (appended-cdr)
                                        (apply-k k (cons (car l1) appended-cdr)))))))


(define (remove-depth-cps depth slist k)
  (if (null? slist)
      (apply-k k '())
      (remove-depth-cps depth (cdr slist) (make-k (lambda (recurse)
                                                    (if (symbol? (car slist))
                                                                 (apply-k k (cons (car slist) recurse))
                                                                 (if (= depth 2)
                                                                     (append-cps (car slist) recurse k)
                                                                     (remove-depth-cps (sub1 depth) (car slist) (make-k (lambda (recurse-car)
                                                                                                                          (apply-k k (cons recurse-car recurse))))))))))))

(define-syntax swap!
  (syntax-rules ()
    ((_ a b)
     (let ((swapval-a a))
       (set! a b)
       (set! b swapval-a)))))




;; I can't share my whole interpreter, but here's the relevant parts

;; For simpleccase here's my expand-syntax

            [simplecase-exp (test symbols bodies)
                            (expand-exp (if-exp
                                         (app-exp (list (var-exp 'eqv?) (lit-exp (car symbols)) test))
                                         (car bodies)
                                         (if (null? (cdr symbols))
                                             (app-exp (list (var-exp 'void)))
                                             (simplecase-exp test (cdr symbols) (cdr bodies)))))]

;; note that I don't attempt to eval the test expression here in
;; expand syntax.  Instead I just provide a context for it to evaled
;; later when the whole expression is executed by eval-exp.

;; For namespace here's my eval exp

           [make-namespace-exp (vars values)
                               (cons vars (map (lambda (x) (eval-exp x env)) values))]
           [use-namespace-exp (namespace bodies)
                              (let* ((ns (eval-exp namespace env))
                                     (new-env (extend-env (car ns) (cdr ns) env)))
                                (eval-exp (car bodies) new-env))]


;; note that both of these also required changes to the parser and to the expression datatype
