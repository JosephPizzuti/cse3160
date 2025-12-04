- [x] Slide Deck 6
- [] Slide Deck 7
- [] Slide Deck 8
- [] Slide Deck 9
- [] Slide Deck 10
- [] Slide Deck 11

### Slide Deck 6

**Kinds**
- Intro
    - They are the "types of types" or :type constructors"
    - You can check the kind of something in ghci using :k <type>
        - * is a concrete type
    - **ONLY concrete types hold values!**
        - This include stuff like Int, Bool, Char, [Int], Maybe Bool
    - * -> * is the kind of a type constructur
    - you can read it as the kind of whatever you are looking at
      is the a type constructor that takes in on type of kind *
      and returns a new type of kind *
    - this is stuff like [] and Maybe

- Example
    - lets define the following type:
        type Dico k v = [(k,v)]
    - Dico takes two arguments, k and v, and returns a list of tuples
    - If we do :k Dico, we get:
        * -> * -> *
    - So we can view chains of * as an indicator of how many arguments a type can take
    - Think of List, which has kind of * -> *
    - We can fill a list with a type, like list of Int or String
    - If we take the kind of [Int], we get back * , because it is a concrete type
    - List of Int can hold values, a plain list with no specifiers is waiting for the argument
      of what kind of type it will hold
    - So if we do :k Dico String, we get back:
        * -> *
    - we can see that we have filled out one of the arguments
    - if we then do :k Dico String Int, we get back:
        *
    - we've create a concrete kind that can hold a value!

- Propositon
    - With this knowledge, we can think of kinds as a spectrum
    - The more * -> * links, the more abstract something is
    - The closer to just * , the more concrete
    - This spectrum is called *specialization*

- Test
    - Assume the following data type definitions:
    - **data** Maybe a = Nothing | Just a
    - **data** Either a b = Left a | Right b
    - **data** Shape = Circle Float Float Float
    - what are the kinds of the following types?
    1. Maybe
        * -> *
    2. Either
        * -> * -> *
    3. []
        * -> *
    4. Either String
        * -> *
    5. Shape
        *

**Requirements**
- Also known as capabilities or interfaces
- basically tell you what you are allowed to do to values
- defined in the *deriving* field of a data type constructor
- stuff like Eq, Ord, Enum, Read, Show
- can check the requirements of a data type using :i
        
