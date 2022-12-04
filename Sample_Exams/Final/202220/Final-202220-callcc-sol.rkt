#lang racket
(provide do-lazy-func rest continue remove-double eval-one-exp ss:sel-sort-d-cps ss:init-k)


;; Using call/cc problem
;; 
;; So for this problem I'd like you to implement what I call a "lazy"
;; function.
;;
;; Here's some example code:
;;
;; ((lambda ()
;;   (display "hello")
;;   (do-lazy-func (lambda ()
;;                 (display 1)
;;                 (rest)
;;                 (display 2)
;;                 (rest)
;;                 (display 3)
;;                 99))
;;   (display "goodbye")))
;;
;; I've enclosed this in a surrounding lambda () (a thunk) because
;; continuations in Racket can act a little inconsistently at the top
;; level but the my version works both with and without that.  Yours needs
;; to work with the lambda surrounded version (and if it does it'll probably
;; work without it too)
;;
;; So lazy functions need to rest.  When they do they call the global
;; rest function.  This causes the do-lazy-func to immediately return.  So the
;; given code prints "hello1goodbye".
;;
;; However, you can continue a resting lazy function with the global function
;; continue.  If you add a (continue) (display 4) after the display goodbye,
;; you should see a hello1goodbye24.  continue resumes the lazy function after the
;; rest, and when the function rests again, the continue returns and 4 is
;; displayed.  Note that I don't use the return values of rest and continue in
;; these cases - it doesn't matter what they return.
;;
;; It should be possible for a lazy function to rest and be continued as many
;; times as needed.  When the lazy function finally returns, the last (continue)
;; should return the value of the overall function.  So this code

;; ((lambda ()
;;   (display "hello")
;;   (do-lazy-func (lambda ()
;;                 (display 1)
;;                 (rest)
;;                 (display 2)
;;                 (rest)
;;                 (display 3)
;;                 99))
;;    (display "goodbye")
;;    (continue)
;;    (display 4)
;;    (display (continue))
;; ))
;;
;; displays hello1goodbye24399
;;
;; You do not need to worry about the case where continue is called too many times.
;;
;; You do not need to worry about rest being called outside of a lazy func.
;;
;; If do-lazy-func is invoked when an already existing lazy func is still in
;; progress, the old func is lost and cannot be continued, the new func should
;; rest/continue as normal.
;;
;; To solve this problem you may use global variables and state modifying functions
;; like set!
;;
;; Implement this problem using call/cc directly.  Do not use features
;; like corountinues or engines to solve it.

(define rest-cont 'none)
(define continue-cont 'none)

(define continue
  (lambda ()
    (call/cc (lambda (cont)
               (set! rest-cont cont)
               (continue-cont 'ignored)))))

(define rest
  (lambda ()
    (call/cc (lambda (cont)
               (set! continue-cont cont)
               (rest-cont 'resting)))))

(define do-lazy-func
  (lambda (func)
    (call/cc (lambda (cont)
               (set! rest-cont cont)
               (let ((result (func)))                 
                 (rest-cont result))))))


 ((lambda ()
   (display "hello")
   (do-lazy-func (lambda ()
                 (display 1)
                 (rest)
                 (display 2)
                 (rest)
                 (display 3)
                 99))
    (display "goodbye")
    (continue)
    (display 4)
    (display (continue))
))