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

import qualified Data.Text.Encoding as E

foreign export ccall hello :: (Ptr CChar) -> IO ()
-- foreign export ccall free :: Ptr a -> IO ()
foreign export ccall mallocBytes :: Int -> IO (Ptr a)

textFromPtr :: Ptr CChar -> IO Text
textFromPtr = fmap E.decodeUtf8 . unsafePackCString

hello :: Ptr CChar -> IO ()
hello ptr = ("Hello, " <>) <$> input >>= print 
  where
    input = if ptr == nullPtr then pure "" else textFromPtr ptr

main = undefined
