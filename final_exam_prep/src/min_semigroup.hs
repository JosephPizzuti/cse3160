data Min a = Min { getMin :: a } deriving (Show)

instance Ord a => Semigroup (Min a) where
  Min a <> Min b = Min (min a b)

instance (Ord a, Bounded a) => Monoid (Min a) where
  mempty = Min maxBound


data Mayb a = Jus a | Nothin deriving (Show)

instance Semigroup a => Semigroup (Mayb a) where
  a <> Nothin = a
  Nothin <> b = b
  Jus a <> Jus b = Jus (a <> b)

instance Monoid a => Monoid (Mayb a) where
  mempty = Nothin
  mconcat [] = mempty
  mconcat (x:xs) = x <> mconcat xs
