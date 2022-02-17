;; Below is my solution for sublist? from Exam 1.  To remind you,
;; here's what I said about sublist?:

;; ;; Write a procedure that takes two lists of numbers, which I call big
;; ;; and little.  The function returns true if the little list occurs as
;; ;; a consecutive subsequence within the big list.  Note that unlike an
;; ;; ordinary subset relationship, order matters - the elements in the
;; ;; both lists must be in the the same order, not just have the same
;; ;; values somewhere in the list.
;; ;;
;; ;; Examples:
;; ;; > (sublist? '(1 2 99 100 3 4) '(99 100))
;; ;; #t
;; ;; > (sublist? '(1 2 99 100 3 4) '(100 99))
;; ;; #f
;; ;; > (sublist? '(1 2 99 100 3 4) '())
;; ;; #t


(define (head-matches?-orig big little)
  (cond [(null? little) #t]
        [(null? big) #f]
        [(equal? (car little) (car big)) (head-matches?-orig (cdr big) (cdr little))]
        [else #f]))

(define (sublist?-orig big little)
  (cond [(< (length big) (length little)) #f]
        [(head-matches?-orig big little) #t]
        [else (sublist?-orig (cdr big) little)]))

;; Here's the same code, converted by me to datastructure cps.  Note
;; in this case I decided that length was a substantial procedure, so
;; I have a cps-ized implementation for length (which yes, you will be
;; required to convert to imperative form).

(define-datatype continuation continuation?
  [init-k]
  [length-cps-k (k continuation?)]
  [len-big-k (big list?)
             (little list?)
             (k continuation?)]
  [len-little-k (big list?)
                (little list?)
                (len-big number?)
                (k continuation?)]
  [is-match-k (big list?)
              (little list?)
              (k continuation?)])


(define (sublist?-ds-cps big little k)
  (length-ds-cps big (len-big-k big little k)))


(define (head-matches?-ds-cps big little k)
  (cond [(null? little) (apply-k-ds k #t)]
        [(null? big) (apply-k-ds k #f)]
        [(equal? (car little) (car big)) (head-matches?-ds-cps (cdr big) (cdr little) k)]
        [else (apply-k-ds k #f)]))


(define (length-ds-cps lst k)
  (if (null? lst)
      (apply-k-ds k 0)
      (length-ds-cps (cdr lst) (length-cps-k k))))



;; hint for imperative form!  Be careful about the way that the
;; variables in this function may shadow global variable names if
;; you're not careful.
(define apply-k-ds
  
  (lambda (k v)
    (cases continuation k
	   [init-k () v]
           [length-cps-k (k)
                         (apply-k-ds k (add1 v))]
           [len-big-k (big little k)
                      (length-ds-cps little (len-little-k big little v k))]
           [len-little-k (big little len-big k)
                         (if (< len-big v)
                             (apply-k-ds k #f)
                             (head-matches?-ds-cps big little (is-match-k big little k)))]
           [is-match-k (big little k)
                       (if v
                           (apply-k-ds k #t)
                           (sublist?-ds-cps (cdr big) little k))])))
                           

;; convert sublist?-ds-cps and the functions it calls to imperative
;; form.  Below is a test function which is how your imperative form
;; function will be invoked - it does not need to be converted to
;; imperative form.
;;
;; note you do not need to ellimate the use of cond - its obvious how
;; cond could be replaced with ifs if desired.
(define big)
(define little)
(define k)
;; add additional registers you need

(define lst)


(define (sublist?-impr-tester big-in little-in)
  (set! big big-in)
  (set! little little-in)
  (set! k (init-k))
  ;; you can edit sublist?-ds-cps if you wish, or you can make a new
  ;; copy with a different name and call that here
  (sublist?-ds-cps))
