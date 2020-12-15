import qualified Data.Map as M

input = [1, 20, 11, 6, 12, 0]

turnTarget = 30000000

main =
  print $ play (M.fromList $ zip input [1 ..]) (length input + 1) 0

-- Gives a stack overflow in ghci because laziness or whatever.
-- Works fine compiled.
play nums turn speak
  | turn == turnTarget = speak
  | otherwise = play (M.insert speak turn nums) (turn + 1) speak'
  where
    speak' = case M.lookup speak nums of
      Just t -> turn - t
      Nothing -> 0
