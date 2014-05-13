{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

import Data.ByteString (ByteString)
import Network.HTTP.Conduit
import Web.Authenticate.OAuth
import Data.Aeson
import Data.Time.Clock (UTCTime)
import Data.Text (Text)
import GHC.Generics

-- Insert here your own credentials

myoauth :: OAuth
myoauth =
  newOAuth { oauthServerName     = "api.twitter.com"
           , oauthConsumerKey    = "your consumer key here"
           , oauthConsumerSecret = "your consumer secret here"
             }

mycred :: Credential
mycred = newCredential "your access token here"
                       "your access token secret here"

-- | Type for tweets. Use only the fields you are interested in.
--   The parser will filter them. To see a list of available fields
--   see <https://dev.twitter.com/docs/platform-objects/tweets>.
data Tweet =
  Tweet { text :: !Text
          } deriving (Show, Generic)

instance FromJSON Tweet
instance ToJSON Tweet

-- | This function reads a timeline JSON and parse it using the 'Tweet' type.
timeline :: String -- ^ Screen name of the user
         -> IO (Either String [Tweet]) -- ^ If there is any error parsing the JSON data, it
                                       --   will return 'Left String', where the 'String'
                                       --   contains the error information.
timeline name = do
  -- Firstly, we create a HTTP request with method GET (it is the default so we don't have to change that).
  req <- parseUrl $ "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=" ++ name
  -- Using a HTTP manager, we authenticate the request and send it to get a response.
  res <- withManager $ \m -> do
           -- OAuth Authentication. 'signOAuth' modifies the HTTP header adding the
           -- appropriate authentication.
           signedreq <- signOAuth myoauth mycred req
           -- Send request.
           httpLbs signedreq m
  -- Decode the response body.
  return $ eitherDecode $ responseBody res

-- | The main function, as an example of how to use the 'timeline'
--   function.
main :: IO ()
main = do
  -- Read the timeline from Hackage user. Feel free to change the screen
  -- name to any other.
  ets <- timeline "Hackage"
  case ets of
   -- When the parsing of the JSON data fails, we report it.
   Left err -> putStrLn err
   -- When successful, print in the screen the first 5 tweets.
   Right ts  -> mapM_ print $ take 5 ts


------------------------------------------------------------------------

-- REFERENCE & LINKS --
-- https://www.fpcomplete.com/school/starting-with-haskell/libraries-and-frameworks/text-manipulation/json

-- first, run this `cabal install authenticate-oauth`
-- load into ghci with :l twitter-fpcomplete.hs
-- run Main

