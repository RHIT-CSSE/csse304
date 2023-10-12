#lang racket

(provide make-test run-all r run-test individual-test get-weights get-names implicit-run)

;;--------  Procedures used by the testing mechanism   ------------------

(define-syntax make-test
  (syntax-rules ()
    ([_ (name equivalent? testcase ...) ...]
     [list
      (list (syntax->datum #'name) ...)
      (list (let ([equiv-proc equivalent?]) (list (make-testcase testcase equiv-proc) ...)) ...)])))

(define-syntax make-testcase
  (syntax-rules (all-or-nothing)
    ([_ (all-or-nothing weight testcase ...) equivalent?]
     [cons (let ([equiv-proc equivalent?]) (list (make-all-or-nothing-testcase testcase equiv-proc) ...)) weight])
    ([_ (body expected weight) equivalent?]
     [make-testcase (body equivalent? expected weight) equivalent?])
    ([_ (body equivalent? expected weight) overridden]
     [list (lambda () body) equivalent? expected weight (syntax->datum #'body)])))

(define-syntax make-all-or-nothing-testcase
  (syntax-rules ()
    ([_ (body expected) equivalent?]
     [make-testcase (body expected 1) equivalent?])
    ([_ (body expected equivalent?) overridden]
     [make-testcase (body expected equivalent? 1) overridden])))

(define-syntax run-test
  (syntax-rules ()
    ([_ test-name]
     [let* ([test-symbol (syntax->datum #'test-name)][suite-index (index-of (car test) test-symbol)])
       (if suite-index
           (begin (run-suite test-symbol suite-index test) (void))
           (printf "Test not found: ~a\n" test-symbol))])
    ([_ test-name test-num]
     (if [< test-num 1]
         (printf "Test number ~a too small. Start with 1." test-num)
         [let* ([test-symbol (syntax->datum #'test-name)] [suite-index (index-of (car test) test-symbol)])
           (if suite-index
               (if [<= test-num (length (list-ref (second test) suite-index))]
                   (let ([result (individual-test suite-index (sub1 test-num) test)])
                     (let ([correct (not (zero? (first result)))] [code (second result)] [yours (third result)] [expected (fourth result)])
                       (when correct
                         (printf "Correct!\n"))
                       (printf "Code: ~a\nYours: ~a\nExpected: ~a\n" code yours expected)))
                   (printf "Test number ~a too large for suite ~a\n" test-num test-symbol))
               (printf "Test not found: ~a\n" test-symbol))]))))

(define run-suite
  (lambda (name suite-index test)
    (printf "~a: " name)
    (let ([suite-len (length (list-ref (second test) suite-index))] [max-score (suite-weight suite-index test)])
      (let loop ([test-index 0] [passed #t] [nyi #f] [score 0])
        (if [< test-index suite-len]
            (let ([testcase-result (individual-test suite-index test-index test)])
              (let ([test-score (car testcase-result)] [code (cadr testcase-result)] [student-answer (caddr testcase-result)] [expected (car (cdddr testcase-result))])
                (if [zero? test-score]
                    (if [eq? 'nyi student-answer]
                        (begin
                          (printf "Not yet implemented\n")
                          (printf "~a score: 0/~a\n" name max-score)
                          (cons 0 max-score))
                        (begin
                          (when passed
                            (printf "\n~a" suite-separator))
                          (printf "Test case: ~a\nYours: ~a\nExpected: ~a\n~a" code student-answer expected suite-separator)
                          (loop (add1 test-index) #f nyi score)))
                    (loop (add1 test-index) passed nyi (+ score test-score)))))
            (begin (if passed
                       (printf "All correct ~a/~a\n" score max-score)
                       (when [not nyi]
                         (printf "~a score: ~a/~a\n" name score max-score)))
                   (cons score max-score)))))))

(define suite-weight
  (lambda (index test)
    (apply + (list-ref (get-weights test) index))))
    
(define-syntax run-all
  (syntax-rules ()
    ([_]
     [implicit-run test])))

(define implicit-run
  (lambda (my-test)
    [let ([test-length (length (first my-test))])
      (let loop ([index 0] [score 0] [max-score 0])
        (if [< index test-length]
            (let ([suite-name (list-ref (first my-test) index)])
              (let ([suite-scores (run-suite suite-name index my-test)])
                (let ([suite-score (car suite-scores)] [suite-max-score (cdr suite-scores)])
                  (loop (add1 index) (+ suite-score score) (+ max-score suite-max-score)))))
            (printf "~aTotal score: ~a/~a" suite-separator score max-score)))]))

(define-syntax r
  (syntax-rules ()
    ([_]
     [run-all])))

(define suite-separator "----------\n")

(define exn:nyi?
  (lambda (e)
    [and (exn? e) (equal? "nyi" (exn-message e))]))

(define individual-test
  (lambda (suite-index test-index test)
    [let ([suite-name (list-ref (first test) suite-index)] [suite (list-ref (second test) suite-index)])
      (let ([testcase (list-ref suite test-index)])
        (if [list? testcase]
            (with-handlers
                ([exn:nyi? (lambda (e) (list 0 (fifth testcase) 'nyi (third testcase)))])
              (run-individual-testcase testcase))
            (with-handlers
                ([exn:nyi? (lambda (e) (list 0 (fifth (caar testcase)) 'nyi (third (caar testcase))))])
              (run-all-or-nothing-testcases (car testcase) (cdr testcase)))))]))

(define run-individual-testcase
  (lambda (testcase)
    (let ([student-answer ((car testcase))] [equivalent? (cadr testcase)] [expected (caddr testcase)] [test-weight (cadddr testcase)] [code (car (cddddr testcase))])
      (let ([score (if [equivalent? student-answer expected] test-weight 0)])
        (list score code student-answer expected)))))

(define run-all-or-nothing-testcases
  (lambda (testcases weight)
    (if [null? testcases]
        (list weight '() '() '())
        (let ([my-result (run-individual-testcase (car testcases))])
          (let ([my-score (car my-result)] [my-code (cadr my-result)] [my-student-answer (caddr my-result)] [my-expected (car (cdddr my-result))])
            (if [zero? my-score]
                my-result
                (let ([other-result (run-all-or-nothing-testcases (cdr testcases) weight)])
                  (let ([score (car other-result)] [code (cadr other-result)] [student-answer (caddr other-result)] [expected (car (cdddr other-result))])
                    (if [zero? score]
                        other-result
                        (list weight (cons my-code code) (cons my-student-answer student-answer) (cons my-expected expected)))))))))))

(define get-weights
  (lambda (test)
    (let loop ([suites-ptr (second test)])
      (if [null? suites-ptr]
          (list)
          (let ([suite (car suites-ptr)] [other (cdr suites-ptr)])
            (cons
             (let inner-loop ([tests-ptr suite])
               (if [null? tests-ptr]
                   (list)
                   (let ([test (car tests-ptr)] [other-tests (cdr tests-ptr)])
                     (if [list? test]
                         (cons (cadddr test) (inner-loop other-tests))
                         (cons (cdr test) (inner-loop other-tests))))))
             (loop other)))))))

(define get-names
  (lambda (test)
    (first test)))
