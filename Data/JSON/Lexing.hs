module  Data.JSON.Lexing  where

import           Prelude
  hiding (lex)
import qualified Control.Applicative as Applicative
import qualified Control.Monad       as Monad
import qualified Control.Monad.Trans as MonadTrans
import qualified Data.Char           as Char


import qualified Data.Char         as Char
import qualified Data.JSON.Parsing as Parsing

newtype Lexing m a = Lexing { unLexing :: LexingState -> m (a, LexingState) }

data LexingState =
    Initial
  deriving (Eq, Ord, Read, Show)

data SemanticActions m a = SemanticActions
  { saWS :: String -> Lexing m a
  , saFalse :: String -> Lexing m a
  , saNull :: String -> Lexing m a
  , saTrue :: String -> Lexing m a
  , saLBrace :: String -> Lexing m a
  , saRBrace :: String -> Lexing m a
  , saComma :: String -> Lexing m a
  , saColon :: String -> Lexing m a
  , saLBracket :: String -> Lexing m a
  , saRBracket :: String -> Lexing m a
  , saNumber :: String -> Lexing m a
  , saString :: String -> Lexing m a }

instance Monad m => Functor (Lexing m) where
  fmap = Monad.liftM

instance Monad m => Applicative.Applicative (Lexing m) where
  pure = return
  (<*>) = Monad.ap

