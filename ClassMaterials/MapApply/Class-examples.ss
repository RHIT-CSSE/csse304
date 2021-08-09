(define sorted? 
  (lambda (numbers) 
   (or (< (length numbers) 2) ; why is this a bad idea?
     (and (<= (car numbers) (cadr numbers)) 
          (sorted? (cdr numbers))))))
