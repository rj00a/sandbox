import Data.Char (isDigit)
import qualified Data.Map as M
import Text.Printf (printf)

main = do
  is <- map parse . lines <$> readFile "aoc-2020/d14.txt"
  print $ sum $ run is "" M.empty

parse ('m' : 'e' : 'm' : '[' : rest) = Left (read addr, read val)
  where
    (addr, ']' : ' ' : '=' : ' ' : val) = span isDigit rest
parse ('m' : 'a' : 's' : 'k' : ' ' : '=' : ' ' : mask) = Right mask

run (Left (addr, val) : is) mask mem =
  run is mask $ foldl f mem $ everyAddr addrBin mask
  where
    f m a = M.insert a val m
    addrBin = printf "%b" (addr :: Int) :: String
run ((Right mask) : is) _ mem = run is mask mem
run [] _ mem = mem

everyAddr addr mask =
  readB 0 <$> everyAddr' (reverse addr) (reverse mask)
  where
    readB i ('0' : cs) = readB (i + 1) cs
    readB i ('1' : cs) = readB (i + 1) cs + 2 ^ i
    readB _ [] = 0
    everyAddr' addr mask = case (addr, mask) of
      (_ : as, 'X' : ms) -> split $ everyAddr' as ms
      (_ : as, '1' : ms) -> put '1' $ everyAddr' as ms
      (a : as, '0' : ms) -> put a $ everyAddr' as ms
      ([], 'X' : ms) -> split $ everyAddr' [] ms
      ([], m : ms) -> put m $ everyAddr' [] ms
      (a : as, []) -> put a $ everyAddr' as []
      ([], []) -> []
    put c [] = [[c]]
    put c xs = (c :) <$> xs
    split l = put '0' l `prepend` put '1' l
    prepend (x : xs) ys = x : prepend xs ys
    prepend [] ys = ys
