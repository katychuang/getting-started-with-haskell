{- Example written by Dr. Kat Chuang
   @katychuang on GitHub

   To run this file, install Reflex-Dom, and then convert to html/js
   with the command `ghcjs xmas.hs`
-}

{-# LANGUAGE OverloadedStrings, TemplateHaskell #-}

import Reflex.Dom
import Data.FileEmbed
import Data.Time (Day, diffDays, fromGregorian, getCurrentTime, utctDay)
import System.Locale (defaultTimeLocale)
import Control.Monad.IO.Class (liftIO)
import Data.Text (pack)



main :: IO ()
main = mainWidgetWithCss $(embedFile "style.css") $ do
  el "h1" $ text ""
  el "div" $ do
    el "h2" $ text "Days since last Christmas"
    el "p" $ bodyElement


-- This function returns the text value
bodyElement :: MonadWidget t m =>  m()
bodyElement = do
  now <- liftIO getCurrentTime
  let delta = showText $ daysSinceXmas now
  text delta
    where
      lastXmas = (fromGregorian 2017 12 25)
      daysSinceXmas a = diffDays (utctDay a) lastXmas
      showText s = pack $ show s
