#lang racket

;; activity 1

;; continuation loop printing 1 - 5

(let ((counter 1)
      (my-k #f))
  ;; call/cc
  (call/cc (lambda (k) (set! my-k k)))
  (display counter)
  (set! counter (add1 counter))
  (if (> counter 5) (void) (my-k 77)))
  


;; activity 2

;; fix this using a super-return

(define (list-index item L)
  (call/cc (lambda (k)
             (list-index-helper item L k)))
  )

(define (list-index-helper item L super-return)
  (cond 
    [(null? L) (super-return -1)]
    [(eq? (car L) item) 0]
    [else (+ 1 (list-index-helper item 
                           (cdr L) super-return))]))




(define throw #f)

(define try
  (lambda (code_to_run on_error)
    (call/cc (lambda (k)
               (set! throw (lambda (error)
                             (k (on_error error))))
               (code_to_run)))))
                             

(try (lambda () 4) (lambda (code) 'error))

(try (lambda ()
       (throw 'errorcode)
       (display "I should never run")
       ) (lambda (code) 'error))
    