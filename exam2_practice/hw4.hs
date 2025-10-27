import Data.List

sdiv :: Int -> [Int]
sdiv n = [ x | x <- [1..], x `mod` n == 0 ]

-- has with no show
has :: Int -> [Int]
has n = [ x | x <- [0..], nInX n (numToDigit x) == True]

numToDigit :: Int -> [Int]
numToDigit 0 = []
numToDigit n = numToDigit (n `div` 10) ++ [n `mod` 10]

nInX :: Int -> [Int] -> Bool
nInX n [] = False
nInX n (h:t)
  | n == h = True
  | otherwise = nInX n t
-------------------------

--has with show
has' :: (Num a, Enum a, Show a) => a -> [a]
has' n = [x | x <- [0..], (head $ show n) `elem` (show x)]

cblank :: String -> Int
cblank = foldl (\acc x -> acc + fromEnum (x == ' ')) 0

consonants :: String -> String
consonants s = [c | c <- [head x | x <- (group (sort s))], not (c `elem` "aeiouyAEIOY")]

shortw t n = aux (words t) n
  where
    aux [] n = []
    aux (h:t) n = if (length h) <= n
                  then h:aux t n
                  else aux t n

shortw' t n = [x | x <- words t, length x <= n]


