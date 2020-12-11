main = readFile "aoc-2020/d9.txt" >>= print . findBad . map read . lines

findBad list
  | twoSum pre target = findBad $ tail list
  | otherwise = target
  where
    (pre, target : _) = splitAt 26 list

twoSum (x : xs) target
  | (target - x) `elem` xs = True
  | otherwise = twoSum xs target
twoSum [] _ = False
