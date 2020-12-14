main = do
  s <- readFile "aoc-2020/d12.txt"
  let as = (\s -> (head s, read $ tail s)) <$> lines s
  let (x, y) = navigate as 0 0 90
  print $ abs x + abs y

navigate ((a, v) : as) x y d
  | a == 'N' || a == 'F' && d == 0 = navigate as x (y + v) d
  | a == 'S' || a == 'F' && d == 180 = navigate as x (y - v) d
  | a == 'E' || a == 'F' && d == 90 = navigate as (x + v) y d
  | a == 'W' || a == 'F' && d == 270 = navigate as (x - v) y d
  | a == 'L' = navigate as x y ((d - v) `mod` 360)
  | a == 'R' = navigate as x y ((d + v) `rem` 360)
navigate [] x y _ = (x, y)

{- Before I bothered to read the instructions properly:
navigate ((i, v) : is) x y xns yns xew yew
  | i == 'N' = navigate is (x + v * xns) (y + v * yns) xns yns xew yew
  | i == 'S' = navigate is (x + v * negate xns) (y + v * negate yns) xns yns xew yew
  | i == 'E' = navigate is (x + v * xew) (y + v * yew) xns yns xew yew
  | i == 'W' = navigate is (x + v * negate xew) (y + v * negate yew) xns yns xew yew
  | i == 'R' && v == 90 || i == 'L' && v == 270 = navigate is x y yns (negate xns) yew (negate xew)
  | v == 180 = navigate is x y (negate xns) (negate yns) (negate xew) (negate yew)
  | i == 'R' && v == 270 || i == 'L' && v == 90 = navigate is x y (negate yns) xns (negate yew) xew
navigate [] x y _ _ _ _ = (x, y)
-}
