import Data.Bits
import qualified Data.Map as M
import Data.Char (isDigit)

main = do
  is <- map parse . lines <$> readFile "aoc-2020/d14.txt"
  print $ sum (run is 0 0 M.empty :: M.Map Int Int)

parse ('m' : 'e' : 'm' : '[' : rest) = Left (read addr, read val)
  where
    (addr, _ : _ : _ : _ : val) = span isDigit rest
parse ('m' : 'a' : 's' : 'k' : _ : _ : _ : rest) = Right (mc '0' rest, mc '1' rest)
  where
    mc c' = readB . map (\c -> if c == 'X' then c' else c)
    readB s = r (reverse s) 0
    r ('0' : cs) i = r cs (i + 1)
    r ('1' : cs) i = r cs (i + 1) + 2 ^ i
    r [] _ = 0

run (Left (addr, val) : is) orMask andMask mem =
  run is orMask andMask $ M.insert addr ((val .|. orMask) .&. andMask) mem
run (Right (orMask, andMask) : is) _ _ mem = run is orMask andMask mem
run [] _ _ mem = mem
