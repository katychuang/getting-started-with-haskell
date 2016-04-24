-- Haskell workshop example of using Reflex-FRP
-- Created: April 23, 206

{-
Go to https://api.nasa.gov to get an API Key
-}

{-# LANGUAGE ScopedTypeVariables, DeriveGeneric #-}
import Reflex.Dom
import qualified Data.Text as T
import Data.Maybe
import GHC.Generics
import Data.Aeson
import qualified Data.Map as Map

data NasaPicture = NasaPicture { copyright :: Maybe String
                               , date :: String
                               , explanation :: String
                               , hdurl :: String
                               , media_type :: String
                               , service_version :: String
                               , title :: String
                               , url :: String
                               }
                               deriving (Show, Generic)

-- basic way to interact with the json api
instance FromJSON NasaPicture

--  entry point for any haskell application is main function
main :: IO ()
main = mainWidget workshop

workshop :: forall t m. MonadWidget t m => m ()
workshop = do
  elClass "h1" "title" $ text "NASA Picture of the Day"
  t <- textInput def --def provides default input
  let apiKey = _textInput_value t

  b :: Event t () <- button "Send Request" 

  let apiKeyButtonEvent :: Event t String = tagDyn apiKey b
      apiKeyEnterEvent :: Event t String = tagDyn apiKey (textInputGetEnter t)

      -- if both events fire at the same time the first on the list is picked first.
      apiKeyEvent :: Event t String = leftmost [ apiKeyButtonEvent
                                               , apiKeyEnterEvent 
                                               ]

  submittedApiKey :: Dynamic t String <- holdDyn "NO STRING SUBMITTED" apiKeyEvent
  --dynText submittedApiKey

  let req :: Event t XhrRequest = fmap apiKeyToXhrRequest apiKeyEvent
  rsp :: Event t XhrResponse <- performRequestAsync req
  let rspText :: Event t (Maybe T.Text) = fmap _xhrResponse_responseText rsp
      rspString :: Event t String = fmapMaybe (\mt -> fmap T.unpack mt) rspText

  respDyn <- holdDyn "No Response" rspString
  --dynText respDyn

  divClass "break" $ return ()

  -- have to tell it what the blob of text should represent
  let decoded :: Event t (Maybe NasaPicture) = fmap decodeXhrResponse rsp

  dynPic :: Dynamic t (Maybe NasaPicture) <- holdDyn Nothing decoded

  dynPicString <- mapDyn show dynPic
  --dynText dynPicString

  imgAttrs :: Dynamic t (Map.Map String String) <- forDyn dynPic $ \np -> 
    case np of
        Nothing -> Map.empty
        Just pic -> Map.singleton "src" (url pic) 
        -- reflex gives you syntactic sugar which can be Just pic -> "src" =: url pic

  elDynAttr "img" imgAttrs $ return ()

  return () --return unit because mainWidget requires the type return

-- function builds the request
apiKeyToXhrRequest :: String -> XhrRequest
apiKeyToXhrRequest k = XhrRequest { _xhrRequest_method = "GET"
                          , _xhrRequest_url = "https://api.nasa.gov/planetary/apod?api_key=" ++ k
                          , _xhrRequest_config = def
                          }
