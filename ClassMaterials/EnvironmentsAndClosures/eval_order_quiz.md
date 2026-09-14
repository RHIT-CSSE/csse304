Here is a concise set of rules for determining evaluation order in Racket/Scheme:

1. Applicative Order (Inside-Out): Arguments are evaluated before the function that receives them. For (F (G x)), evaluate G before F.

2. Left to right application order: In Racket (not standard Scheme), subexpressions in a function call ((A 1) (B 2) (C 3)) are evaluated left to right. So A B C.

3.  Operators Are Expressions: The function slot itself is evaluated just like arguments. In ((if ... A B) x), the if expression evaluates first to determine which function to apply to x.

4.  Special Form — if: Evaluates the test expression first. Depending on the boolean result, it evaluates only the chosen branch (the "then" or "else" clause). The unchosen branch is completely ignored.

5.  Special Form — lambda: Executing a lambda expression returns a procedure object. The function body is never evaluated until the resulting lambda procedure is explicitly invoked.

6.  Special Form — define: Binding a definition (define foo ???) evaluates the initialization expression (???) with its normal rules (e.g. lambda)

### Question 1
```
(A (B 5))
```

### Question 2

```(A (B 3) (C 4))```

### Question 3

(Assume (A 1) evaluates to #t)


```
(if (A 1)
    (B 2)
    (C 3))
```
### Question 4


```
(define foo (lambda (x)
  (A (B x))))
```

### Question 5

```
(define foo (lambda (x)
  (A (B x))))

(C (foo 3))
```

### Question 6

```
(A (lambda (x) (B x)) (C 10))
```

### Question 7

(Assume (A 10) evaluates to a procedure)

```
(define f (A 10))
(f (B 20))
```

### Question 8

(Assume (A #t) evaluates to #t)

```
((if (A #t) B C) (D 5))
```

### Question 9

(Assume (B 1) evaluates to #f)

```
(A (if (B 1)
       (C (D 2))
       (D (C 2))))
```