module Practice where

import Prelude hiding (Maybe(..), maybe, Either(..))


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

instance Monad Maybe where
  Nothing >>= _ = Nothing
  Just a >>= f = f a

