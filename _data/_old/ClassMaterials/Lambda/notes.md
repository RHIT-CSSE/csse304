
# Using the unit test system manually

Briefly, open the final named A??-testcode.rkt which should be in the
same directory as the problems.

Make sure the test code is the current window.  Run it. It should run
all the tests.

Sometimes running all the tests can be overwhelming, especially if
you've added some debugging print statements etc.  You can edit the
last line of the test file to make it run just what you want.

    (run-test interval-contains?) ; run all the tests of one name
    (run-test interval-contains? 2) ; runs the 2nd test case of the suite

Looking at the test cases themselves will let you see what inputs they
are providing.

The gradescope test system uses the same test cases (i.e. we don't
have secret test cases) - its much slower, so you'll definitely want
to test manually.

# Live coding

You can see the final code elsewhere in the repo, just notes here

## Median of 3

Use max and min to find the highest and lowest.  Just highlights how
nice max and min can be.

## Add n to each

This is a very common structure.

When you want to format across multiple lines, put arguments
vertically aligned with each other.

    (cons (+ n (car lon))
          (add-n-to-each n (cdr lon)))
          
## Count occurances

An even more common structure - break the cases into a big cond, base
cases first, then varied recursive cases.

# Lambda

An example:

    (define median-of-three
      (lambda (a b c)
          (- (+ a b c) (max a b c) (min a b c))))
          
          
Note that the define is not part of the lambda.

lambda is a function that returns a procedure.  The body of the lambda
does not execute when the lambda itself is run, rather it runs (maybe
many times) when the procedure returned from lambda is invoked.

We will usually use define to associate the newly created procedure
with a name we can call later.  But not always:

    ((lambda (x y)  (+ x y)) 1 2)

# Main Class Activity

Solve the remainder of the in class problems in groups
