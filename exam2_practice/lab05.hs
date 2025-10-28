data TNode a = Node (TNode a) (TNode a) a | Leaf deriving (Show)

tinsert :: (Ord a) => a -> TNode a -> TNode a
tinsert k Leaf = Node Leaf Leaf k
tinsert k (Node l r root)
  | k == root = Node l r root
  | k < root  = Node (tinsert k l) r root
  | otherwise = Node l (tinsert k r) root

tflist :: (Ord a) => [a] -> TNode a
tflist = foldl (\acc x -> (flip tinsert) acc x) Leaf

tfold :: (p -> p -> a -> p) -> p -> TNode a -> p
tfold f acc Leaf            = acc
tfold f acc (Node l r root) = f (tfold f acc l) (tfold f acc r) root

inorder :: TNode a -> [a]
inorder Leaf = []
inorder (Node l r root) = inorder l ++ [root] ++ inorder r

preorder :: TNode a -> [a]
preorder Leaf = []
preorder (Node l r root) = [root] ++ preorder l ++ preorder r

postorder :: TNode a -> [a]
postorder Leaf = []
postorder (Node l r root) = postorder l ++ postorder r ++ [root]

inorder' :: TNode a -> [a]
inorder' = tfold (\l r root -> l ++ [root] ++ r) []

preorder' :: TNode a -> [a]
preorder' = tfold (\l r root -> [root] ++ l ++ r) []

postorder' :: TNode a -> [a]
postorder' = tfold (\l r root -> l ++ r ++ [root]) []

treemap :: (a -> b) -> TNode a -> TNode b
treemap _ Leaf = Leaf
treemap f (Node l r root) = Node (treemap f l) (treemap f r) (f root)

treemap' :: (a -> b) -> TNode a -> TNode b
treemap' f = tfold (\l r root -> Node l r (f root)) Leaf

-- ghci does not like numeric type for this; requires something specific
-- that adheres to bounded. so we choose int for simplicity
bstmax :: TNode Int -> Int
bstmax t = aux t minBound
  where
    aux Leaf maxv = maxv
    aux (Node l r root) maxv
      | root > maxv = aux r root
      | otherwise   = aux r maxv

bstmax' :: TNode Int -> Int
bstmax' = tfold (\l r root -> max root r) minBound

-- attempt 1, slow approach with inorder
bstfloor :: (Num a, Ord a) => a -> TNode a -> Maybe a
bstfloor k Leaf = Nothing
bstfloor k t = aux k (inorder t) False 0
  where
    aux k [] False _ = Nothing
    aux k [] True val = Just val
    aux k (h:t) cond val 
      | h < k && h > val = aux k t True h
      | otherwise        = aux k t cond val

-- attempt 2, sticking to trees and bst property
bstfloor' :: (Num a, Ord a) => a -> TNode a -> Maybe a
bstfloor' k Leaf = Nothing
bstfloor' k (Node l r root)
  | root == k = Just root
  | root > k  = bstfloor' k l
  | root < k  = case bstfloor' k r of
                  Just res -> Just res
                  Nothing  -> Just root

-- note the root == k line is optional but it makes it a lot more clear
-- that we know how to handle that case
-- The otherwise covers it naturally but is not intuitive to right step by step
bstfloorFold :: (Ord a) => a -> TNode a -> Maybe a
bstfloorFold k = tfold aux Nothing
  where
    aux l r root
      | root == k = Just root
      | root > k  = l
      | otherwise = case r of
                    Just x  -> Just x
                    Nothing -> Just root
