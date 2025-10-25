-- seriesUp: recursive, list comp., higher order
seriesUp :: Int -> [Int]
seriesUp 0 = []
seriesUp n = seriesUp (n-1) ++ [1..n]

seriesUp' :: Int -> [Int]
seriesUp' n = concat $ [ [1..x] | x <- [1..n] ]

seriesUp'' :: Int -> [Int]
seriesUp'' n = foldl (\acc x -> acc ++ [1..x]) [] [1..n]

-- ssort design 1 (inefficient)
selectionSort :: (Ord a, Eq a) => [a] -> [a]
selectionSort []  = []
selectionSort [a] = [a]
selectionSort l   = minList ++ selectionSort leftover
  where
    min = minimum l
    minList = filter (\x -> x == min) l
    leftover = filter (\x -> x /= min) l

-- ssort deisgn 2 (faster + adaptable w/ single change)
ssort :: (Ord a, Eq a) => [a] -> [a]
ssort [] = []
ssort l  = s : ssort (remove s l)
  where
    s = minimum l
    remove _ [] = []
    remove v (h:t)
      | v == h    = t
      | otherwise = h : remove v t

-- isort design 1 (works fine)
isort :: (Ord a) => [a] -> [a]
isort l  = aux l []
  where
    aux [] acc = acc
    aux (h:t) acc = aux t (sortin h acc)

sortin v [] = [v]
sortin v (h:t)
  | v <= h = v:(h:t)
  | otherwise = h:sortin v t

-- isort design 2 (less code w/ fold)
isort' :: Ord a => [a] -> [a]
isort' = foldr insert' []
  where
    insert' v [] = [v]
    insert' v (h:t)
      | v <= h = v : (h:t)
      | otherwise = h : insert' v t

-- the only merge sort
msort []   = []
msort [x]  = [x]
msort list = merge (msort l) (msort r)
  where
    half = (length list) `div` 2
    l    = take half list
    r    = drop half list

merge rt [] = rt
merge [] lt = lt
merge (r:rt) (l:lt)
  | r <= l    = r : merge rt (l:lt)
  | otherwise = l : merge (r:rt) lt
