import Data.Array (listArray, (!))
import qualified Data.Set as S

main = do
  s <- readFile "aoc-2020/d8.txt"
  let ins = f <$> lines s
  let len = length ins
  print $ runAll S.empty 0 0 len $ listArray (0, len) ins
  where
    f l = (op, n)
      where
        (op, ' ' : sign : num) = splitAt 3 l
        n = if sign == '-' then negate $ read num else read num

-- | Execute the program as normal. When an acc or jmp instruction is
-- encountered, execute the changed instruction in a separate branch. If the
-- branch terminates, then we're done.
runAll visited acc ip len ins =
  case ins ! ip of
    ("acc", n) -> runAll s' (acc + n) (ip + 1) len ins
    ("jmp", n) -> case run s' acc (ip + 1) len ins of
      Just acc -> acc
      Nothing -> runAll s' acc (ip + n) len ins
    ("nop", n) -> case run s' acc (ip + n) len ins of
      Just acc -> acc
      Nothing -> runAll s' acc (ip + 1) len ins
  where
    s' = S.insert ip visited

run visited acc ip len ins
  | S.member ip visited = Nothing
  | ip == len = Just acc
  | otherwise = case ins ! ip of
    ("acc", n) -> run s' (acc + n) (ip + 1) len ins
    ("jmp", n) -> run s' acc (ip + n) len ins
    ("nop", _) -> run s' acc (ip + 1) len ins
  where
    s' = S.insert ip visited
