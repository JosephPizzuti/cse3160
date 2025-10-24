{-# LANGUAGE ParallelListComp #-}
length' :: [a] -> Int
length' = foldl (\acc x -> acc + 1) 0

head' :: [a] -> a
head' []    = error "Cannot take head of empty list"
head' [a]   = a
head' (h:t) = h

tail' :: [a] -> [a]
tail' (h:t) = t

lastEle :: [a] -> Maybe a
lastEle []    = Nothing
lastEle [a]   = Just a
lastEle (h:t) = lastEle t

null' :: [a] -> Bool
null' [] = True
null' _  = False

consOp :: a -> [a] -> [a]
consOp c l = [c] ++ l

zipWith' :: (a -> a -> a) -> [a] -> [a] -> [a]
zipWith' f l1 l2 = [ f x y | x <- l1 | y <- l2]

map' :: (a -> a) -> [a] -> [a]
map' f l = [f x | x <- l]

filter' :: (a -> Bool) -> [a] -> [a]
filter' f l = [x | x <- l, (f x) == True]

fivePal :: String -> Bool
fivePal s = take 5 s == reverse (take 5 s)

