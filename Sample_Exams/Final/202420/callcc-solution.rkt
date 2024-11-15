#lang racket

(provide wait done do-threads)

;; In this system, we're going to introduce the idea of "threads" but
;; note these are not really processor threads, and definitely should
;; not be implemented with Racket's threading libraries.  These are a
;; toy...a toy that cound expand into so interesting stuff if we
;; wanted, but this is not a parallelism class.

;; You run do threads with some number of procedures as below:
;;
;; (do-threads
;;  (lambda () (display "a") (wait) (display "b") (done))
;;  (lambda () (display "c") (done))
;;  (lambda () (display "y") (wait) (display "z") (wait) (display "z2") (done)))
;;
;; do-threads will run the threads in order.  So it will run the first
;; one to completion, then the second to completion, finishing when
;; all threads are finished.  EXCEPT if a thread calls the procedure
;; wait, the waiting thread will be paused and the next available
;; (i.e. unfinished) thread will start running.  The waiting thread
;; will only be run again once every other available thread has run
;; and either finished or called wait itself.  This is called
;; "round-robin" in the sense that everyone gets a turn, then we start
;; at the beginning again.
;;
;; The above example should print acybzz2.  We start in thread 1 which
;; prints a, then go to thread 2 which prints c and finishes, then
;; goes to thread 3 which prints y.  Then every thread having had a
;; turn we return to thread 1 which prints b and finishes, then goes
;; to thread 3 which does the other printing.
;;
;; If wait is called on a thread and there are no other threads
;; available, wait does nothing.
;;
;; the function done indicates a thread is fully finished and should
;; not be run anymore.  You can assume any thread will always call
;; done (i.e. the passed closures will never simply terminate without
;; calling done).
;;

;; When all threads have called done, do-threads should return.

;; You should implement this solution using call/cc and no other feature.  You may use mutation and global variables.  You do not need to account for the case where a do-threads call calls do-threads.

(define ready
  '())

(define fully-done
  #f)

(define wait
  (lambda ()
    (call/cc (lambda (k)
               (if (null? ready) 'no-waiting
                   (let ((next (car ready)))
                     (set! ready (append (cdr ready) (list k)))
                     (next)))))))

(define done
  (lambda ()
    (call/cc (lambda (k)
               (if (null? ready)
                   (fully-done 'done)
                   (let ((next (car ready)))
                     (set! ready (cdr ready))
                     (next)))))))


(define do-threads
  (lambda threads
    (call/cc (lambda (k)
               (set! fully-done k)
               (set! ready (cdr threads))
               ((car threads))))))

(do-threads
 (lambda () (display "a") (wait) (display "b") (done))
 (lambda () (display "y") (wait) (display "z") (done)))


(do-threads
 (lambda () (display "a") (wait) (display "b") (done))
 (lambda () (display "c") (done))
 (lambda () (display "y") (wait) (display "z") (wait) (display "z2") (done)))
               
