data Shape = Circle Float Float Float
           | Rectangle Float Float Float Float
           deriving (Show)

area :: Shape -> Float
area (Circle x y r)      = pi * r^2
area (Rectangle x y w h) = w * h

allSurface :: [Shape] -> Float
allSurface = foldl (\acc x -> acc + (area x)) 0.0
