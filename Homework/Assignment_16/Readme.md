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

If you did not implement while as a syntax-expansion in A14, you should do so for this assignment.

A17 will be more substantial (add set!, define, reference parameters, and lexical address).  Since this assignment is by far the smallest interpreter assignment, and since both A17 and A18 are much longer and harder, I  suggest that you plan to finish this assignment early and get an early start on the next one.

I also suggest that you begin working together  on this assignment together soon after the finishing A14, and do not wait until after A15 is due.
