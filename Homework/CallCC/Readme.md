# CallCC

This assignment gives two problems that require you to use call/cc
(i.e. continuations) to implement them.  They should be solved in
regular racket, not your hand coded interpreter.

# Retlam

So scheme doesn't have a built in return but maybe we can fix that.

The functional make-retlam takes a lambda procedure and returns a
new procedure (i.e. returnable lambda, retlam) that allows returns.
It works like this:


    (define my-div
        (make-retlam (lambda (x y)
                  (when (zero? y) (return 'divide-by-zero))
                  (/ x y))))

(my-div 1 2) => yields 1/2
(my-div 1 0) => yields 'divide-by-zero

The return procedure immediately returns from its enclosing retlam
with the given value as the result.

Note that the return function is global but it won't function
properly if used in a procedure that was not transformed by
make-retlam.  make-retlam should make a new lambda - probably one
that sets things up appropately using call-cc (and maybe also does
some work after the function call is done?).

Note that this can and should work correctly when one retlam calls
another retlam.  This will probably require a simple datastructure
- feel free to use globals to store it.  You also are permitted to
use mutation (e.g. set!) in your solution.

# Jobs

Imagine we want to think of our running program as a worker forced
to more than one job.  The worker is started using a process called
"jobs" with a set of jobs specified by procedures that are
identified by number (job 0, job 1, etc).  At various points, the
worker switches jobs by using a switch job command -
e.g. (switch-job 2).  Later, when the worker switches back to a job
they have already started, work continues from the place where they
switched.  Eventually, the worker executes (go-home) which causes
the original job call to return.  No more work on the jobs happens
once go-home is called.

Example:

    (jobs
        (lambda () (display 1) (switch-job 1) (display 3) (switch-job 1) (display 5))
        (lambda () (display 2) (switch-job 0) (display 4) (go-home)))

Prints 1234

A few things:

* A jobs number is determined by the order of the procedure in the
  jobs command.  First procedure is job 0.  Second procedure is job
  1, etc.  Work always starts with job 0.  Any arbitrary number of
  jobs can be passed, but always at least 1.

* A job procedure should never finish in a normal way.  Either it
  should switch to a different job when it is done (and the system
  should not switch back) or it should explicitly call (go-home).
  You do not need to consider a case where it returns or cases
  where a swich to a non-existant job occurs.

* You can and should use globals and mutation in your solution.
  You do not need to consider a case where a jobs command occurs
  within another jobs command, or a situation where a function like
  switch-jobs or go-home is called outside the context of a jobs
  command.

* When go-home is called, all the jobs are considered "done" even
  if they have work remaining.  There is no need to accomidate
  restarting them.  Any subsequent work will require a new jobs
  command with fresh jobs.  However, it is required that your
  system support running jobs commands one after another.

* All of the functions here ought to return void, though we do not
  test this

* You are required to implement this code yourself using call/cc.
  You can not use an existing library (e.g. coroutines) or racket
  multithreading to accomplish this.

* Hint: among other things, you'll probably want a global that
  stores the current job number
