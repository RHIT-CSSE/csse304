## Assignment 17

Add additional syntax to your interpreted language.   Make sure the old stuff still works. 

**Summary**: The major new features to be added are: 
- set! for local (bound) variables
- define (top-level only), including definitions of recursive procedures.  You do not need to support the 
(define (a b c) e) form or any other forms of define that create procedures without using an explicit lambda.  You do not need to support local defines (i.e. define inside let, lambda or letrec). Your interpreter must support define inside a top-level begin.
- any additional primitive procedures that are needed for our test cases.  More details below.
- set! for global (free) variables.  As described in class, you only need to have this work for variables that have already been defined. More details below.
- reset-global-env
- If top-level-eval or something that it calls creates a global variable or changes the value of a global variable, then the value of that global variable stays in effect through subsequent calls to eval-one-exp, unless reset-global-env is called (or unless evaluation of a later set! expression changes it again).

The purpose of reset-global-env is to handle the case where your interpreter does something wrong and messes up the global environment when evaluating one of your/my test cases.  If we call (reset-global-env), we should then be able to continue with the rest of the test cases, without your score being adversely affected by the evaluation of the bad (for you) previous test case.  Some of the test cases may call reset-global-env before calling eval-one-exp. You’ll need to modify your interpreter’s provide statement at the top to look like (provide eval-one-exp reset-global-env)so the tests can use it. **Do not fail to implement it.**

**Details of some of the above bulleted items**:

1.	Write the zero-argument procedure reset-global-env, which is a regular Racket procedure (not something interpreted by your interpreter).  The code I have given you below is intended to clarify its function, not to make you rewrite your interpreter.  You will need to adapt it to your particular code.  You may not already have the make-init-env  thunk, but it should be simple to modify your (define init-env ...) code  to  create it if you want to follow my approach.
	(define reset-global-env
	   (lambda () (set! global-env (make-init-env)))
Note that, as described in EoPL, set! in our interpreted language is used only to change the values stored in existing bindings, not to create new bindings.

2.	When you add define to your interpreted language, you are only required to add top-level define, a slight variation on http://scheme.com/tspl4/further.html#./further:h1  .  Here is the relevant part of the grammar:
`<form>          ::=  <definition> | <expression>  
<definition>    ::=  <variable definition> | (begin <definition>+ <expression>*)  
<variable definition> ::= (define <variable> <expression>)`   
Note that Scheme’s define has a very different meaning (and restrictions on where it can be used) when used inside a letrec, let, or lambda; your interpreter is not required to implement this in A17.  To handle top-level define, you probably will want to modify the top-level-eval procedure so it uses cases to determine whether the form is a define or not; then top-level-eval processes definitions and expressions (the latter by sending them to eval-exp, the former by evaluating the expression part via eval-exp, then modifying the global environment).  Definitions (and only definitions) change the global environment (set! may change the value of something in the global environment, but not the actual binding of the variable, which is a reference).  Note that the global environment is "special," in the sense that all other environments are static (no new variables can be added after it is created) , but the global environment is dynamic.  

**When you have finished everything up to this point, you should save a copy of your code, to use for Assignment 18 and the final exam (which will not require A18 for its interpreter questions).**

