import qualified Data.List.NonEmpty as NE
import Data.Semigroup (Semigroup(..))

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

instance Num a => Semigroup (Point a) where
  (Point x y) <> (Point x' y') = Point (x + x') (y + y')
  stimes n p = aux n p p
    where
      aux 1 acc i = acc
      aux n acc i = aux (n-1) (acc <> i) i


data Dico k v = Dico [(k,v)]

instance (Show k, Show v) => Show (Dico k v) where
  show (Dico a) =
    "{" ++ inner a ++ "}"
    where
      inner [] = ""
      inner [(k,v)] = "(" ++ show k ++ ", " ++ show v ++ ")"
      inner ((k,v):rem) = "(" ++ show k ++ ", " ++ show v ++ "), " ++ inner rem

-- not ideal implementation for dico
instance (Eq k, Eq v) => Eq (Dico k v) where
  (Dico [(_,v1)]) == (Dico [(_,v2)]) = v1 == v2
  (Dico [(_,v1)]) /= (Dico [(_,v2)]) = v1 /= v2

-- not ideal implementation for dico
instance (Ord k, Ord v) => Ord (Dico k v) where
  (Dico [(_,v1)]) < (Dico [(_,v2)]) = v1 < v2
  (Dico [(_,v1)]) <= (Dico [(_,v2)]) = v1 <= v2
  (Dico [(_,v1)]) > (Dico [(_,v2)]) = v1 > v2
  (Dico [(_,v1)]) >= (Dico [(_,v2)]) = v1 >= v2

instance Semigroup (Dico k v) where
  (Dico x) <> (Dico y) = Dico (x ++ y)


