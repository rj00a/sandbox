main = do
  s <- readFile "aoc-2020/d9.txt"
  let w = findWeakness $ read <$> lines s
  print $ minimum w + maximum w

-- | Answer from part 1.
target = 258585477 :: Int

findWeakness l = case sumsTo l 0 1 of
  Just n -> take n l
  Nothing -> findWeakness $ tail l

sumsTo (x : xs) acc n
  | acc' < target = sumsTo xs acc' $ n + 1
  | acc' == target = Just n
  | otherwise = Nothing
  where
    acc' = acc + x
