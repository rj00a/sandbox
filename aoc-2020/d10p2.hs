{-# LANGUAGE LambdaCase #-}

import Data.List (sort)

main = do
  s <- readFile "aoc-2020/d10.txt"
  let jolts = (0 :) $ sort $ read <$> lines s
  let diffs = zipWith (-) (tail jolts) jolts
  print $ arrangements diffs

arrangements = \case
  1 : 1 : 1 : 1 : l -> arrangements l * 7
  1 : 1 : 1 : l -> arrangements l * 4
  1 : 1 : l -> arrangements l * 2
  _ : l -> arrangements l
  [] -> 1
