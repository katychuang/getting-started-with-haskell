{-# LANGUAGE TemplateHaskell #-}
import Reflex.Dom
import Data.FileEmbed

--  entry point for any haskell application is main function
main = mainWidgetWithCss $(embedFile "helloworld.css") $ do
  el "h1" $
    text "hello world"
  elAttr "div" ("class" =: "box") $
    text "hello world"
  elAttr "div" ("style" =: "border:1px solid blue; border-radius:100px; text-align:center; height:200px; width:200px; display:table-cell; vertical-align:middle") $
    text "hello world"
  return ()
