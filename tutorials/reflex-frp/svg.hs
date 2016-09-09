import Reflex.Dom
import Data.Map (fromList)
import qualified Data.Map as Map
import Data.Monoid

main = mainWidget $ myDiv

myDiv = do
  let attrs = constDyn $ fromList
                          [ ("width" , "100")
                          , ("height" , "100")
                          ]
  let cAttrs = constDyn $ fromList
               [ ("cx", "50")
               , ("cy", "50")
               , ("r", "40")
               , ("stroke", "green")
               , ("stroke-width", "3")
               , ("fill",  "yellow" )
               ]

  s <- elSvg "svg" attrs (elSvg "circle" cAttrs (return()))
  c <- elSvg "svg" attrs (
    elSvg "circle" cAttrs (text "@katychuang.nyc"))

  return ()

elSvg tag a1 a2 = do
  elDynAttrNS' ns tag a1 a2
  return ()

ns :: Maybe String
ns = Just "http://www.w3.org/2000/svg"


