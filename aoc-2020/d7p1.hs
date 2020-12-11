import Data.Functor (($>))
import Data.List (mapAccumL)
import qualified Data.Map as M
import qualified Data.Set as S
import Text.Parsec

main = do
  s <- readFile "aoc-2020/d7.txt"
  let Right rules = parse (many rule) "" s
  print $ pred $ length $ filter (hasShinyGold $ M.fromList rules) $ map fst rules
--print $ shinyGoldNum (M.fromList rules)

-- |Slow solution
hasShinyGold m name = name == "shiny gold" || any (hasShinyGold m) (m M.! name)

-- |Faster solution with caching
--shinyGoldNum m = pred $ length $ filter id $ snd $ checkRule m S.empty ("", M.keys m)
--
--checkRule m s (name, contains) = mapAccumL f s contains
--  where
--    f s bag
--      | bag == "shiny gold" || S.member bag s = (S.insert name s, True)
--      | otherwise = mapSnd or $ checkRule m s (bag, m M.! bag)
--
--mapSnd f (l, r) = (l, f r)

rule = do
  adj1 <- wordP
  adj2 <- wordP
  wordP *> wordP
  items <- string "no other bags." $> [] <|> many1 item
  pure (adj1 ++ " " ++ adj2, items)

item = do
  digit
  adj1 <- wordP
  adj2 <- wordP
  wordP
  pure $ adj1 ++ " " ++ adj2

wordP = w *> many1 (noneOf " \n") <* w
  where
    w = optional $ oneOf " \n"
