## Assignment 16

**Reading**:  See the schedule page

**Programming problems**: This group assignment is to be done by your interpreter team. 

After this assignment  assignment, there will  a brief required participation survey on Moodle, covering A14 and A16.

## Q1 (60 points)

Add additional syntax to your interpreted language.

The new features to be added are letrec and named let.
	
You may implement letrec either (your choice)
        *directly in the interpreter* or
        via *syntax-expand*. 
 In class we discussed a way to do letrec without mutation and another way to do it via mutating a ribcage environment; or if you wish, you may instead use a syntax expansion approach that is similar to that of TSPL, near the middle of Section 4.4 in TSPL 4, which I also discussed in class.  But that last approach will require doing part of A17 first.  

## The Y Combinator (1 point)

There is actually a 3rd way to implement letrec that we did not
discuss in class, because it's much more conceptually difficult.  It
involves using something call the Y combinator, which is a famous CS
idea.  Using the Y combinator, we can implement letrec in terms of let
(i.e. letrec simply becomes a syntax expansion involving let apply and
some ordinary lambdas).  However the syntax expansion is complicated
enough I wouldn't recommend actually doing it in your interpreter.

It is definitely doable in standard racket though, using define-syntax
macros.  I made a video that explains the idea and walks you through
a basic letrec form implemented using the y combinator:

https://rose-hulman.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=94797972-3c2d-4a3c-9d12-b04c012e945b

Your challenge is to generalize that form to arbitrary letrecs.  I've includes unit test for
a y2 combinator that should be a mostly straightforward expansion of what I gave you
and the advanced-letrec syntax that can generate y combinators of any needed size.

Of course don't use letrec or named let or any unusual racket features in your solution.
