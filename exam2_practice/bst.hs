data TNode a = Node { left :: TNode a
                    , right :: TNode a
                    , value :: a }
             | Leaf
             deriving (Show)

tmember :: (Ord a) => a -> TNode a -> Bool
tmember _ Leaf = False
tmember k (Node l r v)
  | k == v = True
  | k < v  = tmember k l
  | k > v  = tmember k r

tinsert :: (Ord a) => a -> TNode a -> TNode a
tinsert k Leaf = Node Leaf Leaf k
tinsert k (Node l r v)
  | k == v = Node l r v
  | k < v  = Node (tinsert k l) r v
  | k > v  = Node l (tinsert k r) v

--Note that we flip because foldl is typically \acc x -> ...,
--So we need to make it so tinsert takes values as tree v
--instead of v tree for this to work
tflist :: (Ord a) => [a] -> TNode a
tflist = foldl (flip tinsert) Leaf

listft :: (Ord a) => TNode a -> [a]
listft Leaf = []
--listft (Node l r v) = (listft l) ++ [v] ++ (listft r)
-- can save on an append operation here
listft (Node l r v) = listft l ++ (v:listft r)

tsize :: (Ord a) => TNode a -> Int
tsize Leaf = 0
tsize (Node l r _) = 1 + (tsize l) + (tsize r)

theight :: (Ord a) => TNode a -> Int
theight Leaf = 0
theight (Node l r _) = 1 + max (theight l) (theight r)

-- relies on single accumulator so is naive, cant handle things like theight
tfoldi :: (p -> a -> p) -> p -> TNode a -> p
tfoldi f acc Leaf = acc
tfoldi f acc (Node l r v) = let leftAcc = tfoldi f acc l
                                newAcc  = f leftAcc v
                            in tfoldi f newAcc r

tfoldi' :: (p -> p -> a -> p) -> p -> TNode a -> p
tfoldi' f acc Leaf = acc
tfoldi' f acc (Node l r v) = let leftAcc = tfoldi' f acc l
                                 rightAcc = tfoldi' f acc r
                             in f leftAcc rightAcc v

bstmax :: (Ord a) => TNode a -> Maybe a
bstmax Leaf            = Nothing
bstmax (Node _ Leaf v) = Just v
bstmax (Node _ r _)    = bstmax r

