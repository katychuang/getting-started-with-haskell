{-# LANGUAGE OverloadedStrings #-}

import Network.HTTP.Conduit
import Data.Aeson
import Data.Aeson.Types
import Network.HTTP.Conduit
import Data.Char(toLower)
import qualified Data.Text as T
import qualified Data.Vector as V
import Data.Maybe
import Data.List(find, intercalate)
import Network.HTTP(urlEncode)


------------------------------------------------------------------------
-- Endpoint
------------------------------------------------------------------------

class Endpoint a where
  buildURI :: a -> String

callJsonEndpoint :: (FromJSON j, Endpoint e) => e -> IO j
callJsonEndpoint e =
  do responseBody <- simpleHttp (buildURI e)
     case eitherDecode responseBody of
       Left err -> fail err
       Right res -> return res

------------------------------------------------------------------------
-- GeocoderEndpoint
------------------------------------------------------------------------


-- https://developers.google.com/maps/documentation/geocoding/
data GeocoderEndpoint =
  GeocodeEndpoint { address :: String, sensor :: Bool }

-- This instance converts a data structure into a URI, by passing in
-- paramater values as variables
instance Endpoint GeocoderEndpoint where
  buildURI GeocodeEndpoint { address = address, sensor = sensor } =
    let params = [("address", Just address), ("sensor", Just $ map toLower $ show sensor)]
    in "http://maps.googleapis.com/maps/api/geocode/json" ++ renderQuery True params


------------------------------------------------------------------------
-- GeocoderModel
------------------------------------------------------------------------


data GeocodeResponse = GeocodeResponse LatLng deriving Show

instance FromJSON GeocodeResponse where
  parseJSON val =
    do let Object obj = val
       (Array results) <- obj .: "results"
       (Object location) <- navigateJson (results V.! 0) ["geometry", "location"]
       (Number lat) <- location .: "lat"
       (Number lng) <- location .: "lng"
       return $ GeocodeResponse (realToFrac lat, realToFrac lng)


------------------------------------------------------------------------
-- FoursquareEndpoint
------------------------------------------------------------------------


foursquareApiVersion = "20130721"

data FoursquareCredentials = FoursquareCredentials { clientId :: String, clientSecret :: String }

data FoursquareEndpoint =
    VenuesTrendingEndpoint { ll :: LatLng, limit :: Maybe Int, radius :: Maybe Double }

instance Endpoint FoursquareEndpoint where
  buildURI VenuesTrendingEndpoint {ll = ll, limit = limit, radius = radius} =
    let params = [("ll", Just $ renderLatLng ll), ("limit", fmap show limit), ("radius", fmap show radius)]
    in "https://api.foursquare.com/v2/venues/trending" ++ renderQuery True params

data AuthorizedFoursquareEndpoint = AuthorizedFoursquareEndpoint FoursquareCredentials FoursquareEndpoint

instance Endpoint AuthorizedFoursquareEndpoint where
  buildURI (AuthorizedFoursquareEndpoint creds e) = appendParams originalUri authorizationParams
    where originalUri = buildURI e
          authorizationParams = [("client_id", Just $ clientId creds),
                                 ("client_secret", Just $ clientSecret creds),
                                 ("v", Just foursquareApiVersion)]

authorizeWith :: FoursquareEndpoint -> FoursquareCredentials -> AuthorizedFoursquareEndpoint
authorizeWith = flip AuthorizedFoursquareEndpoint


------------------------------------------------------------------------
-- FoursquareModel
------------------------------------------------------------------------


withFoursquareResponse :: (Object -> Parser a) -> Value -> Parser a
withFoursquareResponse func val = do let Object obj = val
                                     response <- obj .: "response"
                                     func response

data Venue = Venue { venueId :: String, name :: String } deriving Show

data VenuesTrendingResponse = VenuesTrendingResponse { venues :: [Venue] } deriving Show

instance FromJSON VenuesTrendingResponse where
  parseJSON = withFoursquareResponse parseResponse
    where parseResponse :: Object -> Parser VenuesTrendingResponse
          parseResponse obj = do (Array venues) <- obj .: "venues"
                                 parsedVenues <- V.mapM (\(Object o) -> parseVenue o) venues
                                 return $ VenuesTrendingResponse $ V.toList parsedVenues
          parseVenue :: Object -> Parser Venue
          parseVenue obj = do (String idText) <- obj .: "id"
                              (String nameText) <- obj .: "name"
                              return $ Venue { venueId = T.unpack idText, name = T.unpack nameText }

------------------------------------------------------------------------
-- Core
------------------------------------------------------------------------

type LatLng = (Double, Double)

renderLatLng :: LatLng -> String
renderLatLng (lat, lng) = show lat ++ "," ++ show lng

navigateJson :: Value -> [T.Text] -> Parser Value
navigateJson (Object obj) (first : second : rest) =
  do next <- obj .: first
     navigateJson next (second : rest)
navigateJson (Object obj) [last] = obj .: last

renderQuery :: Bool -> [(String, Maybe String)] -> String
renderQuery b params = (if b then "?" else "") ++ intercalate "&" serializedParams
  where serializedParams = catMaybes $ map renderParam params
        renderParam (key, Just val) = Just $ key ++ "=" ++ (urlEncode val)
        renderParam (_, Nothing) = Nothing

appendParams :: String -> [(String, Maybe String)] -> String
appendParams uri params
  | isJust (find (=='?') uri) = uri ++ "&" ++ renderQuery False params
  | otherwise = uri ++ renderQuery True params


------------------------------------------------------------------------
-- Main
------------------------------------------------------------------------

-- | Main entry point to the application.

targetAddress = "568 Broadway, New York, NY"

-- | The main entry point.
main :: IO ()
main =
  do putStrLn "API key?"
     apiKey <- getLine
     putStrLn "API secret?"
     apiSecret <- getLine
     let creds = FoursquareCredentials apiKey apiSecret

     (GeocodeResponse latLng) <- callJsonEndpoint $ GeocodeEndpoint targetAddress False
     let venuesTrendingEndpoint = VenuesTrendingEndpoint latLng Nothing Nothing `authorizeWith` creds
     (VenuesTrendingResponse venues) <- callJsonEndpoint venuesTrendingEndpoint
     let printVenue v = putStrLn $ "- " ++ name v
     mapM_ printVenue venues


------------------------------------------------------------------------

{-

# REFERENCE & LINKS

This file comes from a tutorial published in Aug 2013.
The original version is published at: https://www.fpcomplete.com/school/to-infinity-and-beyond/pick-of-the-week/foursquare-api-example

In order to use this code, you'll need to install http-conduit and aeson.
They can be installed through cabal with the following command:

`prompt$ cabal install http-conduit aeson`

-}
