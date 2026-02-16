# Assignment: Type Checker in Racket

## Overview

In this assignment, you will implement a **type checker** for a small functional language with explicit type annotations. Your checker will walk an abstract syntax tree, apply typing rules, and either confirm that the program is well-typed (returning its type) or report a clear error.

## The Language

Your type checker handles the following expression language:

```
e ::= n                                numeric literal (e.g., 5, -3, 42)
    | b                                boolean literal (true or false)
    | x                                variable reference
    | (+ e₁ e₂)                       addition
    | (- e₁ e₂)                       subtraction
    | (if e₁ e₂ e₃)                   conditional
    | (fun (x : τ) : τ_ret e)         annotated function (one parameter)
    | (e₁ e₂)                         function application
    | (let ((x e₁)) e₂)               local binding
```

Note that functions carry **type annotations**: the programmer declares the parameter type and the return type. The types in the system are:

```
τ ::= Num                  numeric type
    | Bool                 boolean type
    | (τ₁ -> τ₂)          function type (from τ₁ to τ₂)
```

## Getting Started

You are provided with `type-check-starter.rkt`, which contains:

- AST struct definitions
- Type struct definitions
- A parser `(parse sexpr)` that converts s-expressions into AST nodes
- A top-level `(check sexpr)` function skeleton
- A test suite

**Your job:** Fill in the `type-check` function, case by case.

## Phased Implementation Plan

### Phase 1: Literals and Arithmetic

Implement type checking for the simplest expressions: numbers, booleans, addition, and subtraction.

**Typing rules to implement:**

- A numeric literal always has type `Num`
- A boolean literal always has type `Bool`
- `(+ e₁ e₂)`: both operands must have type `Num`; the result is `Num`
- `(- e₁ e₂)`: same as addition

**Test cases:**

```racket
(check '5) -> (tnum)
(check '(+ 3 4)) -> (tnum)
(check '(+ #t 1)) -> Error
```

### Phase 2: Conditionals

Add the `if` expression.

**Typing rule:**

- The condition must have type `Bool`
- Both branches must have the same type
- The result is that shared branch type

**Test cases:**

```racket
(check '(if #t 1 2)) -> (tnum)
(check '(if 1 2 3)) -> Error, non-bool condition
(check '(if #t 1 #f)) -> Error, branch mismatch
```

### Phase 3: Variables, Functions, and Application

This is the core of the checker.

**Typing rules:**

- **Variables:** look up in the environment; error if unbound
- **Functions:** the programmer provides `(fun (x : τ_param) : τ_ret body)`. Extend the environment with `x : τ_param`, type-check the body, and verify the body's type matches the declared return type `τ_ret`. The function's type is `τ_param → τ_ret`.
- **Application:** the function expression must have a function type `τ_arg → τ_ret`, and the argument must have type `τ_arg`. The result is `τ_ret`.

**Test cases:**

```racket
(check '(fun (x : Num) : Num (+ x 1))) -> (tfun (tnum) (tnum)))

(check '((fun (x : Num) : Num (+ x 1)) 5)) -> (tnum))

(check '((fun (x : Num) : Num (+ x 1)) #t)) -> Error
(check '(1 2)) -> Error
```

### Phase 4: Let Expressions

Add `let` bindings. These do not need type annotations — the type of the bound variable is simply whatever the bound expression's type is.

**Typing rule:** type-check the binding, extend the environment, type-check the body.

**Test cases:**

```racket
(check '(let ((x 5)) (+ x 1))) -> (tnum)
(check '(let ((f (fun (x : Num) : Num (+ x 1)))) (f 5))) -> (tnum)
```

---

## Typing Rules Summary

For quick reference, here are all the rules in one place:

```
                                        [T-Num]
  ─────────────────
    Γ ⊢ n : Num


                                        [T-Bool]
  ──────────────────
    Γ ⊢ b : Bool


    (x : τ) ∈ Γ                        [T-Var]
  ─────────────────
    Γ ⊢ x : τ


    Γ ⊢ e₁ : Num      Γ ⊢ e₂ : Num    [T-Add]
  ──────────────────────────────────
         Γ ⊢ (+ e₁ e₂) : Num


    Γ ⊢ e₁ : Bool    Γ ⊢ e₂ : τ    Γ ⊢ e₃ : τ
  ─────────────────────────────────────────────── [T-If]
              Γ ⊢ (if e₁ e₂ e₃) : τ


    Γ, x:τ₁ ⊢ body : τ₂      τ₂ = τ_ret
  ────────────────────────────────────────── [T-Fun]
    Γ ⊢ (fun (x:τ₁):τ_ret body) : τ₁→τ_ret


    Γ ⊢ e₁ : τ₁→τ₂      Γ ⊢ e₂ : τ₁   [T-App]
  ──────────────────────────────────────
          Γ ⊢ (e₁ e₂) : τ₂


    Γ ⊢ e₁ : τ₁      Γ, x:τ₁ ⊢ e₂ : τ₂   [T-Let]
  ────────────────────────────────────────
       Γ ⊢ (let ((x e₁)) e₂) : τ₂
```

---

## Implementation Guide

### The Environment

Use a Racket hash table mapping symbols to types:

```racket
(define empty-env (hash))
(define env-with-x (hash-set empty-env 'x (tnum)))
```

### Structure of `type-check`

Your main function has the signature:

```racket
;; type-check : Env × Expr → Type
;; Returns the type if well-typed, raises an error otherwise.
(define (type-check env expr)
  (match expr
    [(num-e _)  ...]
    [(bool-e _) ...]
    ...))
```

Each case corresponds directly to one of the typing rules above.

### Debugging Tips

1. **Work phase by phase.** Get Phase 1 passing before moving on.
2. **Use `#:transparent` on structs.** This makes types print readably.
3. **Test in the REPL.** Try `(check '(+ 3 4))` interactively.
4. **Read the error messages.** Make yours clear enough that a user would know what went wrong.



---

## Resources

- Lecture notes on Types and Type Checking
- *Programming Languages: Application and Interpretation* (PLAI) by Shriram Krishnamurthi (freely available online)
- The Racket Guide: https://docs.racket-lang.org/guide/