instance Monad m => Monad (Lexing m) where
  return x = Lexing $ \s -> return (x, s)
  Lexing f >>= k = Lexing $ \s -> do
    (x, s') <- f s
    unLexing (k x) s'

instance MonadTrans.MonadTrans Lexing where
  lift m = Lexing $ \s -> do { x <- m; return (x, s) }

runLexing :: Monad m => Lexing m a -> m a
runLexing = Monad.liftM fst . flip unLexing Initial

yybegin :: Monad m => LexingState -> Lexing m ()
yybegin s = Lexing $ const $ return ((), s)

dfaInitialInitialState :: Int
dfaInitialInitialState = 1

dfaInitialFinalStates :: [Int]
dfaInitialFinalStates = [2,3,6,7,11,13,19,23,27,28,33,34,35,36,37,39,41,42,44,46,50,51,52,54]

dfaInitialTransition :: Int -> Char -> Int
dfaInitialTransition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          34 -> 3
          43 -> 4
          44 -> 5
          45 -> 6
          46 -> 7
          47 -> 8
          48 -> 9
          58 -> 11
          69 -> 13
          91 -> 14
          92 -> 15
          93 -> 16
          97 -> 17
          98 -> 18
          101 -> 20
          102 -> 21
          108 -> 22
          110 -> 23
          114 -> 24
          115 -> 25
          116 -> 26
          117 -> 27
          123 -> 28
          125 -> 29
          c'' ->
            if any (\(c1, c2) -> c1 <= c'' && c'' <= c2) [(0,8),(11,11),(14,31),(33,33),(35,42),(59,64),(71,90),(94,96),(103,107),(109,109),(111,113),(118,122),(124,124),(126,1114111)] then 1
            else if any (\(c1, c2) -> c1 <= c'' && c'' <= c2) [(9,10),(12,13),(32,32)] then 2
            else if 49 <= c'' && c'' <= 57 then 10
            else if any (\(c1, c2) -> c1 <= c'' && c'' <= c2) [(65,68),(70,70)] then 12
            else if 99 <= c'' && c'' <= 100 then 19
            else 0 in
    case (q, c') of
      (1, 0) -> 2
      (1, 2) -> 3
      (1, 3) -> 4
      (1, 5) -> 3
      (1, 6) -> 5
      (1, 9) -> 6
      (1, 10) -> 7
      (1, 11) -> 3
      (1, 14) -> 3
      (1, 16) -> 3
      (1, 21) -> 8
      (1, 23) -> 9
      (1, 26) -> 10
      (1, 28) -> 3
      (1, 29) -> 3
      (2, 0) -> 11
      (2, 1) -> 4
      (2, 2) -> 4
      (2, 3) -> 3
      (2, 4) -> 4
      (2, 5) -> 4
      (2, 6) -> 4
      (2, 7) -> 12
      (2, 8) -> 4
      (2, 9) -> 13
      (2, 10) -> 13
      (2, 11) -> 4
      (2, 12) -> 4
      (2, 13) -> 14
      (2, 14) -> 4
      (2, 15) -> 15
      (2, 16) -> 4
      (2, 17) -> 16
      (2, 18) -> 4
      (2, 19) -> 4
      (2, 20) -> 14
      (2, 21) -> 4
      (2, 22) -> 4
      (2, 23) -> 4
      (2, 24) -> 17
      (2, 25) -> 4
      (2, 26) -> 4
      (2, 27) -> 18
      (2, 28) -> 4
      (2, 29) -> 4
      (4, 0) -> 19
      (4, 1) -> 4
      (4, 2) -> 4
      (4, 3) -> 3
      (4, 4) -> 4
      (4, 5) -> 4
      (4, 6) -> 4
      (4, 7) -> 4
      (4, 8) -> 4
      (4, 9) -> 4
      (4, 10) -> 4
      (4, 11) -> 4
      (4, 12) -> 4
      (4, 13) -> 4
      (4, 14) -> 4
      (4, 15) -> 15
      (4, 16) -> 4
      (4, 17) -> 4
      (4, 18) -> 4
      (4, 19) -> 4
      (4, 20) -> 4
      (4, 21) -> 4
      (4, 22) -> 4
      (4, 23) -> 4
      (4, 24) -> 4
      (4, 25) -> 4
      (4, 26) -> 4
      (4, 27) -> 4
      (4, 28) -> 4
      (4, 29) -> 4
      (5, 0) -> 7
      (5, 9) -> 6
      (5, 10) -> 7
      (6, 0) -> 20
      (6, 7) -> 21
      (6, 13) -> 22
      (6, 20) -> 22
      (7, 0) -> 23
      (7, 7) -> 21
      (7, 9) -> 7
      (7, 10) -> 7
      (7, 13) -> 22
      (7, 20) -> 22
      (8, 0) -> 24
      (8, 17) -> 24
      (9, 0) -> 25
      (9, 27) -> 25
      (10, 0) -> 26
      (10, 24) -> 26
      (11, 0) -> 27
      (11, 1) -> 4
      (11, 2) -> 4
      (11, 3) -> 28
      (11, 4) -> 29
      (11, 5) -> 4
      (11, 6) -> 29
      (11, 7) -> 12
      (11, 8) -> 4
      (11, 9) -> 13
      (11, 10) -> 13
      (11, 11) -> 4
      (11, 12) -> 4
      (11, 13) -> 14
      (11, 14) -> 4
      (11, 15) -> 30
      (11, 16) -> 4
      (11, 17) -> 4
      (11, 18) -> 4
      (11, 19) -> 4
      (11, 20) -> 14
      (11, 21) -> 4
      (11, 22) -> 31
      (11, 23) -> 4
      (11, 24) -> 4
      (11, 25) -> 4
      (11, 26) -> 4
      (11, 27) -> 32
      (11, 28) -> 4
      (11, 29) -> 4
      (12, 0) -> 33
      (12, 1) -> 4
      (12, 2) -> 4
      (12, 3) -> 3
      (12, 4) -> 4
      (12, 5) -> 4
      (12, 6) -> 4
      (12, 7) -> 4
      (12, 8) -> 4
      (12, 9) -> 34
      (12, 10) -> 34
      (12, 11) -> 4
      (12, 12) -> 4
      (12, 13) -> 4
      (12, 14) -> 4
      (12, 15) -> 15
      (12, 16) -> 4
      (12, 17) -> 4
      (12, 18) -> 4
      (12, 19) -> 4
      (12, 20) -> 4
      (12, 21) -> 4
      (12, 22) -> 4
      (12, 23) -> 4
      (12, 24) -> 4
      (12, 25) -> 4
      (12, 26) -> 4
      (12, 27) -> 4
      (12, 28) -> 4
      (12, 29) -> 4
      (13, 0) -> 35
      (13, 1) -> 4
      (13, 2) -> 4
      (13, 3) -> 3
      (13, 4) -> 4
      (13, 5) -> 4
      (13, 6) -> 4
      (13, 7) -> 12
      (13, 8) -> 4
      (13, 9) -> 13
      (13, 10) -> 13
      (13, 11) -> 4
      (13, 12) -> 4
      (13, 13) -> 14
      (13, 14) -> 4
      (13, 15) -> 15
      (13, 16) -> 4
      (13, 17) -> 4
      (13, 18) -> 4
      (13, 19) -> 4
      (13, 20) -> 14
      (13, 21) -> 4
      (13, 22) -> 4
      (13, 23) -> 4
      (13, 24) -> 4
      (13, 25) -> 4
      (13, 26) -> 4
      (13, 27) -> 4
      (13, 28) -> 4
      (13, 29) -> 4
      (14, 0) -> 36
      (14, 1) -> 4
      (14, 2) -> 4
      (14, 3) -> 3
      (14, 4) -> 29
      (14, 5) -> 4
      (14, 6) -> 29
      (14, 7) -> 4
      (14, 8) -> 4
      (14, 9) -> 37
      (14, 10) -> 37
      (14, 11) -> 4
      (14, 12) -> 4
      (14, 13) -> 4
      (14, 14) -> 4
      (14, 15) -> 15
      (14, 16) -> 4
      (14, 17) -> 4
      (14, 18) -> 4
      (14, 19) -> 4
      (14, 20) -> 4
      (14, 21) -> 4
      (14, 22) -> 4
      (14, 23) -> 4
      (14, 24) -> 4
      (14, 25) -> 4
      (14, 26) -> 4
      (14, 27) -> 4
      (14, 28) -> 4
      (14, 29) -> 4
      (15, 0) -> 4
      (15, 3) -> 4
      (15, 8) -> 4
      (15, 15) -> 4
      (15, 18) -> 4
      (15, 21) -> 4
      (15, 23) -> 4
      (15, 24) -> 4
      (15, 26) -> 4
      (15, 27) -> 38
      (16, 0) -> 39
      (16, 1) -> 4
      (16, 2) -> 4
      (16, 3) -> 3
      (16, 4) -> 4
      (16, 5) -> 4
      (16, 6) -> 4
      (16, 7) -> 4
      (16, 8) -> 4
      (16, 9) -> 4
      (16, 10) -> 4
      (16, 11) -> 4
      (16, 12) -> 4
      (16, 13) -> 4
      (16, 14) -> 4
      (16, 15) -> 15
      (16, 16) -> 4
      (16, 17) -> 4
      (16, 18) -> 4
      (16, 19) -> 4
      (16, 20) -> 4
      (16, 21) -> 4
      (16, 22) -> 40
      (16, 23) -> 4
      (16, 24) -> 4
      (16, 25) -> 4
      (16, 26) -> 4
      (16, 27) -> 4
      (16, 28) -> 4
      (16, 29) -> 4
      (17, 0) -> 41
      (17, 1) -> 4
      (17, 2) -> 4
      (17, 3) -> 3
      (17, 4) -> 4
      (17, 5) -> 4
      (17, 6) -> 4
      (17, 7) -> 4
      (17, 8) -> 4
      (17, 9) -> 4
      (17, 10) -> 4
      (17, 11) -> 4
      (17, 12) -> 4
      (17, 13) -> 4
      (17, 14) -> 4
      (17, 15) -> 15
      (17, 16) -> 4
      (17, 17) -> 4
      (17, 18) -> 4
      (17, 19) -> 4
      (17, 20) -> 4
      (17, 21) -> 4
      (17, 22) -> 4
      (17, 23) -> 4
      (17, 24) -> 4
      (17, 25) -> 4
      (17, 26) -> 4
      (17, 27) -> 32
      (17, 28) -> 4
      (17, 29) -> 4
      (18, 0) -> 42
      (18, 1) -> 4
      (18, 2) -> 4
      (18, 3) -> 3
      (18, 4) -> 4
      (18, 5) -> 4
      (18, 6) -> 4
      (18, 7) -> 4
      (18, 8) -> 4
      (18, 9) -> 4
      (18, 10) -> 4
      (18, 11) -> 4
      (18, 12) -> 4
      (18, 13) -> 4
      (18, 14) -> 4
      (18, 15) -> 15
      (18, 16) -> 4
      (18, 17) -> 4
      (18, 18) -> 4
      (18, 19) -> 4
      (18, 20) -> 4
      (18, 21) -> 4
      (18, 22) -> 43
      (18, 23) -> 4
      (18, 24) -> 4
      (18, 25) -> 4
      (18, 26) -> 4
      (18, 27) -> 4
      (18, 28) -> 4
      (18, 29) -> 4
      (19, 0) -> 19
      (19, 1) -> 4
      (19, 2) -> 4
      (19, 3) -> 28
      (19, 4) -> 4
      (19, 5) -> 4
      (19, 6) -> 4
      (19, 7) -> 4
      (19, 8) -> 4
      (19, 9) -> 4
      (19, 10) -> 4
      (19, 11) -> 4
      (19, 12) -> 4
      (19, 13) -> 4
      (19, 14) -> 4
      (19, 15) -> 30
      (19, 16) -> 4
      (19, 17) -> 4
      (19, 18) -> 4
      (19, 19) -> 4
      (19, 20) -> 4
      (19, 21) -> 4
      (19, 22) -> 4
      (19, 23) -> 4
      (19, 24) -> 4
      (19, 25) -> 4
      (19, 26) -> 4
      (19, 27) -> 4
      (19, 28) -> 4
      (19, 29) -> 4
      (20, 0) -> 44
      (20, 4) -> 45
      (20, 6) -> 45
      (20, 9) -> 44
      (20, 10) -> 44
      (21, 0) -> 44
      (21, 9) -> 44
      (21, 10) -> 44
      (22, 0) -> 46
      (22, 4) -> 45
      (22, 6) -> 45
      (22, 9) -> 46
      (22, 10) -> 46
      (23, 0) -> 23
      (23, 4) -> 45
      (23, 6) -> 45
      (23, 7) -> 21
      (23, 9) -> 7
      (23, 10) -> 7
      (23, 13) -> 22
      (23, 20) -> 22
      (24, 0) -> 47
      (24, 22) -> 47
      (25, 0) -> 48
      (25, 22) -> 48
      (26, 0) -> 49
      (26, 27) -> 49
      (27, 0) -> 50
      (27, 1) -> 4
      (27, 2) -> 4
      (27, 3) -> 28
      (27, 4) -> 29
      (27, 5) -> 4
      (27, 6) -> 29
      (27, 7) -> 12
      (27, 8) -> 4
      (27, 9) -> 13
      (27, 10) -> 13
      (27, 11) -> 4
      (27, 12) -> 4
      (27, 13) -> 14
      (27, 14) -> 4
      (27, 15) -> 30
      (27, 16) -> 4
      (27, 17) -> 4
      (27, 18) -> 4
      (27, 19) -> 4
      (27, 20) -> 51
      (27, 21) -> 4
      (27, 22) -> 28
      (27, 23) -> 4
      (27, 24) -> 4
      (27, 25) -> 32
      (27, 26) -> 4
      (27, 27) -> 4
      (27, 28) -> 4
      (27, 29) -> 4
      (28, 0) -> 19
      (28, 1) -> 4
      (28, 2) -> 4
      (28, 3) -> 3
      (28, 4) -> 4
      (28, 5) -> 4
      (28, 6) -> 4
      (28, 7) -> 4
      (28, 8) -> 4
      (28, 9) -> 4
      (28, 10) -> 4
      (28, 11) -> 4
      (28, 12) -> 4
      (28, 13) -> 4
      (28, 14) -> 4
      (28, 15) -> 15
      (28, 16) -> 4
      (28, 17) -> 4
      (28, 18) -> 4
      (28, 19) -> 4
      (28, 20) -> 4
      (28, 21) -> 4
      (28, 22) -> 4
      (28, 23) -> 4
      (28, 24) -> 4
      (28, 25) -> 4
      (28, 26) -> 4
      (28, 27) -> 4
      (28, 28) -> 4
      (28, 29) -> 4
      (29, 0) -> 36
      (29, 1) -> 4
      (29, 2) -> 4
      (29, 3) -> 3
      (29, 4) -> 4
      (29, 5) -> 4
      (29, 6) -> 4
      (29, 7) -> 4
      (29, 8) -> 4
      (29, 9) -> 37
      (29, 10) -> 37
      (29, 11) -> 4
      (29, 12) -> 4
      (29, 13) -> 4
      (29, 14) -> 4
      (29, 15) -> 15
      (29, 16) -> 4
      (29, 17) -> 4
      (29, 18) -> 4
      (29, 19) -> 4
      (29, 20) -> 4
      (29, 21) -> 4
      (29, 22) -> 4
      (29, 23) -> 4
      (29, 24) -> 4
      (29, 25) -> 4
      (29, 26) -> 4
      (29, 27) -> 4
      (29, 28) -> 4
      (29, 29) -> 4
      (30, 0) -> 19
      (30, 1) -> 4
      (30, 2) -> 4
      (30, 3) -> 28
      (30, 4) -> 4
      (30, 5) -> 4
      (30, 6) -> 4
      (30, 7) -> 4
      (30, 8) -> 4
      (30, 9) -> 4
      (30, 10) -> 4
      (30, 11) -> 4
      (30, 12) -> 4
      (30, 13) -> 4
      (30, 14) -> 4
      (30, 15) -> 30
      (30, 16) -> 4
      (30, 17) -> 4
      (30, 18) -> 4
      (30, 19) -> 4
      (30, 20) -> 4
      (30, 21) -> 4
      (30, 22) -> 4
      (30, 23) -> 4
      (30, 24) -> 4
      (30, 25) -> 4
      (30, 26) -> 4
      (30, 27) -> 4
      (30, 28) -> 4
      (30, 29) -> 4
      (31, 0) -> 41
      (31, 1) -> 4
      (31, 2) -> 4
      (31, 3) -> 3
      (31, 4) -> 4
      (31, 5) -> 4
      (31, 6) -> 4
      (31, 7) -> 4
      (31, 8) -> 4
      (31, 9) -> 4
      (31, 10) -> 4
      (31, 11) -> 4
      (31, 12) -> 4
      (31, 13) -> 4
      (31, 14) -> 4
      (31, 15) -> 15
      (31, 16) -> 4
      (31, 17) -> 4
      (31, 18) -> 4
      (31, 19) -> 4
      (31, 20) -> 4
      (31, 21) -> 4
      (31, 22) -> 28
      (31, 23) -> 4
      (31, 24) -> 4
      (31, 25) -> 32
      (31, 26) -> 4
      (31, 27) -> 4
      (31, 28) -> 4
      (31, 29) -> 4
      (32, 0) -> 19
      (32, 1) -> 4
      (32, 2) -> 4
      (32, 3) -> 3
      (32, 4) -> 4
      (32, 5) -> 4
      (32, 6) -> 4
      (32, 7) -> 4
      (32, 8) -> 4
      (32, 9) -> 4
      (32, 10) -> 4
      (32, 11) -> 4
      (32, 12) -> 4
      (32, 13) -> 4
      (32, 14) -> 4
      (32, 15) -> 15
      (32, 16) -> 4
      (32, 17) -> 4
      (32, 18) -> 4
      (32, 19) -> 4
      (32, 20) -> 28
      (32, 21) -> 4
      (32, 22) -> 4
      (32, 23) -> 4
      (32, 24) -> 4
      (32, 25) -> 4
      (32, 26) -> 4
      (32, 27) -> 4
      (32, 28) -> 4
      (32, 29) -> 4
      (33, 0) -> 52
      (33, 1) -> 4
      (33, 2) -> 4
      (33, 3) -> 28
      (33, 4) -> 4
      (33, 5) -> 4
      (33, 6) -> 4
      (33, 7) -> 4
      (33, 8) -> 4
      (33, 9) -> 34
      (33, 10) -> 34
      (33, 11) -> 4
      (33, 12) -> 4
      (33, 13) -> 14
      (33, 14) -> 4
      (33, 15) -> 30
      (33, 16) -> 4
      (33, 17) -> 4
      (33, 18) -> 4
      (33, 19) -> 4
      (33, 20) -> 14
      (33, 21) -> 4
      (33, 22) -> 4
      (33, 23) -> 4
      (33, 24) -> 4
      (33, 25) -> 4
      (33, 26) -> 4
      (33, 27) -> 4
      (33, 28) -> 4
      (33, 29) -> 4
      (34, 0) -> 52
      (34, 1) -> 4
      (34, 2) -> 4
      (34, 3) -> 3
      (34, 4) -> 4
      (34, 5) -> 4
      (34, 6) -> 4
      (34, 7) -> 4
      (34, 8) -> 4
      (34, 9) -> 34
      (34, 10) -> 34
      (34, 11) -> 4
      (34, 12) -> 4
      (34, 13) -> 14
      (34, 14) -> 4
      (34, 15) -> 15
      (34, 16) -> 4
      (34, 17) -> 4
      (34, 18) -> 4
      (34, 19) -> 4
      (34, 20) -> 14
      (34, 21) -> 4
      (34, 22) -> 4
      (34, 23) -> 4
      (34, 24) -> 4
      (34, 25) -> 4
      (34, 26) -> 4
      (34, 27) -> 4
      (34, 28) -> 4
      (34, 29) -> 4
      (35, 0) -> 35
      (35, 1) -> 4
      (35, 2) -> 4
      (35, 3) -> 28
      (35, 4) -> 29
      (35, 5) -> 4
      (35, 6) -> 29
      (35, 7) -> 12
      (35, 8) -> 4
      (35, 9) -> 13
      (35, 10) -> 13
      (35, 11) -> 4
      (35, 12) -> 4
      (35, 13) -> 14
      (35, 14) -> 4
      (35, 15) -> 30
      (35, 16) -> 4
      (35, 17) -> 4
      (35, 18) -> 4
      (35, 19) -> 4
      (35, 20) -> 14
      (35, 21) -> 4
      (35, 22) -> 4
      (35, 23) -> 4
      (35, 24) -> 4
      (35, 25) -> 4
      (35, 26) -> 4
      (35, 27) -> 4
      (35, 28) -> 4
      (35, 29) -> 4
      (36, 0) -> 36
      (36, 1) -> 4
      (36, 2) -> 4
      (36, 3) -> 28
      (36, 4) -> 4
      (36, 5) -> 4
      (36, 6) -> 4
      (36, 7) -> 4
      (36, 8) -> 4
      (36, 9) -> 37
      (36, 10) -> 37
      (36, 11) -> 4
      (36, 12) -> 4
      (36, 13) -> 4
      (36, 14) -> 4
      (36, 15) -> 30
      (36, 16) -> 4
      (36, 17) -> 4
      (36, 18) -> 4
      (36, 19) -> 4
      (36, 20) -> 4
      (36, 21) -> 4
      (36, 22) -> 4
      (36, 23) -> 4
      (36, 24) -> 4
      (36, 25) -> 4
      (36, 26) -> 4
      (36, 27) -> 4
      (36, 28) -> 4
      (36, 29) -> 4
      (37, 0) -> 36
      (37, 1) -> 4
      (37, 2) -> 4
      (37, 3) -> 3
      (37, 4) -> 4
      (37, 5) -> 4
      (37, 6) -> 4
      (37, 7) -> 4
      (37, 8) -> 4
      (37, 9) -> 37
      (37, 10) -> 37
      (37, 11) -> 4
      (37, 12) -> 4
      (37, 13) -> 4
      (37, 14) -> 4
      (37, 15) -> 15
      (37, 16) -> 4
      (37, 17) -> 4
      (37, 18) -> 4
      (37, 19) -> 4
      (37, 20) -> 4
      (37, 21) -> 4
      (37, 22) -> 4
      (37, 23) -> 4
      (37, 24) -> 4
      (37, 25) -> 4
      (37, 26) -> 4
      (37, 27) -> 4
      (37, 28) -> 4
      (37, 29) -> 4
      (38, 0) -> 53
      (38, 9) -> 53
      (38, 10) -> 53
      (38, 12) -> 53
      (38, 13) -> 53
      (38, 17) -> 53
      (38, 18) -> 53
      (38, 19) -> 53
      (38, 20) -> 53
      (38, 21) -> 53
      (39, 0) -> 41
      (39, 1) -> 4
      (39, 2) -> 4
      (39, 3) -> 28
      (39, 4) -> 4
      (39, 5) -> 4
      (39, 6) -> 4
      (39, 7) -> 4
      (39, 8) -> 4
      (39, 9) -> 4
      (39, 10) -> 4
      (39, 11) -> 4
      (39, 12) -> 4
      (39, 13) -> 4
      (39, 14) -> 4
      (39, 15) -> 30
      (39, 16) -> 4
      (39, 17) -> 4
      (39, 18) -> 4
      (39, 19) -> 4
      (39, 20) -> 4
      (39, 21) -> 4
      (39, 22) -> 4
      (39, 23) -> 4
      (39, 24) -> 4
      (39, 25) -> 32
      (39, 26) -> 4
      (39, 27) -> 4
      (39, 28) -> 4
      (39, 29) -> 4
      (40, 0) -> 41
      (40, 1) -> 4
      (40, 2) -> 4
      (40, 3) -> 3
      (40, 4) -> 4
      (40, 5) -> 4
      (40, 6) -> 4
      (40, 7) -> 4
      (40, 8) -> 4
      (40, 9) -> 4
      (40, 10) -> 4
      (40, 11) -> 4
      (40, 12) -> 4
      (40, 13) -> 4
      (40, 14) -> 4
      (40, 15) -> 15
      (40, 16) -> 4
      (40, 17) -> 4
      (40, 18) -> 4
      (40, 19) -> 4
      (40, 20) -> 4
      (40, 21) -> 4
      (40, 22) -> 4
      (40, 23) -> 4
      (40, 24) -> 4
      (40, 25) -> 32
      (40, 26) -> 4
      (40, 27) -> 4
      (40, 28) -> 4
      (40, 29) -> 4
      (41, 0) -> 19
      (41, 1) -> 4
      (41, 2) -> 4
      (41, 3) -> 28
      (41, 4) -> 4
      (41, 5) -> 4
      (41, 6) -> 4
      (41, 7) -> 4
      (41, 8) -> 4
      (41, 9) -> 4
      (41, 10) -> 4
      (41, 11) -> 4
      (41, 12) -> 4
      (41, 13) -> 4
      (41, 14) -> 4
      (41, 15) -> 30
      (41, 16) -> 4
      (41, 17) -> 4
      (41, 18) -> 4
      (41, 19) -> 4
      (41, 20) -> 28
      (41, 21) -> 4
      (41, 22) -> 4
      (41, 23) -> 4
      (41, 24) -> 4
      (41, 25) -> 4
      (41, 26) -> 4
      (41, 27) -> 4
      (41, 28) -> 4
      (41, 29) -> 4
      (42, 0) -> 19
      (42, 1) -> 4
      (42, 2) -> 4
      (42, 3) -> 28
      (42, 4) -> 4
      (42, 5) -> 4
      (42, 6) -> 4
      (42, 7) -> 4
      (42, 8) -> 4
      (42, 9) -> 4
      (42, 10) -> 4
      (42, 11) -> 4
      (42, 12) -> 4
      (42, 13) -> 4
      (42, 14) -> 4
      (42, 15) -> 30
      (42, 16) -> 4
      (42, 17) -> 4
      (42, 18) -> 4
      (42, 19) -> 4
      (42, 20) -> 4
      (42, 21) -> 4
      (42, 22) -> 28
      (42, 23) -> 4
      (42, 24) -> 4
      (42, 25) -> 4
      (42, 26) -> 4
      (42, 27) -> 4
      (42, 28) -> 4
      (42, 29) -> 4
      (43, 0) -> 19
      (43, 1) -> 4
      (43, 2) -> 4
      (43, 3) -> 3
      (43, 4) -> 4
      (43, 5) -> 4
      (43, 6) -> 4
      (43, 7) -> 4
      (43, 8) -> 4
      (43, 9) -> 4
      (43, 10) -> 4
      (43, 11) -> 4
      (43, 12) -> 4
      (43, 13) -> 4
      (43, 14) -> 4
      (43, 15) -> 15
      (43, 16) -> 4
      (43, 17) -> 4
      (43, 18) -> 4
      (43, 19) -> 4
      (43, 20) -> 4
      (43, 21) -> 4
      (43, 22) -> 28
      (43, 23) -> 4
      (43, 24) -> 4
      (43, 25) -> 4
      (43, 26) -> 4
      (43, 27) -> 4
      (43, 28) -> 4
      (43, 29) -> 4
      (44, 0) -> 54
      (44, 9) -> 44
      (44, 10) -> 44
      (44, 13) -> 22
      (44, 20) -> 22
      (45, 0) -> 46
      (45, 9) -> 46
      (45, 10) -> 46
      (46, 0) -> 46
      (46, 9) -> 46
      (46, 10) -> 46
      (47, 0) -> 49
      (47, 25) -> 49
      (48, 0) -> 3
      (48, 22) -> 3
      (49, 0) -> 3
      (49, 20) -> 3
      (50, 0) -> 35
      (50, 1) -> 4
      (50, 2) -> 4
      (50, 3) -> 28
      (50, 4) -> 29
      (50, 5) -> 4
      (50, 6) -> 29
      (50, 7) -> 12
      (50, 8) -> 4
      (50, 9) -> 13
      (50, 10) -> 13
      (50, 11) -> 4
      (50, 12) -> 4
      (50, 13) -> 14
      (50, 14) -> 4
      (50, 15) -> 30
      (50, 16) -> 4
      (50, 17) -> 4
      (50, 18) -> 4
      (50, 19) -> 4
      (50, 20) -> 51
      (50, 21) -> 4
      (50, 22) -> 4
      (50, 23) -> 4
      (50, 24) -> 4
      (50, 25) -> 4
      (50, 26) -> 4
      (50, 27) -> 4
      (50, 28) -> 4
      (50, 29) -> 4
      (51, 0) -> 36
      (51, 1) -> 4
      (51, 2) -> 4
      (51, 3) -> 3
      (51, 4) -> 29
      (51, 5) -> 4
      (51, 6) -> 29
      (51, 7) -> 4
      (51, 8) -> 4
      (51, 9) -> 37
      (51, 10) -> 37
      (51, 11) -> 4
      (51, 12) -> 4
      (51, 13) -> 4
      (51, 14) -> 4
      (51, 15) -> 15
      (51, 16) -> 4
      (51, 17) -> 4
      (51, 18) -> 4
      (51, 19) -> 4
      (51, 20) -> 4
      (51, 21) -> 4
      (51, 22) -> 4
      (51, 23) -> 4
      (51, 24) -> 4
      (51, 25) -> 4
      (51, 26) -> 4
      (51, 27) -> 4
      (51, 28) -> 4
      (51, 29) -> 4
      (52, 0) -> 52
      (52, 1) -> 4
      (52, 2) -> 4
      (52, 3) -> 28
      (52, 4) -> 29
      (52, 5) -> 4
      (52, 6) -> 29
      (52, 7) -> 4
      (52, 8) -> 4
      (52, 9) -> 34
      (52, 10) -> 34
      (52, 11) -> 4
      (52, 12) -> 4
      (52, 13) -> 14
      (52, 14) -> 4
      (52, 15) -> 30
      (52, 16) -> 4
      (52, 17) -> 4
      (52, 18) -> 4
      (52, 19) -> 4
      (52, 20) -> 14
      (52, 21) -> 4
      (52, 22) -> 4
      (52, 23) -> 4
      (52, 24) -> 4
      (52, 25) -> 4
      (52, 26) -> 4
      (52, 27) -> 4
      (52, 28) -> 4
      (52, 29) -> 4
      (53, 0) -> 55
      (53, 9) -> 55
      (53, 10) -> 55
      (53, 12) -> 55
      (53, 13) -> 55
      (53, 17) -> 55
      (53, 18) -> 55
      (53, 19) -> 55
      (53, 20) -> 55
      (53, 21) -> 55
      (54, 0) -> 54
      (54, 4) -> 45
      (54, 6) -> 45
      (54, 9) -> 44
      (54, 10) -> 44
      (54, 13) -> 22
      (54, 20) -> 22
      (55, 0) -> 56
      (55, 9) -> 56
      (55, 10) -> 56
      (55, 12) -> 56
      (55, 13) -> 56
      (55, 17) -> 56
      (55, 18) -> 56
      (55, 19) -> 56
      (55, 20) -> 56
      (55, 21) -> 56
      (56, 0) -> 4
      (56, 9) -> 4
      (56, 10) -> 4
      (56, 12) -> 4
      (56, 13) -> 4
      (56, 17) -> 4
      (56, 18) -> 4
      (56, 19) -> 4
      (56, 20) -> 4
      (56, 21) -> 4
      _ -> 0

dfa0InitialState :: Int
dfa0InitialState = 1

dfa0FinalStates :: [Int]
dfa0FinalStates = [2]

dfa0Transition :: Int -> Char -> Int
dfa0Transition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          c'' ->
            if any (\(c1, c2) -> c1 <= c'' && c'' <= c2) [(9,10),(12,13),(32,32)] then 1
            else 0 in
    case (q, c') of
      (1, 1) -> 2
      _ -> 0

dfa1InitialState :: Int
dfa1InitialState = 1

dfa1FinalStates :: [Int]
dfa1FinalStates = [6]

dfa1Transition :: Int -> Char -> Int
dfa1Transition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          97 -> 1
          101 -> 2
          102 -> 3
          108 -> 4
          115 -> 5
          c'' ->
            0 in
    case (q, c') of
      (1, 3) -> 2
      (2, 1) -> 3
      (3, 4) -> 4
      (4, 5) -> 5
      (5, 2) -> 6
      _ -> 0

dfa2InitialState :: Int
dfa2InitialState = 1

dfa2FinalStates :: [Int]
dfa2FinalStates = [5]

dfa2Transition :: Int -> Char -> Int
dfa2Transition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          108 -> 1
          110 -> 2
          117 -> 3
          c'' ->
            0 in
    case (q, c') of
      (1, 2) -> 2
      (2, 3) -> 3
      (3, 1) -> 4
      (4, 1) -> 5
      _ -> 0

dfa3InitialState :: Int
dfa3InitialState = 1

dfa3FinalStates :: [Int]
dfa3FinalStates = [5]

dfa3Transition :: Int -> Char -> Int
dfa3Transition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          101 -> 1
          114 -> 2
          116 -> 3
          117 -> 4
          c'' ->
            0 in
    case (q, c') of
      (1, 3) -> 2
      (2, 2) -> 3
      (3, 4) -> 4
      (4, 1) -> 5
      _ -> 0

dfa4InitialState :: Int
dfa4InitialState = 1

dfa4FinalStates :: [Int]
dfa4FinalStates = [2]

dfa4Transition :: Int -> Char -> Int
dfa4Transition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          123 -> 1
          c'' ->
            0 in
    case (q, c') of
      (1, 1) -> 2
      _ -> 0

dfa5InitialState :: Int
dfa5InitialState = 1

dfa5FinalStates :: [Int]
dfa5FinalStates = [2]

dfa5Transition :: Int -> Char -> Int
dfa5Transition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          125 -> 1
          c'' ->
            0 in
    case (q, c') of
      (1, 1) -> 2
      _ -> 0

dfa6InitialState :: Int
dfa6InitialState = 1

dfa6FinalStates :: [Int]
dfa6FinalStates = [2]

dfa6Transition :: Int -> Char -> Int
dfa6Transition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          44 -> 1
          c'' ->
            0 in
    case (q, c') of
      (1, 1) -> 2
      _ -> 0

dfa7InitialState :: Int
dfa7InitialState = 1

dfa7FinalStates :: [Int]
dfa7FinalStates = [2]

dfa7Transition :: Int -> Char -> Int
dfa7Transition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          58 -> 1
          c'' ->
            0 in
    case (q, c') of
      (1, 1) -> 2
      _ -> 0

dfa8InitialState :: Int
dfa8InitialState = 1

dfa8FinalStates :: [Int]
dfa8FinalStates = [2]

dfa8Transition :: Int -> Char -> Int
dfa8Transition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          91 -> 1
          c'' ->
            0 in
    case (q, c') of
      (1, 1) -> 2
      _ -> 0

dfa9InitialState :: Int
dfa9InitialState = 1

dfa9FinalStates :: [Int]
dfa9FinalStates = [2]

dfa9Transition :: Int -> Char -> Int
dfa9Transition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          93 -> 1
          c'' ->
            0 in
    case (q, c') of
      (1, 1) -> 2
      _ -> 0

dfa10InitialState :: Int
dfa10InitialState = 1

dfa10FinalStates :: [Int]
dfa10FinalStates = [2,4,5,10,11,12]

dfa10Transition :: Int -> Char -> Int
dfa10Transition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          43 -> 2
          45 -> 3
          46 -> 4
          48 -> 5
          c'' ->
            if any (\(c1, c2) -> c1 <= c'' && c'' <= c2) [(0,42),(44,44),(47,47),(58,68),(70,100),(102,1114111)] then 1
            else if 49 <= c'' && c'' <= 57 then 6
            else if any (\(c1, c2) -> c1 <= c'' && c'' <= c2) [(69,69),(101,101)] then 7
            else 0 in
    case (q, c') of
      (1, 0) -> 2
      (1, 3) -> 3
      (1, 5) -> 4
      (1, 6) -> 2
      (2, 0) -> 5
      (2, 4) -> 6
      (2, 5) -> 2
      (2, 6) -> 2
      (2, 7) -> 7
      (3, 0) -> 2
      (3, 5) -> 4
      (3, 6) -> 2
      (4, 0) -> 8
      (4, 4) -> 6
      (4, 7) -> 7
      (5, 0) -> 5
      (5, 2) -> 9
      (5, 3) -> 9
      (5, 4) -> 6
      (5, 5) -> 2
      (5, 6) -> 2
      (5, 7) -> 7
      (6, 0) -> 10
      (6, 5) -> 10
      (6, 6) -> 10
      (7, 0) -> 11
      (7, 2) -> 9
      (7, 3) -> 9
      (7, 5) -> 11
      (7, 6) -> 11
      (8, 0) -> 10
      (8, 2) -> 9
      (8, 3) -> 9
      (8, 5) -> 10
      (8, 6) -> 10
      (9, 0) -> 11
      (9, 5) -> 11
      (9, 6) -> 11
      (10, 0) -> 12
      (10, 5) -> 10
      (10, 6) -> 10
      (10, 7) -> 7
      (11, 0) -> 11
      (11, 5) -> 11
      (11, 6) -> 11
      (12, 0) -> 12
      (12, 2) -> 9
      (12, 3) -> 9
      (12, 5) -> 10
      (12, 6) -> 10
      (12, 7) -> 7
      _ -> 0

dfa11InitialState :: Int
dfa11InitialState = 1

dfa11FinalStates :: [Int]
dfa11FinalStates = [3,4,6]

dfa11Transition :: Int -> Char -> Int
dfa11Transition q c =
  let c' :: Int
      c' =
        case Char.ord c of
          34 -> 2
          92 -> 6
          117 -> 9
          c'' ->
            if any (\(c1, c2) -> c1 <= c'' && c'' <= c2) [(0,33),(35,46),(58,64),(71,91),(93,96),(103,109),(111,113),(115,115),(118,1114111)] then 1
            else if any (\(c1, c2) -> c1 <= c'' && c'' <= c2) [(47,47),(110,110),(114,114),(116,116)] then 3
            else if 48 <= c'' && c'' <= 57 then 4
            else if 65 <= c'' && c'' <= 70 then 5
            else if any (\(c1, c2) -> c1 <= c'' && c'' <= c2) [(97,97),(99,101)] then 7
            else if any (\(c1, c2) -> c1 <= c'' && c'' <= c2) [(98,98),(102,102)] then 8
            else 0 in
    case (q, c') of
      (1, 0) -> 2
      (1, 2) -> 2
      (2, 0) -> 3
      (2, 1) -> 2
      (2, 2) -> 4
      (2, 3) -> 2
      (2, 4) -> 2
      (2, 5) -> 2
      (2, 6) -> 5
      (2, 7) -> 2
      (2, 8) -> 2
      (2, 9) -> 2
      (3, 0) -> 3
      (3, 1) -> 2
      (3, 2) -> 6
      (3, 3) -> 2
      (3, 4) -> 2
      (3, 5) -> 2
      (3, 6) -> 7
      (3, 7) -> 2
      (3, 8) -> 2
      (3, 9) -> 2
      (5, 0) -> 2
      (5, 2) -> 2
      (5, 3) -> 2
      (5, 6) -> 2
      (5, 8) -> 2
      (5, 9) -> 8
      (6, 0) -> 3
      (6, 1) -> 2
      (6, 2) -> 4
      (6, 3) -> 2
      (6, 4) -> 2
      (6, 5) -> 2
      (6, 6) -> 5
      (6, 7) -> 2
      (6, 8) -> 2
      (6, 9) -> 2
      (7, 0) -> 3
      (7, 1) -> 2
      (7, 2) -> 6
      (7, 3) -> 2
      (7, 4) -> 2
      (7, 5) -> 2
      (7, 6) -> 7
      (7, 7) -> 2
      (7, 8) -> 2
      (7, 9) -> 2
      (8, 0) -> 9
      (8, 4) -> 9
      (8, 5) -> 9
      (8, 7) -> 9
      (8, 8) -> 9
      (9, 0) -> 10
      (9, 4) -> 10
      (9, 5) -> 10
      (9, 7) -> 10
      (9, 8) -> 10
      (10, 0) -> 11
      (10, 4) -> 11
      (10, 5) -> 11
      (10, 7) -> 11
      (10, 8) -> 11
      (11, 0) -> 2
      (11, 4) -> 2
      (11, 5) -> 2
      (11, 7) -> 2
      (11, 8) -> 2
      _ -> 0

match :: Int -> [Int] -> (Int -> Char -> Int) -> String -> Maybe Int
match initialState finalStates transition = match' 0 Nothing initialState
  where
    match' :: Int -> Maybe Int -> Int -> String -> Maybe Int
    match' i r q s =
      let r' =
            if q `elem` finalStates then
              Just i
            else
              r in
        case s of
          [] ->
            r'
          (c : s') ->
            let q' = transition q c in
              match' (i + 1) r' q' s'

lex :: Monad m => SemanticActions m a -> String -> Lexing m ([a], String)
lex actions = lex' where
  lex' s = do
    p <- Lexing $ \p -> return (p, p)
    if p == Initial then
      case match dfaInitialInitialState dfaInitialFinalStates dfaInitialTransition s of
        Nothing ->
          return ([], s)
        Just 0 ->
          return ([], s)
        Just i ->
          let (yytext, s') = splitAt i s in
            if match dfa0InitialState dfa0FinalStates dfa0Transition s == Just i then do
              x <- saWS actions yytext
              (xs, s'') <- lex' s'
              return (x : xs, s'')
            else if match dfa1InitialState dfa1FinalStates dfa1Transition s == Just i then do
              x <- saFalse actions yytext
              (xs, s'') <- lex' s'
              return (x : xs, s'')
            else if match dfa2InitialState dfa2FinalStates dfa2Transition s == Just i then do
              x <- saNull actions yytext
              (xs, s'') <- lex' s'
              return (x : xs, s'')
            else if match dfa3InitialState dfa3FinalStates dfa3Transition s == Just i then do
              x <- saTrue actions yytext
              (xs, s'') <- lex' s'
              return (x : xs, s'')
            else if match dfa4InitialState dfa4FinalStates dfa4Transition s == Just i then do
              x <- saLBrace actions yytext
              (xs, s'') <- lex' s'
              return (x : xs, s'')
            else if match dfa5InitialState dfa5FinalStates dfa5Transition s == Just i then do
              x <- saRBrace actions yytext
              (xs, s'') <- lex' s'
              return (x : xs, s'')
            else if match dfa6InitialState dfa6FinalStates dfa6Transition s == Just i then do
              x <- saComma actions yytext
              (xs, s'') <- lex' s'
              return (x : xs, s'')
            else if match dfa7InitialState dfa7FinalStates dfa7Transition s == Just i then do
              x <- saColon actions yytext
              (xs, s'') <- lex' s'
              return (x : xs, s'')
            else if match dfa8InitialState dfa8FinalStates dfa8Transition s == Just i then do
              x <- saLBracket actions yytext
              (xs, s'') <- lex' s'
              return (x : xs, s'')
            else if match dfa9InitialState dfa9FinalStates dfa9Transition s == Just i then do
              x <- saRBracket actions yytext
              (xs, s'') <- lex' s'
              return (x : xs, s'')
            else if match dfa10InitialState dfa10FinalStates dfa10Transition s == Just i then do
              x <- saNumber actions yytext
              (xs, s'') <- lex' s'
              return (x : xs, s'')
            else if match dfa11InitialState dfa11FinalStates dfa11Transition s == Just i then do
              x <- saString actions yytext
              (xs, s'') <- lex' s'
              return (x : xs, s'')
            else
              return ([], s)
    else
      return ([], s)



semanticActions :: Monad m => SemanticActions m (Maybe Parsing.Token)
semanticActions = SemanticActions
  { saWS = const $ return Nothing
  , saFalse = const $ return $ Just $ Parsing.FALSE ()
  , saNull = const $ return $ Just $ Parsing.NULL ()
  , saTrue = const $ return $ Just $ Parsing.TRUE ()
  , saLBrace = const $ return $ Just $ Parsing.LBRACE ()
  , saRBrace = const $ return $ Just $ Parsing.RBRACE ()
  , saComma = const $ return $ Just $ Parsing.COMMA ()
  , saColon = const $ return $ Just $ Parsing.COLON ()
  , saLBracket = const $ return $ Just $ Parsing.LBRACKET ()
  , saRBracket = const $ return $ Just $ Parsing.RBRACKET ()
  , saNumber = return . Just . Parsing.NUMBER . read
  , saString = return . Just . Parsing.STRING . unescape . init . tail }
  where
    unescape [] = []
    unescape ('\\' : '"' : s) =
      '"' : unescape s
    unescape ('\\' : '\\' : s) =
      '\\' : unescape s
    unescape ('\\' : '/' : s) =
      '/' : unescape s
    unescape ('\\' : 'b' : s) =
      '\b' : unescape s
    unescape ('\\' : 'f' : s) =
      '\f' : unescape s
    unescape ('\\' : 'n' : s) =
      '\n' : unescape s
    unescape ('\\' : 'r' : s) =
      '\r' : unescape s
    unescape ('\\' : 't' : s) =
      '\t' : unescape s
    unescape ('\\' : 'u' : x1 : x2 : x3 : x4 : s) =
      Char.chr (read ['0', 'x', x1, x2, x3, x4]) : unescape s
    unescape (c : s) =
      c : unescape s
