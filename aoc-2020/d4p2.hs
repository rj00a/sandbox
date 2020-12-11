import Text.Parsec
import Data.Maybe (catMaybes)

data Key = Byr | Iyr | Eyr | Hgt | Hcl | Ecl | Pid | Cid
  deriving (Show, Eq)

main = readFile "aoc-2020/d4.txt" >>= print . parse numValidPassports ""

numValidPassports = countValid <$> passport `sepBy` char '\n'

passport = many $ keyval <* optional (oneOf " \n")

countValid = length . filter checkPassport

checkPassport p = all (`elem` catMaybes p) [Byr, Iyr, Eyr, Hgt, Hcl, Ecl, Pid]

keyval = do
  key <- many1 letter
  char ':'
  value <- many1 $ noneOf " \n"
  let p = case key of
        "byr" -> intRangeP 1920 2002 Byr
        "iyr" -> intRangeP 2010 2020 Iyr
        "eyr" -> intRangeP 2020 2030 Eyr
        "hgt" -> do
          h <- intP
          u <- string "cm" <|> string "in"
          eof
          let r = case u of
                "cm" -> h >= 150 && h <= 193
                "in" -> h >= 59 && h <= 76
          if r then pure Hgt else unexpected ""
        "hcl" -> char '#' *> count 6 hexDigit *> eof *> pure Hcl
        "ecl" ->
          let eyeColors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
           in choice (try . string <$> eyeColors) *> eof *> pure Ecl
        "pid" -> count 9 digit *> eof *> pure Pid
        "cid" -> pure Cid
  pure $ case parse p "" value of
    Left _ -> Nothing
    Right r -> Just r
  where
    intRangeP low high k = do
      n <- intP
      eof
      if n >= low && n <= high
        then pure k
        else unexpected ""
    intP = read <$> many1 digit
