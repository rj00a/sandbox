import qualified Data.Set as S

splitLnLn = f []
  where
    f r ('\n' : '\n' : cs) = reverse r : f [] cs
    f r (c : cs) = f (c : r) cs
    f r [] = [reverse r]

main =
  readFile "aoc-2020/d6.txt"
    >>= print . sum . map (S.size . S.fromList . filter (/= '\n')) . splitLnLn
