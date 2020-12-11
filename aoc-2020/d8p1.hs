import Data.Array (listArray, (!))
import qualified Data.Set as S

main = do
  s <- readFile "aoc-2020/d8.txt"
  let ins = f <$> lines s
  print $ run S.empty 0 0 $ listArray (0, length ins) ins
  where
    f l = (op, n)
      where
        (op, ' ' : sign : num) = splitAt 3 l
        n = if sign == '-' then negate $ read num else read num

run visited acc ip ins
  | S.member ip visited = acc
  | otherwise = case ins ! ip of
    ("acc", n) -> run s' (acc + n) (ip + 1) ins
    ("jmp", n) -> run s' acc (ip + n) ins
    ("nop", _) -> run s' acc (ip + 1) ins
  where
    s' = S.insert ip visited
