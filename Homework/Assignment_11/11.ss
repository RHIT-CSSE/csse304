; starting code for the last two problems.  
; The file being loaded here should live in the same folder as this one.

(load "chez-init.ss")

(define-datatype bintree bintree?
  (leaf-node
   (datum number?))
  (interior-node
   (key symbol?)
   (left-tree bintree?)
   (right-tree bintree?)))
   
   