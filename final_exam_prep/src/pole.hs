import Control.Monad

type Birds = Int
type Pole = (Birds, Birds)

--landLeft :: Birds -> Pole -> Pole
--landLeft n (left,right) = (left + n, right)

--landRight :: Birds -> Pole -> Pole
--landRight n (left,right) = (left, right + n)


landLeft :: Birds -> Pole -> Maybe Pole
landLeft n (l,r)
  | abs ((l + n) - r) < 4 = Just (l + n, r)
  | otherwise             = Nothing

landRight :: Birds -> Pole -> Maybe Pole
landRight n (l,r)
  | abs ((r + n) - l) < 4 = Just (l, r + n)
  | otherwise             = Nothing

foo :: Maybe String
foo = do
  x <- Just 3
  y <- Just "!"
  Just (show x ++ y)

foo' :: Maybe String
foo' =
  Just 3 >>= (\x ->
  Just "!" >>= (\y ->
  Just (show x ++ y)))

punctuation v = do
  let punct = "!"
  x <- return v
  y <- Just punct
  return (show x ++ y)

punctuation' v =
  let punct = "!"
  in return v >>= (\x ->
     Just punct >>= (\y ->
     return (show x ++ y)))

justH :: Maybe Char
justH = do
  (x:xs) <- Just "hello"
  return x

justH' =
  Just "hello" >>= (\(x:xs) ->
  return x)

hoo :: [(Int, Int)]
hoo = do
  x <- [1..3]
  y <- [4..6]
  return (-x,y)

hoo' :: [(Int,Int)]
hoo' =
  [1..3] >>= (\x ->
  [4..6] >>= (\y ->
  return (-x,y)))

hoo'' =
  [1..3] >>= \x ->
  [4..6] >>= \y ->
  return (-x,y)

fun1 u = do
  x <- [1..u]
  if '7' `elem` show x
    then return x
    else []

fun1' u =
  [1..u] >>= \x ->
  if '7' `elem` show x
    then return x
    else []

fun2 u = do
  x <- [1..u]
  guard ('7' `elem` show x)
  return x

fun2' u =
  [1..u] >>= \x ->
  guard ('7' `elem` show x) >>
  return x
