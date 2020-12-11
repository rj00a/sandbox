main = do
  g <- mkGrid
  let counts = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
  print $ product $ map (\(r, d) -> countTrees r d g 0) counts

mkGrid :: IO [[Bool]]
mkGrid = do
  s <- readFile "aoc-2020/d3.txt"
  pure $ (map . map) (== '#') $ lines s

countTrees right down grid pos =
  case grid of
    line : _ ->
      let pos' = pos `rem` length line
       in fromEnum (line !! pos')
            + countTrees right down (drop down grid) (pos' + right)
    [] -> 0