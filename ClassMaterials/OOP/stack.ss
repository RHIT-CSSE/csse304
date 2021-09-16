(define make-stack  ; this file has an intentional error that 
 (lambda ()         ; we will correct in class.
   (lambda (msg  . args ) 
     (let ([stk '()])
       (case msg
         [(empty?) (null? stk)]
         [(push)   (set! stk (cons (car args) stk))]
         [(pop)    (let ([top (car stk)])
                      (set! stk (cdr stk))
                      top)]
         [else (errorf 'stack "illegal message to stack object: ~a" msg)])))))
