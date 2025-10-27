data TNode a = Node { left :: TNode a
                    , right :: TNode a
                    , value :: a }
             | Leaf
             deriving (Show)

-- rudementary hinsert
-- hinsert :: Ord t => t -> TNode t -> TNode t
-- hinsert v Leaf = Node Leaf Leaf v
-- hinsert v (Node l r root) = Node r (hinsert (max v root) l) (min v root)
hinsert :: Ord t => t -> TNode t -> TNode t
hinsert v Leaf = Node Leaf Leaf v
hinsert v (Node l r root) = let min' = min v root
                                max' = max v root
                            in Node r (hinsert max' l) min'

hextract :: Ord a => TNode a -> (a, TNode a)
hextract (Node l r root) = (root, combine l r)
  where
    combine Leaf r = r
    combine l Leaf = l
    combine l r
      | value l < value r = Node (combine (left l) (right l)) r (value l)
      | otherwise         = Node l (combine (left r) (right r)) (value r)


