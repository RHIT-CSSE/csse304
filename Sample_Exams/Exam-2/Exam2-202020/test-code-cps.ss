; Test code for CPS problem

(flatten-cps '() (list-k)) ; (()) 
(flatten-cps '(a) (init-k)) ; (a)
(flatten-cps '(a (b)) (init-k)) ; (a b)
(flatten-cps '((a) b) (init-k)) ; (a b)
(flatten-cps '((a) ()  b) (list-k)) ; ((a b))
(flatten-cps '(() (((a b (c)) () (d) e) () f)) (init-k))
   ; (a b c d e f)
