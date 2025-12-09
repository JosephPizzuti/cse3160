- [x] Slide Deck 06
- [x] Slide Deck 07
- [x] Slide Deck 08
- [x] Slide Deck 09
- [x] Slide Deck 10
- [x] Slide Deck 11
- [ ] Slide Deck 12

### Slide Deck 6

**Kinds**
- Intro
    - They are the "types of types" or "type constructors"
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
- lets go over an example with maybes applicative
- take the following command:
    - > pure (+) <\*> Just 3 <\*> Just 5
    - we first wrap our function (+) into a Maybe context using pure;
    - this satisfies the input of f (a -> b)!
    - we apply this to just 3, which is a value a wrapped in a maybe context (f a),
    - Where we now have Just (+3), a function with a Maybe Context! (f (a -> b))
    - Now this can serve as the contextualized function for Just 5!
    - Which will yield Just 8! (as per the fmap call we perform)
- So really, the applicative is just an upgrade to functor;
- not only are we wrapping our values, we are wrapping our transformative functions too!

**quick look at pure again**
- remember that pure gives us to way to wrap the "transformer" or "function" that we use
  for <\*> into the same context as the wrapped up values we are using. This lifts the whole
  computation into the applicative!

**The <$> operator**
- the \<$\> operator is best used to automatically embed the callee in context
- what we mean by this: usually, you have to do the following line of code:
    - > pure (+) <\*> Just 5 <\*> Just 3
- This wraps the transformed "(+)" into a Maybe context, allowing us to use <\*> !
- however, we could instead do:
    - (+) \<$\> Just 5 <\*> Just 3
- The $ operator simply uses pure to wrap the callee into a default context that matches the args!
- Its a simple helper that cleans up the use of pure a little bit
- optional but helps make cleaner code!

### Slide Deck 10

**Monads**
- An extension of the applicative
- Monad:
    - is type (\* -> \*) -> constraint
    - requires implement of >>= :: m a -> (a -> m b) -> m b
    - also has >> and return; return is just pure in most cases and >> is provided by >>=
- lets unpack >>= (refered to as bind):
    - we take in a monadic value (m a)
    - we take in a function that reads an a and spits out a monadic value (a -> m b)
    - and we return a monadic value (m b)
- **v >>= f** : find a Monadic value **v** as the input of the function **f** to yield another Monadic value
- Another way to view bind:
    1. Bind unwraps the value
    2. Bind feed the unwrapped value in to the function
    3. Bind wraps the value back up in the monadic context

**Return**
- Return is not to return!
- Return is used to wrap a value into context!
- That is why we see code like this:

ghci> Just "Foo" >>= (\x -> return $ x ++ "bar")
Just "Foobar"

- when we pass Just "Foo" through the bind into the lambda and into the variable x,
- it gets unwrapped! This means that x contains the string "Foo";
- So, we need to wrap the value back up into its monadic context after the lambda does its core functionality!
- To do this, we can either use return, which is designed to wrap values back up
  in their context based off of what it is handling;
- Or, if we know what we are working with, we could replace return with Just and forego the $
- Both work, but return is generally better
- Compare the two following coded examples:

ghci> (\x -> Just (x+1)) 1
Just 2
ghci> (\x -> return (x+1) :: Maybe Int) 1
Just 2

- Notice how return is aware of the type context of the Maybe Int value
- It does not require to use Just directly; if it has the context, return will do the work for us!
- It will wrap it up back into the correct context, is another way of saying it

**Chain Bind**
- We should also be aware that we can chain binds together!
- they will feed input to one another; take the following example with Maybe:

ghci> Just 5 >>= (\x -> return (x+1)) >>= (\x -> return (x\*2))
Just 12

- Just 5 is fed into the first bind, where it is unwrapped into 5, called in x+1 = 6, wrapped back up
  into Just 6, then fed into the next bind, where it is unwrapped into 6, called in x\*2 = 12, wrapped back
  up into Just 12, and done!
- Note that if you fed the chain of binds with a Nothing, it would output Nothing! even when we
  are chaining binds, it will get passed safely and correctly through the pipeline

**Do**
- the do block is something that is build into haskell to make binds look cleaner
- they function EXACTLY the same way as normal binding
- so much so that translating between the two is incredibly simple
- take the two examples:

foo :: Maybe String
foo = do
  x <- Just 3
  y <- Just "!"
  Just (show x ++ y)

foo' :: Maybe String
foo' =
  Just 3 >>= (\x ->
  Just "!" >>= (\y ->
  Just (show x ++ y)))

- we can see that foo gets rid of the all of the lambdas and parentheses
- and lets us pleasingly display what is happening
- x <- Just 3 is simply binding Just 3 to x,
- y <- Just "!" is binding "!" to y,
- and then just like foo', returns Just show x ++ y
- Note that there isn't any assigning going on with the do blocks; under the hood,
  foo behaves exactly like foo'. There is NO DIFFERENCE. 
- Also note that the Just in the show line could easily be swapped with return; they do the same thing
  and **it is encouraged to let haskell handle recognizing the context**
- Remember, return is not like an actual return statement! It is simply wrapping the value up in the
  inferred context, which it knows based on the type of what it is working in

**let**
- let is an expression in do blocks that allows variable assignment
- but its syntax is different than a traditional let..in block
- view the following function:

punctuation v = do
  let punct = "!"
  x <- return v
  y <- Just punct
  return (show x ++ y)

ghci> punctuation 3
Just "3!"

