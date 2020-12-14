import Data.Foldable (minimumBy)
import Data.Function (on)

main = do
  ls <- lines <$> readFile "aoc-2020/d13.txt"
  let depart = read $ head ls
  let ids = map read $ words $ map (\c -> if c `elem` ",x" then ' ' else c) $ ls !! 1
  let (time, id) = minimumBy (compare `on` fst) $ map (\i -> ((i - depart `rem` i) `rem` i, i)) ids
  print $ time * id
