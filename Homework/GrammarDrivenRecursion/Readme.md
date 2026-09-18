## Grammar Driven Recursion

### AI Usage

For this assignment, you may use AI in one specific way.

1.  If you get stuck on 1 problem / problem set, you may use AI to help you.

2.  By help - you can ask AI to explain approach to problems, to help
    you debug your code.  You may not use AI to write your code.
    
3.  You must note in comments that you used AI for the problem you
    used it, and what prompts you used.

## Q1 (50 points)

These s-list procedures have a lot in common with the s-list procedures that we wrote during our Session 8 class.  Recall the extended BNF grammar for s-lists:

    <s-list>       ::= ( {<s-expression>}* )
    <s-expression> ::=  <symbol> | <s-list>

**FOLLOW THE GRAMMAR!**

(a)	(slist-map proc slist) applies proc to each element of slist.
          **slist-map**:  *procedure* x *Slist* -> *NestedListOfThingsThatAreInTheRangeOfProcedure*

      (slist-map symbol? '((a (()) b) c () (d e)))        ->  ((#t (()) #t) #t () (#t #t))
                (slist-map (lambda (x) 
                    (let ([s (symbol→string x)]) 
                           (string→symbol (string-append s s)))) 
                  '((b (c) d) e ((a)) () e))               ->      ((bb (cc) dd) ee ((aa)) () ee)

(b)	(slist-reverse slist) reverses slist and all of its sublists.
          *slist-reverse*:  *Slist* -> *Slist*
	
       (slist-reverse '(a (b c) ( ) (d (e f)))) -> (((f e) d) ( ) (c b) a)

(c)	(slist-paren-count slist) counts the number of parentheses required to produce the printed representation of  slist.  You must do this by traversing the structure, not by having Scheme give you a string representation of the list and counting parenthesis characters. You can get this count by looking at cars and cdrs of slist).

**slist-paren-count**:  *Slist* -> *Integer*


        (slist-paren-count '())                   -> 2	      
        (slist-paren-count '(a (b c) d))          -> 4			
        (slist-paren-count '(a (b) (c () ((d))))) -> 12	

**Note** : s-lists are always *proper* list

(d) (slist-depth slist) finds the maximum nesting-level of parentheses in the printed representation of slist. You must do this by traversing the structure, and not by having Scheme give you a string representation of the list and counting the maximum nesting of parenthesis characters.

**slist-depth**:  *Slist* -> *Integer*

    (slist-depth '())                               -> 1
    (slist-depth '(a b c))                          -> 1
    (slist-depth '(a (b c) d))                      -> 2
    (slist-depth '(a (b (c)) (a b)))                -> 3
    (slist-depth '(((a) (( )) b) (c d) e))          -> 4 

(e) (slist-symbols-at-depth slist d)returns a list of the symbols from slist whose depth is the positive integer d.  They should appear in the same order in the return list as in the original s-list.  This one has the basic pattern of the other s-list procedures, but when writing the solution, I found it easier to use a slight variation on that pattern.

**slist-symbols-at-depth**:  *Slist* x *PositiveInteger* -> *ListOf*(*Symbol*)

    (slist-symbols-at-depth '(a (b c) d) 2)  -> (b c)
    (slist-symbols-at-depth '(a (b c) d) 1)  -> (a d)
    (slist-symbols-at-depth '(a (b c) d) 3)  -> ()


## Q2 (10 points)

(path-to slist sym) produces a list of cars and cdrs that (when read left-to-right) take us to the position of the leftmost occurrence of sym in the s-list slist.  Notice that the returned list contains the symbols 'car and 'cdr, not the *car* and *cdr* procedures.  Return #f if sym is not in slist.   Only traverse as much of slist as is necessary to find sym if it is there.

    > (path-to '(a b) 'a)
    (car)
    > (path-to '(c a b) 'a)
    (cdr car)
    > (path-to '(c () ((a b))) 'a)
    (cdr cdr car car car)
    > (path-to '((d (f ((b a)) g))) 'a)
    (car cdr car cdr car car cdr car)
    > (path-to '((d (f ((b a)) g))) 'c)
    #f


## Q3 (15 points)

Predefined Scheme procedures like cadr and cdadr are compositions of up to four cars and cdrs.  You are to write a generalization called make-c...r, which does the composition of any number of cars and cdrs.  It takes one argument, a string of a's and d's, which are used like the a's and d's in the names of the pre-defined c…r functions.  For example, (make-c...r "adddd") is equivalent to (compose car cdr cdr cdr cdr).

    > (define caddddr (make-c...r "adddd"))
    > (caddddr '(a (b) (c) (d) (e) (f)))
    (e)
    > ((make-c...r "") '(a b c))
    (a b c)
    > ((make-c...r "a") '(a b c))
    a
    > ((make-c...r "ddaddd") '(a b c ((d e f g) h i j)))
    (i j)
    > ((make-c...r "addddddddddd") '(a b c d e f g h i j k l m))
    l

[compose](https://docs.racket-lang.org/reference/procedures.html#%28def._%28%28lib._racket%2Fprivate%2Flist..rkt%29._compose%29%29)
is a key utility in functional style.  It combines any number of
(usually) one argument functions into a single function.  BTW, another
really useful one we won't really talk about in class is curry (I
encourage you to [check it
out](https://docs.racket-lang.org/reference/procedures.html#%28def._%28%28lib._racket%2Ffunction..rkt%29._curry%29%29).

I require you to use compose to solve this problem - do NOT build your
own solution from scratch that calls car and cdr.  The idea is pretty
simple - compose together the cdr and car functions needed depending
on the input string (BTW string->list is the way to get the individual
characters out of the list).  A simple recursion can do it - map makes
it even easier.

**Note:** some versions of this assignment suggested using eval.
Don't use eval - it's unnecessary.
