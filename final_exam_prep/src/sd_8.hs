module PracticeEither where

import Prelude hiding (Either(..))   -- hides Either, Left, Right

data Mayb a = Nothin | Jus a deriving (Show)

instance Semigroup a => Semigroup (Mayb a) where
  a <> Nothin = a
  Nothin <> b = b
  Jus a <> Jus b = Jus (a <> b)

instance Monoid a => Monoid (Mayb a) where
  mempty = Nothin
  mconcat [] = Nothin
  mconcat (x:xs) = x <> mconcat xs

instance Functor Mayb where
  fmap f (Jus x) = Jus (f x)
  fmap f Nothin  = Nothin



data Either a b = Left a | Right b deriving (Show)

instance Semigroup b => Semigroup (Either a b) where
  Right x <> Right y = Right (x <> y)
  Right x <> _       = Right x
  _ <> Right x       = Right x
  Left x <> Left y   = Left x
 
instance Monoid b => Monoid (Either a b) where
  mempty = Right mempty
  mconcat [] = mempty
  mconcat (x:xs) = x <> mconcat xs

instance Functor (Either e) where
  fmap f (Left x) = Left x
  fmap f (Right x) = Right (f x)



data Tree a = Tree { left :: Tree a,
                     value :: a,
                     right :: Tree a
                   }
                   | Leaf deriving (Show, Eq)

instance Semigroup a => Semigroup (Tree a) where
  t <> Leaf = t
  Leaf <> t = t
  Tree l1 v1 r1 <> Tree l2 v2 r2 = 
    Tree (l1 <> l2) (v1 <> v2) (r1 <> r2)

instance Monoid a => Monoid (Tree a) where
  mempty = Leaf
  mconcat [] = Leaf
  mconcat (x:xs) = x <> mconcat xs

instance Functor Tree where
  fmap f Leaf = Leaf
  fmap f (Tree l root r) = Tree (fmap f l) (f root) (fmap f r)


newtype SQFeet a = SQFeet a deriving (Show)
instance Num a => Semigroup (SQFeet a) where
  SQFeet x <> SQFeet y = SQFeet (x + y)
instance Num a => Monoid (SQFeet a) where
  mempty = SQFeet 0
  mconcat = foldr (<>) mempty

newtype SQMeter a = SQMeter a deriving (Show)
instance Num a => Semigroup (SQMeter a) where
  SQMeter x <> SQMeter y = SQMeter (x + y)
instance Num a => Monoid (SQMeter a) where
  mempty = SQMeter 0
  mconcat = foldr (<>) mempty

data Apartment a = Apartment { living :: a,
                               kitchen :: a,
                               bathroom :: a
                             } deriving (Show, Eq)

instance Semigroup a => Semigroup (Apartment a) where
  Apartment l1 k1 b1 <> Apartment l2 k2 b2 =
    Apartment (l1 <> l2) (k1 <> k2) (b1 <> b2)

instance Monoid a => Monoid (Apartment a) where
  mempty = Apartment mempty mempty mempty
  mconcat = foldr (<>) mempty

instance Functor Apartment where
  fmap f (Apartment l k b) = Apartment (f l) (f k) (f b)

instance Foldable Apartment where
  foldMap f (Apartment l k b) = (f l) <> (f k) <> (f b)

sf2sm :: Fractional a => SQFeet a -> SQMeter a
sf2sm (SQFeet a) = SQMeter (a / 10.764)
sm2sf :: Fractional a => SQMeter a -> SQFeet a
sm2sf (SQMeter a) = SQFeet (a * 10.764)

