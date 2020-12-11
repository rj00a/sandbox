import Data.Functor (($>))
import qualified Data.Map as M
import Text.Parsec

main = do
  s <- readFile "aoc-2020/d7.txt"
  let Right rules = parse (many rule) "" s
  print $ bagCount (M.fromList rules) "shiny gold"

bagCount m bag = sum $ fmap (\(bag, n) -> n + n * bagCount m bag) $ m M.! bag

rule = do
  adj1 <- wordP
  adj2 <- wordP
  wordP *> wordP
  items <- string "no other bags." $> [] <|> many1 item
  pure (adj1 ++ " " ++ adj2, items)

item = do
  n <- digit
  adj1 <- wordP
  adj2 <- wordP
  wordP
  pure (adj1 ++ " " ++ adj2, read [n] :: Int)

wordP = w *> many1 (noneOf " \n") <* w
  where
    w = optional $ oneOf " \n"
