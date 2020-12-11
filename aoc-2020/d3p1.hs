
main = readFile "aoc-2020/d3.txt" >>= print . countTrees 0 . mkGrid

mkGrid = (map . map) (== '#') . lines

countTrees _ [] = 0
countTrees pos (l:ls) =
  fromEnum (l !! pos') + countTrees (pos' + 3) ls
  where pos' = pos `rem` length l