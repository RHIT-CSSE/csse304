#lang racket
(provide remove-double)

(define (remove-double lc-exp)
  (cond [(symbol? lc-exp) lc-exp]
        [(eq? (car lc-exp) 'lambda)
         (list 'lambda (cadr lc-exp) (remove-double (caddr lc-exp)))]
        [(eq? 2 (length lc-exp))
         (list (remove-double (car lc-exp)) (remove-double (cadr lc-exp)))]
        [else
         (list (list (remove-double (car lc-exp))
                     (remove-double (cadr lc-exp)))
               (remove-double (caddr lc-exp)))]))
        