- *Note that we could have simply assigned y <- Just "!" and it would work the same.*
- let allows us a way to give assignment to non-monadic values within the block
- in other words, if we tried to do y <- "!", it wouldn't work. But we still want to put "!" into a variable
  for whatever reason. So, we can use let to have a non-monadic assignment to a variable that can be reused for
  whatever our needs. This becomes more useful in the IO context later.

**pattern matching**
- we can also do pattern matching within do blocks:

justH :: Maybe Char
justH = do
  (x:xs) <- Just "hello"
  return x

ghci> justH
Just 'h'

- nothing overtly new or special. Just note that its possible (and likely important!)

**MonadFail**
- another instance we can implement is MonadFail:
    - has type (\* -> \*) -> constraint
    - requires us to implement its only requirement, fail :: String -> m a
- Maybe has an implementation of this!

instance MonadFail Maybe where
  fail _ = Nothing

- cool for debugging assistance, otherwise not necessary
- example is for the previous justH function; if we had instead passed in Just [] instead of Just "Hello",
  it would return Nothing because x does not contain anything!

**List Monad**
- lists are also a monad, unsurprisingly. Take the following example:

hoo :: [(Int, Int)]
hoo = do
  x <- [1..3]
  y <- [4..6]
  return (-x,y)

ghci> hoo
[(-1,4),(-1,5),(-1,6),(-2,4),(-2,5),(-2,6),(-3,4),(-3,5),(-3,6)]

- we see some pretty interesting things here
- we see that the function hoo covers all variations of (-x,y)
- we should note that this functions EXACTLY like list comprehensions!
- in fact, list comprehensions are nothing more than syntactic sugar for monadic lists!

**Guards**
- guards are an importable (or definable) feature that cleanly cover if-then-else do binds
- take the following code:

fun1 u = do
  x <- [1..u]
  if '7' `elem` show x
    then return x
    else []

fun2 u = do
  x <- [1..u]
  guard ('7' `elem` show x)
  return x

- both of the following blocks of code achieve the same thing!
- they bind [1..u] to x, and then filter it based on if there is a 7 in the number
- then spit out the remaining list!
- implementation for guard is simple for list monad..
- first need to define an instace monadPlus to support the non-value:

class Monad m => MonadPlus m where
  mzero :: m a

instance MonadPlus [] where
  mzero = []

- then implement the function guard:

guard :: (MonadPlus m) => Bool -> m ()
guard True = return ()
guard False = mzero

- in other words, if guard evaluates to True, we return the monadic value
- otherwise, we return mzero, which in our case is the empty list!
- this allows our binds to chain together fluidly

### Slide Deck 11

**IO**
- handles printing and taking input from IO stream
- two important functions: getLine and putStrLine:

main :: IO ()
main = do
  putStrLn "Hello world! Who are you?: "
  name <- getLine
  putStrLn $ "Hey " ++ name ++ "!"

main' :: IO ()
main' =
  putStrLn "Hello world! Who are you?" >>
  getLine >>= \name ->
  putStrLn $ "Hey " ++ name ++ "!"

- we see that putStrLn takes in a string and puts it to the IO stream
- getLine waits for an input and collects whatever the user inputs on a line
- can concat similar to c++
- Note the binds for main' ; putStrLn has no meaningful output so we can use >>
- getLine's collection is put into name, which is passed to the final putStrLn
- Lets look into another example:

mainReverse :: IO ()
mainReverse =
  getLine >>= \line ->
  if null line
    then return ()
    else
      (putStrLn $ reverseWords line) >>
      mainReverse

- here, we see code that does two things;
  1. we do not return unless a condition is met
  2. if we go down the else branch, we recursively call main
- These things are ok to do; we getLine, return Void or () if nothing in the buffer,
  otherwise we reverse the line and write it to output, recursively calling the function again
  to get another resposne from the user
- you could rewrite this with two nested do blocks, which is valid!

**sequence**
- takes a list of monadic actions and executes them one by one
- Ex:

sequence $ replicate 80 (putChar '\*')

- This just writes 80 \*'s to the terminal
- can use sequence_ to ignore output

**some convenience functions**
- forever does what you think it does; loops infinitely; goes before your do block like:

main = forever $ do

- getContents will retrieve everything for stdin
- example of turning all stdin uppercase and writing it back to stdout

contents <- getContents
putStr (map toUpper contents)

- less convenience, but if you want to filter all input and write to output:
- (interact handles going from input to output, so that is convenience!)

main = interact $ unlines . filter ((<10) . length) . lines

- we can read and write to files easily!

main = do
  content <- readFile "foobar.txt"
  writeFile "foobar.txt.bak" content

**handling file reading and writing**
- take the following program:

import System.IO

data Student = Student {
  name :: String,
  age :: Int,
  grade :: Char
  } deriving (Show, Read, Eq)
type LStudent = [Student]

main :: IO ()
main = do
  let x = [Student "Joe" 21 'B',
           Student "Jane" 22 'A',
           Student "John" 23 'D']
  putStrLn $ show x
  writeFile "class.data" (show x)

- Important thing to note is that we can use show x as what we do to write to a file
- take the read implementation:

main :: IO ()
main = do
  ppl <- readFile "class.data"
  let y = read ppl :: LStudent
  putStrLn $ "Data read back:\n" ++ (show y)

- look how we assign the readFile do a variable
- and then use read on the variable
- whats going on here?
- when we do readFile, we get back a String that contains the result of show x, where x was the list
  of students. This input is fine, but not really usable
- so, we use read and type hinting to make y = the original list of students!
- this works because LStudent is a list of students that we defined, which makes this super easy!

### Slide Deck 12

**State Monad**
- 

