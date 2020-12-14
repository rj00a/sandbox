main = do
  s <- readFile "aoc-2020/d12.txt"
  let as = (\s -> (head s, read $ tail s)) <$> lines s
  let (x, y) = navigate as 0 0 10 1
  print $ abs x + abs y

navigate ((a, v) : as) sx sy wx wy
  | a == 'N' = navigate as sx sy wx (wy + v)
  | a == 'E' = navigate as sx sy (wx + v) wy
  | a == 'S' = navigate as sx sy wx (wy - v)
  | a == 'W' = navigate as sx sy (wx - v) wy
  | a == 'F' = navigate as (sx + wx * v) (sy + wy * v) wx wy
  | a == 'R' && v == 90 || a == 'L' && v == 270 =
    navigate as sx sy wy (negate wx)
  | a == 'L' && v == 90 || a == 'R' && v == 270 =
    navigate as sx sy (negate wy) wx
  | a `elem` "LR" && v == 180 =
    navigate as sx sy (negate wx) (negate wy)
navigate [] sx sy _ _ = (sx, sy)
