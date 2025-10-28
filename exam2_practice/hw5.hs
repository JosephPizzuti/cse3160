import Data.Char
import Data.List

data Tree a = Leaf | Node (Tree a) a (Tree a) deriving (Eq)

instance (Show a) => Show(Tree a) where 
    show Leaf = ""
    show (Node l v r) = "(" ++ show l ++ show v ++ show r ++ ")"

mergesort :: Ord a => [a] -> [a]
mergesort [] = []
mergesort [x] = [x]
mergesort l  = merge (mergesort left) (mergesort right) 
  where
    half = length l `div` 2
    left = take half l
    right = drop half l
    merge [] r = r
    merge l [] = l
    merge (lh:lt) (rh:rt)
      | lh < rh = lh : merge lt (rh:rt)
      | otherwise = rh : merge (lh:lt) rt

--
--remove :: Ord a => Tree a -> a -> Tree a
--remove Leaf k = Leaf
--remove (Node l root r) k
--  | root < k = Node l root (remove r k)
--  | root > k = Node (remove l k) root r
--  | otherwise = case (Node l r root) of 
----                 l root 
--

type Breadcrumbs a = [a]
type Zipper a = ([a], Breadcrumbs a)

zipperList l = (l,[])

zinsert :: Ord a => a -> Zipper a -> Zipper a
zinsert k ([],[]) = ([k],[])
zinsert k ([],(y:ys))
    | k >= y    = ([k], y:ys)
    | otherwise = zinsert k ([y],ys)
zinsert k ((x:xs),[])
    | k <= x    = (k:x:xs, [])
    | otherwise = zinsert k (xs,[x])
zinsert k ((x:xs),(y:ys))
    | k <= x && k >= y = (k:x:xs, y:ys)
    | k <= x = zinsert k (y:x:xs, ys)
    | k > x  = zinsert k (xs, x:y:ys)

theList :: Ord a => Zipper a -> [a]
theList (l,[]) = l
theList (l,(c:bs)) = theList (c:l,bs)

iSort :: Ord a => [a] -> [a]
iSort [] = []
iSort l = theList (aux l)
  where
    aux [] = ([], [])
    aux (h:t) = zinsert h (aux t)
