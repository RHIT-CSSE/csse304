(define x (call/cc (call/cc call/cc)))
(+ 3 (x 8))

> (define y (call/cc (call/cc (call/cc call/cc))))
> (y (y (y 8)))
> y
8
> 

> (let ([y (call/cc (call/cc (call/cc call/cc)))]) (y list) (y 4))
(4)
