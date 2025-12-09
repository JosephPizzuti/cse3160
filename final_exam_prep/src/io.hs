main :: IO ()
main = do
  putStrLn "Hello world! Who are you?: "
  name <- getLine
  putStrLn $ "Hey " ++ name ++ "!"

main' :: IO ()
main' =
  putStrLn "Hello world! Who are you?" >>
  getLine >>= \name ->
  putStrLn $ "Hey " ++ name ++ "!"

mainReverse :: IO ()
mainReverse =
  myGetLine >>= \line ->
  if null line
    then return ()
    else
      (putStrLn $ reverseWords line) >>
      mainReverse

reverseWords :: String -> String
reverseWords = unwords . map reverse . words

myGetLine :: IO String
myGetLine =
  getChar >>= \c ->
  if c == '\n'
    then return []
    else
      myGetLine >>= \l ->
      return (c:l)

myPutStrLn :: String -> IO ()
myPutStrLn [] =
  putChar '\n' >>
  return ()
myPutStrLn (x:xs) =
  putChar x >>
  myPutStrLn xs

sequence' :: (Traversable t, Monad m) => t (m a) -> m (t a)
sequence' = traverse id
