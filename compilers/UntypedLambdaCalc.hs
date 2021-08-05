-- A barebones interpreter for the untyped lambda calculus.

import Text.Parsec
import Control.Monad (void)

main = do
  stdin <- getContents
  case parse parseProgram "" stdin of
    Right (defs, term) -> case toDeBruijn defs term of
      Right term -> print $ eval term
      Left msg -> putStrLn msg
    Left err -> print err

data Ast = Ast [Def] RawTerm

data Def = Def String RawTerm

data RawTerm
  = RawVar String
  | RawAbs String RawTerm
  | RawApp RawTerm RawTerm

parseProgram :: Parsec String () ([Def], RawTerm)
parseProgram = do
  defs <- many (try parseDef)
  term <- parseTerm <?> "term"
  ws
  eof
  pure (defs, term)

ws =
  void $ many (void (char '#' >> manyTill anyChar newline) <|> void space)

parseDef = do
  ws
  name <- parseId
  ws
  char '='
  term <- parseTerm
  ws
  char ';' <?> "semicolon at end of definition."
  pure $ Def name term

parseId = many1 $ oneOf $ ['a'..'z'] ++ ['A'..'Z'] ++ ['0'..'9'] ++ "<>,?/'\":[]{}|!@#$%^&*-_+"

parseTerm = do
  atom <- parseAtom
  atoms <- many parseAtom
  pure $ foldl RawApp atom atoms

parseAtom = ws >> (parseParen <|> parseVar <|> parseAbs) <* ws

parseParen = do
  char '('
  t <- parseTerm
  ws
  char ')' <?> "closing parenthesis"
  pure t

parseVar = RawVar <$> parseId
parseAbs = do
  char '\\'
  ws
  var <- parseId
  ws
  char '.'
  term <- parseTerm
  pure $ RawAbs var term

-- Terms in De Bruijn notation.
data Term
  = TermVar Int
  | TermAbs Term
  | TermApp Term Term
  deriving Eq

instance Show Term where
  show t = pp t (-1)
    where
      pp t depth = case t of
        TermVar i -> varName (depth - i)
        TermAbs t -> "(λ" ++ varName (depth + 1) ++ ". " ++ pp t (depth + 1) ++ ")"
        TermApp t1 t2 -> pp t1 depth ++ " " ++ pp t2 depth
      varName i =
        (alpha !! (i `mod` length alpha)) : replicate (i `div` length alpha) '\''
      alpha = "xyz" ++ ['a'..'w']

toDeBruijn :: [Def] -> RawTerm -> Either String Term
toDeBruijn defs term = do
    env <- collectDefs defs []
    convertTerm term env [] 0 "last term."

collectDefs :: [Def] -> [(String, Term)] -> Either String [(String, Term)]
collectDefs (Def name term : ds) env = do
  term <- convertTerm term env [] 0 ("definition of \"" ++ name ++ "\".")
  collectDefs ds ((name, term) : env)
collectDefs [] env = Right env

convertTerm :: RawTerm -> [(String, Term)] -> [(String, Int)] -> Int -> String -> Either String Term
convertTerm term env freeVars depth location = case term of
  RawVar name -> case lookup name freeVars of
    Just depth' -> Right $ TermVar (depth - depth' - 1)
    Nothing -> case lookup name env of
      Just term -> Right term
      Nothing -> Left $ "Unknown variable \"" ++ name ++ "\" in the " ++ location
  RawAbs var term ->
    TermAbs <$> convertTerm term env ((var, depth) : freeVars) (depth + 1) location
  RawApp t1 t2 -> do
    t1 <- convertTerm t1 env freeVars depth location
    t2 <- convertTerm t2 env freeVars depth location
    pure $ TermApp t1 t2

eval :: Term -> Term
eval t = case t of
  TermApp (TermAbs t1) t2 -> eval $ replace t1 t2
  TermApp t1 t2 -> eval $ TermApp (eval t1) t2
  _ -> t

replace :: Term -> Term -> Term
replace t1 t2 = replace' t1 0
  where
    replace' t depth = case t of
      TermVar i -> if i == depth then t2 else t
      TermAbs t -> TermAbs (replace' t (depth + 1))
      TermApp t1 t2 -> TermApp (replace' t1 depth) (replace' t2 depth)
