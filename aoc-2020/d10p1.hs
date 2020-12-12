import Data.List (sort)

main = do
  s <- readFile "aoc-2020/d10_test.txt"
  let jolts = (0 :) $ sort $ read <$> lines s
  let diffs = zipWith (-) (tail jolts) jolts
  print $ count (== 1) diffs * (count (== 3) diffs + 1)

count p = length . filter p