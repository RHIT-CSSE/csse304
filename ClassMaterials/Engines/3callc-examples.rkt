#lang racket

; 3 Useful call/cc patterns

;;; THE ESCAPE

(when #t ; these whens just let me supress the output of the later examples till its time
(define some-code
  (lambda (input escape-me)
    (printf "Code just going along~n")
    (printf "...but then ninjas attack!~n")
    (escape-me 'ninja-attack)
    (printf "and everybody gets murdered~n")))

(if (eqv? (call/cc (lambda (k)
                     (printf "Calling a k while within there receiever ~n")
                     (some-code 77 k)
                     (printf "...lets you avoid unpleasent things")))
          'ninja-attack)
    (printf "Safe from ninjas!~n")
    (printf "Ordinary exit~n"))
)
;;; THE GOTO

(when #f
(let ((val 3))
  (let ((goto (call/cc (lambda (k) k))))
        (when (< val 5)
          (printf "If a value (~s) doesn't meet your expectations~n" val)
          (set! val (add1 val))
          (printf "Go back (to paris?) and try again~n")
          (goto goto)) ; why do I pass goto here?
        (printf "Till you succeed (~s)!~n" val)))
)          
;;; THE RESUME
;;; kind of a combination of both
(when #f
(define some-code2
  (lambda (input escape-me)
    (printf "Code just going along~n")
    (printf "...but then ninjas attack!~n")
    (call/cc (lambda (resume-me)
               (escape-me resume-me)))
    (printf "and you defeat them~n")))

(let ((result (call/cc (lambda (k)
                     (printf "Calling a k while within there receiever ~n")
                     (some-code2 77 k)
                     (printf "...lets you avoid unpleasent things~n")))))
              (when (continuation? result)
                (printf "You escape, plan your counterattack!~n")
                (result 'ignored))
      (printf "Ordinary exit~n"))
  )