data Queue a = Queue { front :: [a]
                     , rear  :: [a]
                     , size  :: Int
                     }
                     deriving (Show)

emptyQ :: Queue a
emptyQ = Queue [] [] 0

enqueue :: a -> Queue a -> Queue a
enqueue k (Queue f [] s) = Queue f [k] (s+1)
enqueue k (Queue [] r s) = Queue (reverse (k:r)) [] (s+1)
enqueue k (Queue f r s)  = Queue f (k:r) (s+1)

dequeue :: Queue a -> Maybe (a, Queue a)
dequeue (Queue [] [] _) = Nothing
dequeue (Queue (h:t) r s) = Just (h, (Queue t r (s-1)))
dequeue (Queue [] r s) =
  case reverse r of
    []    -> Nothing
    (h:t) -> Just (h, Queue t [] (s-1))


                           

