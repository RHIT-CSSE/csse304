#lang racket

; To use these tests:
; Click "Run" in the upper right
; (r)

; If you find errors in your code, fix them, save your file, click the "Run" button again, and type (r)
; You can run a specific group of tests using (run-tests group-name)

(require "../testcode-base.rkt")
(require "A02.rkt")
(provide get-weights get-names individual-test test)

(define eval-string
  (lambda (str)
    (unless (string? str) (error "you can only pass strings to eval string"))
    (let ((outp (open-output-string)))
      (parameterize ([current-output-port outp])
        (printf "~s" (eval (read (open-input-string str)) (make-base-namespace))))
      (get-output-string outp))))

(define is-quine-string?
 (lambda (str)
   (let ((result (eval-string str)))
     (if (equal? result str)
         #t
         (begin
           (printf "NOT QUINE~nIn : ~s~nOut: ~s" str result)
           #f)))))


(define set-equals?  ; are these list-of-symbols equal when
  (lambda (s1 s2)    ; treated as sets?
    (if (or (not (list? s1)) (not (list? s2)))
        #f
        (not (not (and (is-a-subset? s1 s2) (is-a-subset? s2 s1)))))))

(define test (make-test ; (r)

  (sum-of-squares equal? ; (run-test sum-of-squares)
    [(sum-of-squares '(1 3 5 7)) 84 3] ; (run-test sum-of-squares 1)
    [(sum-of-squares '()) 0 2] ; (run-test sum-of-squares 2)
  )

  (range equal? ; (run-test range)
    [(range 0 0) '() 2] ; (run-test range 1)
    [(range 0 5) '(0 1 2 3 4) 1] ; (run-test range 2)
    [(range 5 9) '(5 6 7 8) 1] ; (run-test range 3)
    [(range 25 30) '(25 26 27 28 29) 1] ; (run-test range 4)
    [(range 31 32) '(31) 1] ; (run-test range 5)
    [(range 7 4) '() 2] ; (run-test range 6)
  )

  (my-set? equal? ; (run-test my-set?)
    [all-or-nothing 1 ; (run-test my-set? 1)
      ((my-set? '()) #t)
      ((my-set? '(1 1)) #f)]
    [all-or-nothing 1 ; (run-test my-set? 2)
      ((my-set? '(1 2 3)) #t)
      ((my-set? '(1 2 1)) #f)]
    [all-or-nothing 1 ; (run-test my-set? 3)
      ((my-set? '(1 (2 3) (3 2) 5)) #t)
      ((my-set? '(1 3 1 2)) #f)]
    [all-or-nothing 1 ; (run-test my-set? 4)
      ((my-set? '(1 (2 3) (3 2) 5 (3 2))) #f)
      ((my-set? '()) #t)]
    [(my-set? '(r o s e - h u l m a n)) #t 1] ; (run-test my-set? 5)
    [(my-set? '(c o m p u t e r s c i e n c e)) #f 1] ; (run-test my-set? 6)
    [(my-set? '((i) (a m) (a) (s e t))) #t 2] ; (run-test my-set? 7)
    [(my-set? '((i) (a m) (n o t) (a) (s e t) (a m) (i))) #f 2] ; (run-test my-set? 8)
  )

  (union set-equals? ; (run-test union)
    [(union '(a b d e f h j) '(f c e g a)) '(a b c d e f g h j) 2] ; (run-test union 1)
    [(union '(a b c) '(d e)) '(a b c d e) 2] ; (run-test union 2)
    [(union '(a b c) '()) '(a b c) 1] ; (run-test union 3)
    [(union '() '()) '() 1] ; (run-test union 4)
  )

  (more-positives equal? ; (run-test more-positives)
    [(more-positives? '(1 2 -3)) #t 1] ; (run-test more-positives 1)
    [(more-positives? '(-1 -2 300)) #f 1] ; (run-test more-positives 2)
    [(more-positives? '(1 2 3 -3 -4 -5 6)) #t 1] ; (run-test more-positives 3)
    [(more-positives? '(1 2 3 -3 -4 -5)) #f 2] ; (run-test more-positives 4)
    [(more-positives? '()) #f 1] ; (run-test more-positives 5)    
  )

  (add-quotes equal?
              [(add-quotes (list 1 2 3) 0) '(1 2 3) 1]
              [(add-quotes (list 1 2 3) 1) ''(1 2 3) 1]
              [(add-quotes (list 1 2 3) 2) '''(1 2 3) 1]
              [(add-quotes 'foo 2) '''foo 1]
              [(add-quotes ''foo 2) ''''foo 1]
    
  )

  (quine equal?
         [(let ((result (get-304-quine)))
            (cond [(not (is-quine-string? result)) 'not-quine]
                  [(equal? result "304") 'cop-out] ; you're technically correct which is the best kind of correct
                                                   ; but you'll need to come up with a non-trival quine to get credit
                  [(not (string-contains? result "304")) 'no-304]
                  [else 'great])) 'great 1])
                        
  
))

(define is-a-subset?
  (lambda (s1 s2)
    (andmap (lambda (x) (member x s2))
      s1)))


(implicit-run test) ; run tests as soon as this file is loaded
