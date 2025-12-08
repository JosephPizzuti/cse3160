import Data.Semigroup (Semigroup(..))

newtype SInt = SInt Int 
               deriving(Show)

instance Semigroup SInt where
  SInt a <> SInt b = SInt (a + b)

instance Monoid SInt where
  mempty = SInt 0
  mconcat [] = mempty
  mconcat (x:xs) = x <> mconcat xs
  --mcconcat = foldr (<>) mempty

newtype MInt = MInt Int deriving (Show)

instance Semigroup MInt where
  MInt a <> MInt b = MInt (a * b)

instance Monoid MInt where
  mempty = MInt 1
  mconcat = foldr (<>) mempty

newtype Min a = Min { getMin :: a } deriving (Show)

instance Ord t => Semigroup (Min t) where
  Min a <> Min b = Min (min a b)

instance (Ord t, Bounded t) => Monoid (Min t) where
  mempty = Min maxBound
  mconcat = foldr (<>) mempty

data MyMaybe a = MyJust a | MyNothing deriving (Show)

instance Semigroup a => Semigroup (MyMaybe a) where
  x <> MyNothing = x
  MyNothing <> x = x
  MyJust a <> MyJust b = MyJust (a <> b)

instance Monoid a => Monoid (MyMaybe a) where
  mempty = MyNothing
  mconcat = foldr (<>) mempty
