import Text.Parsec

passportsParser = passport `sepBy` char '\n'
  where
    passport = many keyval
    keyval = do
      key <- many1 letter
      char ':'
      many1 $ noneOf " \n"
      oneOf " \n"
      pure key

main = do
  s <- readFile "aoc-2020/d4.txt"
  let (Right passports) = parse passportsParser "" s
  print $ length $ filter (== True) $ map valid passports
  where
    valid p = all (`elem` p) ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]