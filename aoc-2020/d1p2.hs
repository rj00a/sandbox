import Data.List (find)

main = readFile "aoc-2020/d1.txt" >>= print . f . map read . words

f (x : xs) = case g x xs of
  Just n -> n
  Nothing -> f xs

g _ [] = Nothing
g n (x : xs) = case find (\y -> n + x + y == 2020) xs of
  Just y -> Just $ n * x * y
  Nothing -> g n xs
