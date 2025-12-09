module Practice where

import Prelude hiding (Maybe(..), maybe, Either(..))

data SInt a = SInt { getInt :: a } deriving (Show)

instance Num a => Num (SInt a) where
  SInt x + SInt y = SInt (x + y)
  SInt x * SInt y = SInt (x * y)
  fromInteger n = SInt (fromInteger n)

instance Num a => Semigroup (SInt a) where
  SInt a <> SInt b = SInt (a + b)

instance Num a => Monoid (SInt a) where
  mempty = SInt 0
  mconcat = foldr (<>) mempty

instance Functor SInt where
  fmap f (SInt a) = SInt (f a)

instance Applicative SInt where
  pure = SInt
  SInt f <*> x = fmap f x



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

instance Applicative (Either e) where
  pure = Right
  Left f <*> _ = Left f
  Right f <*> x = fmap f x

data Maybe a = Just a | Nothing deriving (Show, Eq)

instance Semigroup a => Semigroup (Maybe a) where
  a <> Nothing = a
  Nothing <> b = b
  Just a <> Just b = Just (a <> b)

instance Monoid a => Monoid (Maybe a) where
  mempty = Nothing
  mconcat = foldr (<>) mempty

instance Functor Maybe where
  fmap f Nothing = Nothing
  fmap f (Just a) = Just (f a)

instance Applicative Maybe where
  pure = Just
  Nothing <*> x = Nothing
  (Just f) <*> x = fmap f x

-- NOTE we are wrapping 3 and 5 in two layers of abstraction!
-- If you do these commands with only Just or SInt, they also
-- work and are cleaner!

-- x = Just $ SInt 3
-- y = Just $ SInt 5
-- z = Nothing

-- x <> y          --> Just (SInt {getSInt = 8})
-- mconcat [x,y,z] --> Just (SInt {getSInt = 8})

-- NOTE The Num definition for SInt! It does a lot of heavy
-- lifting here to prevent annoying fmap/liftA2 layering!

-- fmap (+3) x          --> Just (SInt {getSInt = 6})
-- pure (+) <*> x <*> y --> Just (SInt {getSInt = 8})
-- Just (+) <*> x <*> y --> Just (SInt {getSInt = 8})
