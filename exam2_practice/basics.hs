--recursive fac
fac :: Int -> Int
fac 0 = 1
fac n = n * fac (n-1)

--HO fac
facL :: Int -> Int
facL 0 = 1
facL n = foldl (*) 1 [1..n]

-- simple pattern matching
and' :: Bool -> Bool -> Bool
and' True True = True
and' _    _    = False

ifThenElse :: Bool -> a -> a -> a
ifThenElse True a _ = a
ifThenElse _    _ b = b

--fib
fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

fib' :: Int -> Int
fib' n
  | n < 2     = n
  | otherwise = fib (n-1) + fib (n-2)

fib'' :: Int -> [Int]
fib'' n = [ sum $ [0..x] | x <- [0..n]]

--fmult
fmult :: Int -> Int -> Int
fmult 0 _ = 0
fmult _ 0 = 0
fmult a b
  | even a    = 2 * fmult (a `div` 2) b
  | otherwise = b + 2 * fmult ((a-1) `div` 2) b

--sumf
sumf :: (Eq a, Num a, Num b) => (a -> b) -> a -> b
sumf f 0 = 0
sumf f n = f n + sumf f (n-1)

sumf' f n = sum $ [ f x | x <- [0..n] ] 

sumf'' f n = foldl (\acc x -> acc + (f x)) 0 [1..n]
