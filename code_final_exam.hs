
data TLight = Red | Yellow | Green

instance Eq TLight where
  Red     == Red    = True
  Yellow  == Yellow = True
  Green   == Green  = True
  _       == _      = False

data Point a = Point a a

instance (Eq a) => Eq (Point a) where
  (Point x y) == (Point x' y') = x==x' && y==y'

instance (Ord a) => Ord (Point a) where
  (Point x y) < (Point x' y') = x < x' && y < y'
  (Point x y) <= (Point x' y') = x <= x' && y <= y'
  (Point x y) > (Point x' y') = x > x' && y > y'
  (Point x y) >= (Point x' y') = x >= x' && y >= y'

instance (Show a) => Show (Point a) where
  show (Point x y) = "(" ++ show x ++ ", " ++ show y ++ ")"

data Dico k v = Dico [(k,v)]

instance (Show k, Show v) => Show (Dico k v) where
  show (Dico a) =
    "{" ++ inner a ++ "}"
    where
      inner [] = ""
      inner [(k,v)] = "(" ++ show k ++ ", " ++ show v ++ ")"
      inner ((k,v):rem) = "(" ++ show k ++ ", " ++ show v ++ "), " ++ inner rem

instance Semigroup (Dico k v) where
  (Dico x) <> (Dico y) = Dico (x ++ y)


