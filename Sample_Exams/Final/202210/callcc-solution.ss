;; So we're going to use continutaions to build a very simple
;; exception system in scheme.  Here's the the basic idea which
;; is very similar to Java/C++.

;;    (try (lambda () (+ 1 3))
;;         (lambda (error) (display "an error")))))

;; Try is a function that takes 2 lambdas as a parameter.
;;
;; The first is basically the try-code you want to run.  The second is
;; basically the code you want to run on error (i.e. the catch block).
;;
;; Try executes the try-code.  If nothing bad happens, it returns the
;; result of the try-code.  In this case, the second lambda is not
;; used at all.
;;
;; If on the other hand some error is detected in the try lambda, the
;; code should call the special function error-abort.  error-abort
;; should only be called from within the try function (and you don't
;; need to worry about what ought to happen if the user violates that
;; rule).  error-abort takes one parameter which can be anything
;; (could be an error code or error string).
;;
;; When error abort is called, the try code immediately stops running
;; and the catch block lambda is run.  The catch lambda should take
;; one parameter - this parameter is whatever was passed to
;; error-abort.  The catch lambda can contain any code, but critically
;; when it finishes it's return result is the return of the entire try
;; function.  Any code that would have been executed afterwards in the
;; try-code never executes.  So for example:

;;(try (lambda ()
;;       (display "a")
;;       (display "b")
;;       (error-abort "???")
;;       (display "c")
;;       0
;;       )
;;     (lambda (error) (display error) 99))

;; This code prints ab??? and returns 99.  The fact that c should not be printed is why you'll
;; need continuations.  A few things to make your life easier:
;;
;; 1.  You can use global (i.e. defined) variables and don't need to
;; worry that your might clobber some definition the user might want.
;; You can also use set! as much as you desire.

;; 2.  You do not need to worry about nested try blocks.  This
;; simplifies things even though it's not realistic - but the basic
;; idea sound we'd just have to be more careful if we wanted nesting
;; to be possible.

;; One thing that makes you life slightly harder:
;;
;; It should not be possible that returning some special value from
;; the non-error case of the try, the error code might be incorrectly
;; executed.  E.g. in certian implementations it might be possible
;; that this would print error!:

;; (try (lambda () (list 'error 44)) (lambda (error) (display "error!")))

;; because the pair ('error value) is what the system uses to flag an
;; error occuring.  Your system should be built in a way that no such
;; special case exists (BUT if you can think of no solution to this
;; problem, I prefer a mostly working solution that has this bug to
;; nothing).  Note that this potential bug is not tested for by the
;; test cases, because there can be no exhaustive list of special
;; values that might cause a problem.

;; Note that you are required to implement this feature from scratch
;; using call/cc (i.e. not rely on some library like eopl::error or
;; similar).

(define error-abort
  (lambda (error-val)
    'not-yet-implemented))

(define try
  (lambda (code-to-run exception-code)
    'not-yet-implemented))

(define my-cont)

(define error-abort
  (lambda (error-val)
    (my-cont (cons 'error error-val ))))

(define try
  (lambda (code-to-run exception-code)
    (let ([result (call/cc (lambda (k)
                             (set! my-cont k)
                             (box (code-to-run))))])
      (if (box? result)
          (unbox result)
          (exception-code (cdr result))))))
