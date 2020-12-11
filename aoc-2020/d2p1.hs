import Text.Parsec hiding (count)

main = do
  s <- readFile "aoc-2020/d2.txt"
  print $ count valid $ map (parse p "") $ lines s

count p l = length $ filter p l

valid (Right (low, high, ch, passwd)) =
  let n = count (== ch) passwd
   in n >= low && n <= high

p :: Parsec String () (Int, Int, Char, String)
p = do
  low <- many1 digit
  char '-'
  high <- many1 digit
  char ' '
  ch <- letter
  string ": "
  passwd <- many1 letter
  pure (read low, read high, ch, passwd)
