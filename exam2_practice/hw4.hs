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

data Expr a b = Add (Expr a b) (Expr a b)
  | Sub (Expr a b) (Expr a b)
  | Mul (Expr a b) (Expr a b)
  | Pow (Expr a b) b
  | Negate (Expr a b)
  | Literal a
  | Variable String deriving (Eq, Show, Read)

type Store a = [(String, a)]
makeStore :: (Num a) => Store a
makeStore = []

writeStore :: (Num a) => String -> a -> Store a -> Store a
writeStore key v store = (key, v):store

readStore :: (Num a) => Store a -> String -> a
readStore ((key,v):t) k
  | k == key = v
  | otherwise = readStore t k

evaluate :: (Num a, Integral b) => Expr a b -> Store a -> a
evaluate (Sub e1 e2)    s = (evaluate e1 s) - (evaluate e2 s)
evaluate (Mul e1 e2)    s = (evaluate e1 s) * (evaluate e2 s)
evaluate (Pow e1 b)     s = (evaluate e1 s) ^ b
evaluate (Negate e1)    s = negate (evaluate e1 s)
evaluate (Literal a)    _ = a
evaluate (Variable str) s = readStore s str

--derive
--compile
