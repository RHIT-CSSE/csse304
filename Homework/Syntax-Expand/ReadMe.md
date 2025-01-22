This is an individual assignment. COntinue working with your interpreter. Add a syntax-expand procedure 
so as to add macros to your interpreter. See <a href="https://www.rose-hulman.edu/class/cs/csse304/schedule/day22/interpretersyntax-expand.rkt">interpretersyntax-expand.rkt</a> for some of the components you
need to add and how they ought to work together.

# Specifications

Implement the following procedures, ensuring they are converted by syntax-expand into
code that your interpreter, i.e. eval-expression can process.

1. Add the following primitives: *map, apply, assq, assv, append,* as well as any that are added as part of this set of test-cases. 
2. Syntax-expand the following constructs: *let, let\*, begin, cond, and, or, case.* If any of them are already part of your language and are processed by your eval-expression and remove them from eval-expression.
3. Add the *(return-first e1 ...)* which operates like "begin," i.e. it evaluates its expression in order, but instead returns the value of the first expression.
4. Add while loops to your interpreter. The syntax should be: *(while e1 e2 ...)*. It should evaluate e2 ... while e1 evaluates to true. The return value should be void.
