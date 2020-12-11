twoSum2020 (x : xs)
  | (2020 - x) `elem` xs = x * (2020 - x)
  | otherwise = twoSum2020 xs

main = readFile "aoc-2020/d1.txt" >>= print . twoSum2020 . map read . words
