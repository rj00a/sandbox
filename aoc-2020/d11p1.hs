import qualified Data.Array as A

main = do
  chars <- filter (/= '\n') <$> readFile "aoc-2020/d11.txt" 
  let len = length chars
  let states = iterate (nextState len) $ A.listArray (0, len - 1) chars
  let stable = head [prev | (prev, next) <- zip states $ tail states, prev == next]
  print $ length $ filter (== '#') $ A.elems stable

nextState len old = A.listArray (0, len - 1) $ map f grid
  where
    f (row, col)
      | this == 'L' && adj == 0 = '#'
      | this == '#' && adj >= 4 = 'L'
      | otherwise = this
      where
        this = lookup row col
        adj = length $ filter (== '#') $ (\(r, c) -> lookup (row + r) (col + c)) <$> offsets
        offsets = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
    lookup row col
      | row >= n || row < 0 || col >= n || col < 0 = '.'
      | otherwise = old A.! (row * n + col)
    grid = do
      row <- [0 .. n - 1]
      col <- [0 .. n - 1]
      pure (row, col)
    n = round $ sqrt $ fromIntegral len
