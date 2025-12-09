type Stack = [Int]

newtype State s a = State { runState :: s -> (a,s) }

instance Functor (State s) where
  fmap f (State g) = State $ \s -> let (v,s2) = g s
                                   in (f v, s2)

instance Applicative (State s) where
  pure x = State $ \s -> (x,s) 
  State f <*> State g = State $ \s -> let (f1,s2) = f s
                                          (v1,s3) = g s2
                                      in (f1 v1, s3)

instance Monad (State s) where
  return = pure
  State h >>= f = State $ \initS -> let (v, newState) = h initS
                                        (State g) = f v
                                    in  g newState

state f = State f
put newS = state $ \s -> ((), newS)
get = State $ \s -> (s,s)

evalState :: State s a -> s -> a
evalState m s = fst (runState m s)

execState m s = snd (runState m s)

modify u = State $ \s -> ((), u s)

modify' u = State $ \s -> let ns = u s
                          in (ns,ns)

push' v = state $ \xs -> ((), v:xs)
pop' = state $ \(x:xs) -> (x, xs)
removeSnd' = do
  top <- pop'
  sec <- pop'
  push' top
  return sec
                                         
newStack :: Stack
newStack = []

onlyTop =
  pop' >>= \top ->
  put newStack >>
  push' top

push :: Int -> Stack -> ((), Stack)
push v xs = ((), v:xs)

pop :: Stack -> (Int, Stack)
pop (x:xs) = (x, xs)

removeSnd :: Stack -> (Int, Stack)
removeSnd s = let (top, s1) = pop s
                  (sec, s2) = pop s1
                  (_,   s3) = push top s2
              in (sec, s3)
