import Data.List (find, sort)

main = readFile "aoc-2020/d5.txt" >>= print . findMissing . sort . fmap seatId . lines

findMissing ts = head [x + 1 | (x, y) <- zip ts $ tail ts, x + 1 /= y]

seatId ticket = row * 8 + col
  where
    row = bin 'B' $ take 7 ticket
    col = bin 'R' $ drop 7 ticket
    bin t =
      fst . foldr (\c (s, p) -> (if c == t then s + p else s, p * 2)) (0, 1)