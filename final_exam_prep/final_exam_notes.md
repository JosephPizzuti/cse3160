- [x] Slide Deck 06
- [x] Slide Deck 07
- [ ] Slide Deck 08
- [ ] Slide Deck 09
- [ ] Slide Deck 10
- [ ] Slide Deck 11
- [ ] Slide Deck 12

### Slide Deck 6

**Kinds**
- Intro
    - They are the "types of types" or :type constructors"
    - You can check the kind of something in ghci using :k \<type\>
        - * is a concrete type
    - **ONLY concrete types hold values!**
        - This include stuff like Int, Bool, Char, [Int], Maybe Bool
    - \* -> \* is the kind of a type constructur
    - you can read it as the kind of whatever you are looking at
      is the a type constructor that takes in on type of kind \*
      and returns a new type of kind \*
    - this is stuff like [] and Maybe

- Example
    - lets define the following type:
        type Dico k v = [(k,v)]
    - Dico takes two arguments, k and v, and returns a list of tuples
    - If we do :k Dico, we get:
        \* -> \* -> \*
    - So we can view chains of \* as an indicator of how many arguments a type can take
    - Think of List, which has kind of \* -> \*
    - We can fill a list with a type, like list of Int or String
    - If we take the kind of [Int], we get back \* , because it is a concrete type
    - List of Int can hold values, a plain list with no specifiers is waiting for the argument
      of what kind of type it will hold
    - So if we do :k Dico String, we get back:
        \* -> \*
    - we can see that we have filled out one of the arguments
    - if we then do :k Dico String Int, we get back:
        \*
    - we've created a concrete kind that can hold a value!

- Propositon
    - With this knowledge, we can think of kinds as a spectrum
    - The more \* -> \* links, the more abstract something is
    - The closer to just \* , the more concrete
    - This spectrum is called *specialization*

- Test
    - Assume the following data type definitions:
    - **data** Maybe a = Nothing | Just a
    - **data** Either a b = Left a | Right b
    - **data** Shape = Circle Float Float Float
    - what are the kinds of the following types?
    1. Maybe
        \* -> \*
    2. Either
        \* -> \* -> \*
    3. []
        \* -> \*
    4. Either String
        \* -> \*
    5. Shape
        \*

**Requirements**
- Also known as capabilities or interfaces
- basically tell you what you are allowed to do to values
- defined in the *deriving* field of a data type constructor
- stuff like Eq, Ord, Enum, Read, Show
- can check the requirements of a data type using :i
       
### Slide Deck 7

**Monoids**
- They are Semigroups
- Associative with identity value
- More importantly, we get 3 new behaviours:
    - the minimal implementation, **mempty** :: a
    - as well as **mappend** :: a -> a -> a
    - and **mconcat** :: [a] -> a
- The important thing to realize as we add on more instances...
    - semigroup, monoid, functor, applicative, etc.
- Is that we should be quick to use the functions of the previous instances
- to help us write the new behaviours of the new instances
- Lists are monoids, so lets cover its implementation:
    - mempty = []
    - mappend = (<>)
    - mconcat = foldr mappend mempty
- Observably, these are incredibly simple!
- mempty is the easiest; just the base case or "empty" state of whatever data type you are working with
- mappend is a simple utilization of the <> implementation from the semigroup;
- and mconcat folds over mappend!
- so practically, to make a monoid, we really just need <> and some simple insights into our data type

**Monoids and Wrappers**
- Lets say we want to make a monoid out of (0,+) and (1,x)
- we could find ourselves using Int for (0,+), and this would work fine
- but if we attempted to then make a monoid for (1,x),
- we'd find ourselves unable to make another Int monoid!
- How do we get around this?
- We can make a wrapper!
- we can make two newtypes that wrap Int up in a box
- and then create a monoid out of the boxes!
- (check code for implementation)

### Slide Deck 8

**Functors**
- so far we have semigroups and monoids
- semigroups:
    - are type \* -> constraint
    - require us to implement
        1. (<>) :: a -> a -> a
    - and we can implement
        1. sconcat :: NE.NonEmpty a -> a
        2. stimes :: Integral b => b -> a -> a
- monoids:
    - are type \* -> constraint
    - require us to implement
        1. mempty :: a
        2. mconcat :: [a] -> a
    - mappend is the same as <> so no need to do
- we see each has various requirements that need to be instantiated
- we note that these are requirements on values
- functors follow the same principle!
- there are some requirements that we need to instantiate.
- however, these requirements need to be instantiated on another kind!
- functors:
    - are type (\* -> \*) -> constraint
    - required to implement fmap :: (a -> b) -> f a -> f b
    - also have (<\$) :: a -> f b -> f a
- How can we think about this?
- Look at fmap:
    - we take in an (a -> b) function
    - and a value a that is wrapped in in a context
    - the functor, **f**, provides that context
    - so we take in f a
    - and we spit out f b
    - so really, we take in an a to b function, an a wrapped in a context f
    - then fmap takes a out of its box, performs its function, then wraps it back up in f
    - and spits out f b!
- Lets take a list for example:
    - a list is a functor; it wraps up values of type a!
    - hence the common [a] indication
    - how would we define fmap?
    - fmap = map (its just map!!)
    - map takes a function, and a list of objects, and applies that function
      onto all the objects within
    - then it spits out a list full of elements that have been modified!
- Lets recap:
    - take a list [1,2,3] and a function (+1)
    - when we call map (+1) [1,2,3], what happens?
    - we first pull 1 out of its box (the list), call the function on it (yielding 2),
      and then reinserting it back into the box (the list)
    - this is exactly how fmap is supposed to work!
    - functors just enable us to do this with data types we define!
- Note that **functor deals in \* -> \* and should not be passed concrete types!**
    - if you write a functor definition that looks like this...
    - instance Functor [a] where
    - instance Functor [Int] where
    - you have done something wrong!

### Slide Deck 9

**Applicative**
- The applicative is a generalization of the functor
- applicatives:
    - are type (\* -> \*) -> constraint
    - Required to implement
    1. pure :: a -> f a
    2a. (<\*>) :: f (a -> b) -> f a -> f b
    or
    2b. liftA2 :: (a -> b -> c) -> f a -> f b -> f c
    - also have \*> and <\* but they are unimportant
- Can think of applicatives as boxing the transformation of the functor
- or even better, **applicative is about applying functions that are inside of a context
  to values that are inside of a context**

**example using maybe**
- to better understand what is happening with pure and <\*> operator;
- lets view
