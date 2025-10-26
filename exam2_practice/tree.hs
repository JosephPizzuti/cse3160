data Tree a = Leaf
            | Node (Tree a) a (Tree a) deriving (Eq)

instance (Show a) => Show (Tree a) where
  show Leaf = ""
  show (Node l v r) = "(" ++ show l ++ show v ++ show r ++ ")"

data Direction = L | R deriving (Show)
type Directions = [Direction]

goLeft :: (Tree a, Directions) -> (Tree a, Directions)
goLeft (Node l _ _, bcs) = (l, L:bcs)

goRight :: (Tree a, Directions) -> (Tree a, Directions)
goRight (Node _ _ r, bcs) = (r, R:bcs)

elemAt :: Directions -> Tree a -> a
elemAt []     (Node _ v _) = v
elemAt (L:ds) (Node l _ _) = elemAt ds l
elemAt (R:ds) (Node _ _ r) = elemAt ds r

change :: a -> Directions -> Tree a -> Tree a
change v [] (Node l _ r) = Node l v r
change v (L:ds) (Node l root r) = Node (change v ds l) root r
change v (R:ds) (Node l root r) = Node l root (change v ds r)

data Crumbs a = Lc a (Tree a) | Rc a (Tree a) deriving (Show)
type Breadcrumbs a = [Crumbs a]
type Zipper a = (Tree a, Breadcrumbs a)

goLeft' :: Zipper a -> Zipper a
goLeft' (Node l v r, bs) = (l, (Lc v r):bs)

goRight' :: Zipper a -> Zipper a
goRight' (Node l v r, bs) = (r, (Rc v l):bs)


