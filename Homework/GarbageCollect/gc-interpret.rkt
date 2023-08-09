#lang racket

(require "garbage-collect.rkt")
(require typed/rackunit)

(provide eval-one gc-before-continue eval-continue)

(define-memstruct number vals: (value))
(define-memstruct pair ptrs: (car cdr))
(define-memstruct prim vals: (value))

(define-memstruct lit-exp ptrs: (value))
(define-memstruct var-exp vals: (depth offset))
(define-memstruct app-exp ptrs: (subexps))
(define-memstruct lam-exp ptrs: (body))
(define-memstruct pause-exp ptrs: (body))

(define-memstruct env ptrs: (values parent))
(define-memstruct closure ptrs: (env body))

(define-memstruct init-k ptrs: () vals: ())
(define-memstruct eval-proc-k ptrs: (k))
(define-memstruct continue-rands-k ptrs: (cdr-exps env k))
(define-memstruct finish-rands-k ptrs: (evaled-car k))

(define-memstruct paused-eval ptrs: (exp env k))

; each primitive function and value gets a number
; that's decided on at expansion time.  That way
; they can be represented in our code symbolically
; even though they are stored in memory as numbers
; starting at 1000
(begin-for-syntax
  (define prims '(null + if cons car cdr null? zero? true false)))

(define-syntax (get-prim stx)
  (let* ((sym (cadr (syntax->datum stx)))
         (mem-result (member sym prims)))
    (unless mem-result (raise-syntax-error #f "unknown prim" stx))
    (datum->syntax stx (+ 1000 (- (length prims) (length mem-result))))))

; this makes the prims list available after expansion too
; which we need to create the global environment
(define-syntax (declare-prims stx)
  (with-syntax ((prim-stx (datum->syntax stx prims))
                (prim-name (datum->syntax stx 'prims)))
    #'(define prim-name (quote prim-stx))))

;(: prims (Listof Symbol))
(declare-prims)

;(: make-prim-runtime (-> Symbol ptr))
(define (make-prim-runtime sym)
  (let* ((mem-result (member sym prims)))
    (unless mem-result (error "unknown prim ~s" sym))
    (put! 'prim (+ 1000 (- (length prims) (length mem-result))))))
        
; but "code" I mean here the unparsed lists that form
; our language
;(define-type Code (U #t #f Symbol Integer (Listof Code)))

;(: list-pos (All (A) (-> A (Listof A) (Option Integer))))
(define list-pos
  (lambda (val lst)
    (let ((member-result (member val lst)))
      (if member-result
          (- (length lst) (length member-result))
          #f))))

; (: lexical-addr (-> Integer Symbol (Listof (Listof Symbol)) (Option ptr)))
(define lexical-addr
  (lambda (depth symbol contexts)
    (if (null? contexts)
        #f
        (let ((search (list-pos symbol (car contexts))))
          (if search
              (put! 'var-exp depth search)
              (lexical-addr (add1 depth) symbol (cdr contexts)))))))

;(: parse (-> (Listof (Listof Symbol)) Code ptr))
;
; this does both parsing and a lexical depth conversion
;
; because we use lexical depth, eval can be free of any dependence on symbols
; at eval time which was my main goal.
;
; but it means we have to use list structures here in parse, or do a lot of work
; I don't want to do
(define parse
  (lambda (varnames code)
    (cond [(symbol? code) (or (lexical-addr 0 code varnames)
                              (put! 'lit-exp (make-prim-runtime code)))]                             
          [(exact-integer? code) (put! 'lit-exp (put! 'number code))]
          [(equal? code (list 'quote '())) (put! 'lit-exp (make-prim-runtime 'null))]
          [(equal? #t code) (put! 'lit-exp (make-prim-runtime 'true))]
          [(equal? #f code) (put! 'lit-exp (make-prim-runtime 'false))]
          [(list? code)
           (when (< (length code) 1) (error 'short-app "param list too short ~s" code))
           (if (symbol? (car code))
               (case (car code)
                 [(pause) (unless (= (length code) 2) (error 'bad-pause "bad pause"))
                          (put! 'pause-exp (parse varnames (second code)))]
                 [(lambda) (unless (= (length code) 3) (error 'bad-lambda "bad lambda"))
                           (let ([param (second code)])
                             (unless (and
                                      (pair? param)
                                      (andmap symbol? param))
                               (error 'bad-param "bad lambda param ~s" (cadr code)))
                             (put! 'lam-exp (parse (cons param varnames) (third code))))]                             
                 [else (put! 'app-exp (parse-app varnames code))])
               (put! 'app-exp (parse-app varnames code)))]
           )))

;(: parse-app (-> (Listof (Listof Symbol)) (Listof Code) ptr))
(define parse-app
  (lambda (varnames code)
    (if (null? code)
        null-ptr
        (put! 'pair
              (parse varnames (car code))
              (parse-app varnames (cdr code))))))

;(: ptr-list-ref (-> ptr Integer ptr))
(define ptr-list-ref
  (lambda (lst index)
    (cond [(null-ptr? lst) (error "ptr list ref out of bounds")]
          [(zero? index) (get-ptr 'pair 'car lst)]
          [else (ptr-list-ref (get-ptr 'pair 'cdr lst)
                              (sub1 index))])))

;(: apply-env (-> ptr Integer Integer ptr))
(define apply-env
  (lambda (env depth offset)
    (if (null-ptr? env)
        (error "bad variable lookup")
        (if (zero? depth)
            (ptr-list-ref (get-ptr 'env 'values env) offset)
            (apply-env (get-ptr 'env 'parent env) (sub1 depth) offset)))))

;(: eval-exp (-> ptr ptr ptr ptr))
(define eval-exp
  (lambda (exp env k)
    (case (info-struct-name (ptr->info exp))
      [(lit-exp) (apply-k k (get-ptr 'lit-exp 'value exp))]
      [(var-exp) (apply-k k (apply-env env
                                       (get-val 'var-exp 'depth exp)
                                       (get-val 'var-exp 'offset exp)))]
      [(pause-exp) (put! 'paused-eval
                         (get-ptr 'pause-exp 'body exp)
                         env
                         k)]                         
      [(lam-exp) (apply-k k (put! 'closure
                                  env
                                  (get-ptr 'lam-exp 'body exp)))]
      [(app-exp) (eval-rands (get-ptr 'app-exp 'subexps exp)
                             env
                             (put! 'eval-proc-k k))]
      [else (error "NYI" (info-struct-name (ptr->info exp)))])))

; actually its not just rands - it evals the operator too
; (: eval-rands (-> ptr ptr ptr ptr))
(define eval-rands
  (lambda (exps env k)
    (if (null-ptr? exps)
        (apply-k k null-ptr)
        (eval-exp (get-ptr 'pair 'car exps)
                  env
                  (put! 'continue-rands-k
                        (get-ptr 'pair 'cdr exps)
                        env
                        k)))))

; (: eval-proc (-> ptr ptr ptr))
(define eval-proc
  (lambda (val-list k)
    (let ((proc (ptr-list-ref val-list 0)))
      (case (info-struct-name (ptr->info proc))
        [(prim)        
         (apply-k k (let ((value (get-val 'prim 'value proc)))
                      (cond
                        [(= value (get-prim +))
                         (put! 'number (+ (get-val 'number 'value (ptr-list-ref val-list 1))
                                          (get-val 'number 'value (ptr-list-ref val-list 2))))]
                        [(= value (get-prim if))
                         (if (and (eqv? 'prim (info-struct-name (ptr->info (ptr-list-ref val-list 1))))
                                  (= (get-prim false) (get-val 'prim 'value (ptr-list-ref val-list 1))))
                             (ptr-list-ref val-list 3)
                             (ptr-list-ref val-list 2))]
                        [(= value (get-prim cons))
                         (put! 'pair (ptr-list-ref val-list 1) (ptr-list-ref val-list 2))]
                        [(= value (get-prim car))
                         (get-ptr 'pair 'car (ptr-list-ref val-list 1))]
                        [(= value (get-prim cdr))
                         (get-ptr 'pair 'cdr (ptr-list-ref val-list 1))]
                        [(= value (get-prim null?))
                         (if (and (eqv? 'prim (info-struct-name (ptr->info (ptr-list-ref val-list 1))))
                                  (= (get-prim null) (get-val 'prim 'value (ptr-list-ref val-list 1))))
                             (put! 'prim (get-prim true)) ; kinda suboptimal to create new ones but eh
                             (put! 'prim (get-prim false)))]
                        [(= value (get-prim zero?))
                         (if (= (get-val 'number 'value (ptr-list-ref val-list 1)) 0)
                             (put! 'prim (get-prim true))
                             (put! 'prim (get-prim false)))]
                        [else (error "bad prim proc" proc)])))]
        [(closure)
                    (let ((new-env (put! 'env (get-ptr 'pair 'cdr val-list) (get-ptr 'closure 'env proc))))
                      (eval-exp (get-ptr 'closure 'body proc) new-env k))]                                         
        [else (error "bad proc" (simple-dump proc))]))))

; (: apply-k (-> ptr ptr ptr))
(define apply-k
  (lambda (k v)
    (case (info-struct-name (ptr->info k))
      [(init-k) v]
      [(eval-proc-k) (eval-proc v (get-ptr 'eval-proc-k 'k k))]
      [(continue-rands-k) (eval-rands (get-ptr 'continue-rands-k 'cdr-exps k)
                                      (get-ptr 'continue-rands-k 'env k)
                                      (put! 'finish-rands-k v (get-ptr 'continue-rands-k 'k k)))]
      [(finish-rands-k) (apply-k (get-ptr 'finish-rands-k 'k k)
                                 (put! 'pair
                                       (get-ptr 'finish-rands-k 'evaled-car k)
                                       v))]
      
      [else (error "unknown continuation" (info-struct-name (ptr->info k)))])))

;(define-type OutputValues (U Boolean Integer Null (Pair OutputValues OutputValues) (List 'paused ptr ptr ptr)))

;(: convert-to-output (-> ptr OutputValues))
(define convert-to-output
  (lambda (output-me)
    (case (info-struct-name (ptr->info output-me))
      [(number) (get-val 'number 'value output-me)]
      [(paused-eval)
       (list 'paused
             (get-ptr 'paused-eval 'exp output-me)
             (get-ptr 'paused-eval 'env output-me)
             (get-ptr 'paused-eval 'k output-me))]
      [(pair) (cons (convert-to-output (get-ptr 'pair 'car output-me))
                    (convert-to-output (get-ptr 'pair 'cdr output-me)))]
      [(prim) (let ((value (get-val 'prim 'value output-me)))
                (cond 
                  [(= value (get-prim true)) #t]
                  [(= value (get-prim false)) #f]
                  [(= value (get-prim null)) '()]
                  [else (error "can't convert prim" (get-val 'prim 'value output-me))]))]
      [else (begin (display (simple-dump output-me)) (error "can't convert" (info-struct-name (ptr->info output-me))))])))

; (: eval-one (-> Code OutputValues))
(define eval-one
  (lambda (code)
    (convert-to-output (eval-exp (parse '() code) null-ptr (put! 'init-k)))))

; (: eval-continue (-> OutputValues OutputValues))
(define eval-continue
  (lambda (pause)
    (unless (and (pair? pause) (eqv? (car pause) 'paused))
      (error "attempt to continue unpaused state ~s") pause)
    (convert-to-output (eval-exp (second pause) (third pause) (fourth pause)))))


; (: gc-before-continue (-> OutputValues (List 'paused ptr ptr ptr)))
(define gc-before-continue
  (lambda (pause)
    (nyi)))



(check-equal? (eval-one 3) 3)
(check-equal? (eval-one #t) #t)
(check-equal? (eval-one #f) #f)
(check-equal? (eval-one ''()) '())
(check-equal? (eval-one '(+ 1 2)) 3)
(check-equal? (eval-one '(+ (+ 1 2) (+ 10 20))) 33)
(check-equal? (eval-one '(cons 1 2)) '(1 . 2))
(check-equal? (eval-one '(car (cons 1 2))) 1)
(check-equal? (eval-one '(cdr (cons 1 2))) 2)
(check-equal? (eval-one '(null? '())) #t)
(check-equal? (eval-one '(null? (cons '() '()))) #f)
(check-equal? (eval-one '(zero? (+ 1 -1))) #t)
(check-equal? (eval-one '(zero? (+ 1 0))) #f)
(check-equal? (eval-one '(if #f 1 2)) 2)
(check-equal? (eval-one '(if #t 1 2)) 1)
(check-equal? (eval-one '((lambda (x) 2) 1)) 2)
(check-equal? (eval-one '((lambda (x y) (cons y x)) 5 6)) '(6 . 5))
(check-equal? (eval-one '(((lambda (a) (lambda (x y) (cons y (cons a (cons x '()))))) 7) 5 6)) '(6 7 5))

;;--------  Used by the testing mechanism   ------------------

(define-syntax nyi
  (syntax-rules ()
    ([_]
     [error "nyi"])))