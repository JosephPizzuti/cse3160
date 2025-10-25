import Data.List
data Shape = Circle Float Float Float
           | Rectangle Float Float Float Float
           deriving (Show)

area :: Shape -> Float
area (Circle x y r)      = pi * r^2
area (Rectangle x y w h) = w * h

allSurface :: [Shape] -> Float
allSurface = foldl (\acc x -> acc + (area x)) 0.0

-- abstraction
peri :: Shape -> Float
peri (Circle x y r)      = 2 * pi * r
peri (Rectangle x y w h) = 2 * (w + h)

shapeFold f = foldl (\acc x -> acc + (f x)) 0.0

allArea :: (Foldable s) => s Shape -> Float
allArea = shapeFold area

allPeri :: (Foldable s) => s Shape -> Float
allPeri = shapeFold peri

-- Note the enum mark so we can display [Monday .. Friday]
data WeekDays = Monday | Tuesday | Wednesday | Thursday | Friday
                deriving (Show, Enum)

-- Better way to define shape
data Shapes a = Circ {
  x :: a,
  y :: a,
  r :: a
} | Rec {
  x :: a,
  y :: a,
  w :: a,
  h :: a
} | Tri {
  x :: a,
  y :: a,
  sideA :: a,
  sideB :: a,
  sideC :: a
} deriving (Show)

periTri (Tri _ _ a b c) = a + b + c

-- Dictionary
type Dictionary k v = [(k,v)]

dfind :: (Eq k)               => k -> Dictionary k v -> Maybe v
dinsert :: (Eq k, Eq v)       => k -> v -> Dictionary k v -> Dictionary k v
make :: (Eq n, Enum n, Num n) => n -> Dictionary n n

dfind k [] = Nothing
dfind k ((key,val):t)
  | key == k = Just val
  | otherwise    = dfind k t

dinsert k v [] = [(k,v)]
dinsert k v (e:t)
  | (fst e) == k = (k, v) : t
  | otherwise    = (fst e, snd e) : dinsert k v t

make n = foldr (\x acc -> dinsert x (x*100) acc) [] [1..n] 
