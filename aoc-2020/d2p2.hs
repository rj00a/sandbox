import Text.Parsec hiding (count)

main = do
  s <- readFile "aoc-2020/d2.txt"
  print $ count valid $ map (parse p "") $ lines s

count p l = length $ filter p l

valid (Right (pos1, pos2, ch, passwd)) =
  (passwd !! (pos1 - 1) == ch) /= (passwd !! (pos2 - 1) == ch)

p :: Parsec String () (Int, Int, Char, String)
p = do
  pos1 <- many1 digit
  char '-'
  pos2 <- many1 digit
  char ' '
  ch <- letter
  string ": "
  passwd <- many1 letter
  pure (read pos1, read pos2, ch, passwd)
