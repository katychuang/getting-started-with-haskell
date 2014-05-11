{-# LANGUAGE OverloadedStrings #-}
module Blah where

import Data.Aeson             ((.:), (.:?), decode, FromJSON(..), Value(..))
import Control.Applicative    ((<$>), (<*>))
import Data.Scientific        as Scientific
import Data.Time.Format       (parseTime)
import Data.Time.Clock        (UTCTime)
import System.Locale          (defaultTimeLocale)
import Control.Monad          (liftM)
import Data.Attoparsec.Number (Number(..))
import qualified Data.HashMap.Strict as HM
import qualified Data.ByteString.Lazy.Char8 as BS

------------------------------------------------------------------------

parseRHTime :: String -> Maybe UTCTime
parseRHTime = parseTime defaultTimeLocale "%FT%X%QZ"

-- match objects
data Paste = Paste { getLines    :: Scientific -- note difference from example
                   , getDate     :: Maybe UTCTime
                   , getID       :: String
                   , getLanguage :: String
                   , getPrivate  :: Bool
                   , getURL      :: String
                   , getUser     :: Maybe String
                   , getBody     :: String
                   } deriving (Show)

-- define instance to make it possible to decode
instance FromJSON Paste where
  parseJSON (Object v) =
    Paste <$>
    (v .: "lines")                  <*>
    liftM parseRHTime (v .: "date") <*>
    (v .: "paste-id")               <*>
    (v .: "language")               <*>
    (v .: "private")                <*>
    (v .: "url")                    <*>
    (v .:? "user")                  <*>
    (v .: "contents")

-- .:? allows keys to be null or not exist
-- nested structures `((v .: "stuff") >>= (.: "language"))`
-- { stuff: { language: en} }

-- --function to extract the number of lines from the json
getRHLines :: String -> Scientific -- note difference from example
getRHLines json =
  case HM.lookup "lines" hm of
    Just (Number n)     -> n
    Nothing             -> error "Y U NO HAZ NUMBER?"
  where (Just (Object hm)) = decode (BS.pack json) :: Maybe Value

------------------------------------------------------------------------

-- REFERENCE & LINKS --

-- This file comes from a tutorial published in Nov 2012. Some types have
-- been changed to make it work with the latest version of Aeson 0.7.0.3
-- The original version is published at:
-- http://blog.raynes.me/blog/2012/11/27/easy-json-parsing-in-haskell-with-aeson/


-- The main change from original version published in 2012 was the input
-- type change. The current aeson version 0.7.0.3 takes Scientific instead of
-- Integer type. You can find types by typing :t Number into your ghci console.
-- Reference for aeson 0.7.0.3 types http://hackage.haskell.org/package/aeson-0.7.0.3/docs/Data-Aeson-Types.html
--

-- Usage
-- inside ghci, load the file with :load blah.hs
-- then you can call the function and pass in json data
-- getRHLines "{\"lines\":1,\"date\":\"2012-01-04T01:44:22.964Z\",\"paste-id\":\"1\",\"fork\":null,\"random-id\":\"f1fc1181fb294950ca4df7008\",\"language\":\"Clojure\",\"private\":false,\"url\":\"https://www.refheap.com/paste/1\",\"user\":\"raynes\",\"contents\":\"(begin)\"}"




