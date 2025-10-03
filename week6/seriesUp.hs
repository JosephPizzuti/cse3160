-- Given n >= 0, create an array with the pattern {1, 1,2, 1,2,3 ... 1,2,3..n}
-- We can use list comprehension to make a list

seriesUp :: Int -> [Int]
seriesUp 0 = []
seriesUp n = concat [[1..p] | p <- [1..n]]

seriesUpLenSum :: Int -> Int
seriesUpLenSum 0 = 0
seriesUpLenSum n = sum [1..n]

seriesUpLen :: Int -> Int
seriesUpLen 0 = 0
seriesUpLen n = n * (n+1) `div` 2

-- List of Lists solutions
-- originally did (++) but isn't effecicent; use (:) instead
-- fun fact; this spirals out from the middle
seriesUpRecur :: Int -> [[Int]]
seriesUpRecur 0 = [[]]
seriesUpRecur 1 = [[1]]
seriesUpRecur n = reverse $ [1..n] : seriesUpRecur (n-1)

seriesUpRecur' :: Int -> [[Int]]
seriesUpRecur' n = aux n []
  where
    aux 0 acc = acc
    aux n acc = aux (n-1) ([1..n] : acc)

-- Higher Order
seriesUpHoF :: Int -> [Int]
seriesUpHoF n = concat $ map (\x -> [1..x]) [1..n]
