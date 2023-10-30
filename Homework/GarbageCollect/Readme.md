# Garbage Collection

In this lab we want to implement a simple garbage collection system
for a scheme interpreter.  All of our prior interpreters have relied
on scheme's built in garbage collection to do our work.  But to be
able to do garbage collection, we'll need to have memory structures we
can traverse without the scheme garbage collector getting involved.

## Memstructs

A memstruct is a construct I have built for this lab, a bit like
Scheme's built in structures but much more rudimentary.

### Memory

Defined on line 55 of garbage-collect.rkt you will see a vector called
"memory".  This memory is where all our memstruct data will be stored.
It is a vector of integers, so all our data must be integers.
Basically, we will have 2 kinds of data:

1.  Raw data which will always be just ordinary integers
2.  Pointers which will be indexes into the memory vector

Anything more complicated than that will be a "memstruct"

Also of importance here is next-index.  This indicates that index that
can next be safely used for more allocations.  All indexes greater
than next-index are available for use.  put! (discussed below) adds
new data at next-index and advances next-index appropriately.

When we garbage collect, we will reset next-index to recycle the
memory we've freed.

### Defining memstructs

You can declare a new kind of memstruct like this:

    (define-memstruct linked-list-node ptrs: (nextPtr) vals: (my-value))

Once you have done so you can make new instances of that memstruct like this:

    (reset-memory 10) ; <- not needed but useful for printing
    
    (define last-ll-entry (put! 'linked-list-node null-ptr 222))
    (define not-last (put! 'linked-list-node last-ll-entry 111))
    
put! stores the memstruct in the memory vector.  It expects the data
in the given order, for last-ll-entry nextPtr is null-ptr and my-value
is 222.

If we look at memory after these declarations we see:

    '#(3 -1 222 3 0 111 -1 -1 -1 -1)

3 is the type of a linked-list-node.  linked-list-nodes are always 3 integers long
in memory.  last-ll-entry is the first thing in memory at index 0.
You can see its type and then the values of its two fields.  not-last
follows after that.  The zero is the index of last-ll-entry which is
what not-last's nextPtr field was set to.

The negative ones that follow after are just unused memory.

### Accessing memstructs

The good news is that we don't normally have to think very hard about
memory to access memstructs.  For example, if we want to retrieve a
particular value, we just use get-val

    (get-val 'linked-list-node 'my-value not-last) ; yields 111
    
Same thing for pointers, but its a separate function

    (get-ptr 'linked-list-node 'nextPtr not-last) ; yields (ptr 0)
    
The memstruct system keeps metadata on all its datatypes.  So it is
able to figure out what offset to look for my-value and then get it
safely.  Of course this all relies on you passing the correct type to
get-val/get-ptr - if you lie about the type, what you'll get out will
be garbage data.

### Ptrs

You may wonder why the distinction between val data and pointer data.
This distinction is very important for a garbage collector.  If we see
a value 25 in memory, it will be critical to know if that is a just
the ordinary number 25 or if it is a pointer to an object at index 25.
memstructs gives us this distinction.

With a memstruct we can even ask 2 very critical questions, for a given
memstruct, what other memstructs does it point to?

    (ptr-pointers not-last) ; yields (list (ptr 0))
    
And how big is a memstruct in memory?

    (ptr-length not-last) ; yields 3

The ptr struct you see being bandied about is just a little scheme
structure wrapper, to (somewhat) prevent you from passing values where
pointers are expected.  But you can convert them to/from raw values if
you like:

    (ptr 88) ; creates a new ptr for index 88
    (ptr-index not-last) ; yields 3 the index of not last

There is one special case - null-ptr.  This is pointer that points to
nothing, which is represented by (ptr -1).  You'll often need to
consider this special case in your code and not access it like a valid
object.  If you need to create a null-ptr in your own code, null-ptr
is prebuilt one you can use.  If you want to test to see if a value is
null null-ptr? is a function to use.

### More memstruct functions

There are more functions in the garbage-collect.rkt file - feel free
to take a look.

# Reachability

The operation of a garbage collector is simple at its core: given a
set of pointers that we *know* we are still using (often called the
basis set) what other objects are reachable?  Anything not reachable
from the basis set (directly or perhaps very indirectly) must not be
accessible anymore and can be recycled.

Answering this question is as simple as traversing the network objects
in memory make.  More sophisticated garbage collection routines try to
use various heuristics to limit how much traversal is needed, but in
our case we're happy to just traverse the entirety of accessible
memory.

All reachable is a function give a list of pointers, returns a list of
all pointers reachable from that basis set.

    (all-reachable (list not-last)) ; yields (list (ptr 0) (ptr 3))
    (all-reachable (list last-ll-entry)) ; yields (list (ptr 0))
    
Implement the function all-reachable.  Note that it is normal for
cycle structures to exist in memory, your code must handle them safely
(i.e. not visit nodes already visited).

Both for this algorithm and garbage collection below, you'll likely
find it's not possible to decompose this into a single simple
recursive function.  My solution uses helper functions, data
structures like hashtables, and mutable state.  Feel free to use all
these things as you solve these problems!

# Garbage collection

The simplest possible garbage collector might be as simple as
discovering what is reachable and then adding any inaccessible regions
into the free list to be reused.  But doing that would lead to memory
fragmentation, and anyways require a much more complicated scheme to
allocate memory that we're currently using with next-index.

Instead, what we'll need to do is compact our memory when we garbage
collect it.  For example, imagine memory looks like this

    X X 3 -1 222 X X X 3 2 111 X X X
    
...where the Xs represent inaccessible memory.  We'll want to rewrite
memory like this:

    3 -1 222 3 0 111 X X X X X X X X
    
Compacting the used regions.  Now next-index can be set at the
beginning of the Xed region safely.

In the above example, we had two objects and both moved.  But note the
second object (i.e. the 111 object).  It didn't just move - its data
changed.  That's because it was pointing to the 222 object, and the
222 object changed positions.  Objects are not only moved, but their
internal pointers are modified to reflect the new positions.  Hence,
code that uses them does not realize memory has been adjusted.  Note
that their data values are never changes, just their pointers - again,
knowing which is which is essential to any garbage collection
algorithm.

One final note: the order in which objects are moved in memory
matters.  If we moved the 111 object first, we would have a problem
because it would overwrite parts of the 222 object as it was copied to
its final location.  If we copy earlier parts of memory before later
parts, we won't have this problem.

## The garbage-collection function

The function garbage collect takes a list of pointers corresponding to
the basis set, identifies the inaccessible regions, compacts and
rewrites memory as needed, and then returns a list given of the new
pointers of all entries in the basis set (recall that objects may have
moved).

For example lets start with this code:

    (reset-memory 10)
    (define delme (put! 'linked-list-node null-ptr -5))
    (define last-ll-entry (put! 'linked-list-node null-ptr 222))
    (define not-last (put! 'linked-list-node last-ll-entry 111))
    
Memory looks like this:

    #(3 -1 -5 3 -1 222 3 3 111 -1)
                               ^ next-index
    
If I call (garbage-collect (list not-last)), it changes to this:

    '#(3 -1 222 3 0 111 3 3 111 -1)
                        ^ next-index
    
And garbage collect returns (list (ptr 3)).  If I access (get-ptr
'linked-list-node 'nextPtr (ptr 3)) I get the updated location of the
222 object.

Note that my algorithm leaves "trash" data where it was - the 3 3 111
-1 at the end of memory is just leftovers, and next-index is updated
to reflect that and overwrite that data once new objects are allocated.
You can do it my way or put placeholder values in the newly freed
space if it feels cleaner to you to do so.

Successful garbage collection requires that I henceforth discard any
old pointers I might have been using directly that I didn't put in the
basis set (e.g. delme, last-ll-entry) and that anything in the basis
set use the new version (so I'd normally do something like (set!
not-last (ptr 3)).

## Validate memory

My tests use a built in function called validate-memory which you
should not need to modify.

Basically, it ensures memory is fully compact - that there is no space
between objects and all internal pointer fields point to known objects
in memory (i.e. they don't point past next-index or to some
intermediate point that isn't the start of a memstruct).  It also
returns the number of objects in memory.  I use this number to check
and ensure no inaccessible objects remain in my test cases.

If it detects a problem, it errors with a description of the issue.

## Small hints

* When I solved this problem, I first got my code to copy objects
  correctly and only then worried about rewriting internal pointers.

* Once the accessible structs are calculated, it's easy given their
  size to calculate where they will live in the new universe.  I built
  a hashmap with the results of that to allow me to easily rewrite
  internal pointers.  Only then did I bother with the actual moving of
  the data.

* I encourage you to test with you own test structs and cases by hand
  before moving to the given test cases.

* To actually do the data copy I set next index to zero and used
  write-array!  There are other ways than can work too:
  
        (write-array!
            (append (list (vector-ref memory p))
                          <rewritten-pointers>
                          (ptr-values (ptr p)))
             next-index)

# A Garbage Collected Interpreter

Once you've got working way to garbage collect structures, making a
garbage collected interpreter is "simply" a matter of using those
structures everywhere in your interpreter.

Take a look at gc-interpret.rkt - it isn't a fully compliant scheme
interpreter but it is most of the interesting bits.  If you scroll
down to the bottom of the file you can see the types of inputs it can
handle.  It does not have support for strings or symbols, because
those are annoying to cash out in terms of integer values.  I didn't
bother with anything related to syntax expansion, because I'm sure its
clear to you how those features could be added.  But it has lambdas
and user created list structures - two key components insofar as
creating interesting memory for garbage collection purposes.  Feel
free to play around with it a bit - it doesn't have an rep but you
can eval-one whatever you'd like to try.

Go up to the top of the file and take a look at the all the
define-memstruct types: pairs, environments, closures, continuations,
and every kind of abstract syntax tree expression.

If you look at the functions for evaluation, you will see that all of
them use memstructs and Integers exclusively as far as its parameters
and return values goes.  Hence, except for maybe a little allocation
within a particular function, all the memory needs of this code are
met using memory rather than Scheme's automatically garbage collected
structures.

You'll be happy to hear that I built this all for you, because (I
admit) it was kinda annoying to do.

There is a bit of use of ordinary memory as we parse the scheme lists
that arrive as inputs to parse-exp, and then a little bit more as the
results of evaluation are converted back to lists for easy comparison
in our testing routines.  These dependencies could be cleared as well
if we used strings as inputs and outputs, but that would go beyond the
goals of this little toy proof of concept language.

This interpreter has one unusual feature - "pause".

    > (eval-one '(+ 3 (pause (+ 1 2))))
    (list 'paused (ptr 1420) (ptr -1) (ptr 1452))
    
What this does is stop execution before evaluating a specific
expression (in this case (+ 1 2)) and return a little structure
referencing the current expression, environment, and continuation.

If you want, you can then pass this structure to the function
eval-continue and it will resume execution.

    > (define paused-state (eval-one '(+ 3 (pause (+ 1 2)))))
    > (eval-continue paused-state)
    6

## What to do

Modify the unimplemented function gc-before-continue.  This function
takes in a paused state, uses that as a basis for garbage collection,
and then returns a new paused state with the rewritten structures.
That new pause state should be resumable with eval continue.

    (reset-memory 500)
    (let* ((paused-state (eval-one '(+ (+ 1 2) (+ (pause (+ 3 4)) (+ 5 6)))))
           (num-objs1 (validate-memory))
           (new-paused-state (gc-before-continue paused-state))
           (num-objs2 (validate-memory))
           (overall-result (eval-continue new-paused-state)))
      (printf "garbage collector cleaned ~s objects, left ~s objects~n" (- num-objs1 num-objs2) num-objs2)
      (printf "final result is ~s~n" overall-result))

On my system this outputs

    garbage collector cleaned 34 objects, left 32 objects
    final result is 21

# Thats it!

Upload both garbage-collect.rkt and gc-interpret.rkt to Gradescope.
They must be named exactly that or the tests will not run.
