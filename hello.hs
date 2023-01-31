{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

import Data.Text
import Data.Maybe
import Foreign.C.String
import System.IO.Unsafe
import Foreign.Marshal.Alloc
import Foreign.Ptr
import Foreign.Storable
import Foreign.C.Types
import Data.ByteString.Unsafe (unsafePackCString)
import Data.Text (Text)

import Control.Applicative
import Foreign
import Foreign.C
import Prelude hiding (lex)
import Text.ParserCombinators.ReadP
import Text.Read.Lex
import GHC.Ptr

import qualified Data.Text.Encoding as E

foreign export ccall hello :: (Ptr CChar) -> IO ()
foreign export ccall mallocBytes :: Int -> IO (Ptr a)
foreign export ccall h_eval :: (Ptr CChar) -> Ptr CInt -> IO (Ptr CInt)

textFromPtr :: Ptr CChar -> IO Text
textFromPtr = fmap E.decodeUtf8 . unsafePackCString

hello :: Ptr CChar -> IO ()
hello ptr = ("Hello, " <>) <$> input >>= print 
  where
    input = if ptr == nullPtr then mempty else textFromPtr ptr

h_eval :: (Ptr CChar) -> Ptr CInt -> IO (Ptr CInt)
h_eval s r = do
    cs <- peekCAString s
    case hs_eval cs of
        Nothing -> return nullPtr
        Just x -> do
            poke r x
            return r

hs_eval :: String -> Maybe CInt
hs_eval inp = case readP_to_S expr inp of
    (a,_) : _ -> Just a
    []        -> Nothing

expr = addition <* expect EOF

addition = chainl1 multiplication add
  where
    add = expect (Symbol "+") >> return (+)

multiplication = chainl1 atom mul
  where
    mul = expect (Symbol "*") >> return (*)

atom = number <|> between lp rp addition

number = do
    Number n <- lex
    case numberToInteger n of
        Just i  -> return (fromIntegral i)
        Nothing -> pfail

lp = expect (Punc "(")
rp = expect (Punc ")")

main = undefined
