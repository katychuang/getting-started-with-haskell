-- Author: @katychuang
-- This is an example of using RefexFRP to make a calculator UI.

{-# LANGUAGE RecursiveDo, TemplateHaskell #-}
import Reflex
import Reflex.Dom
import qualified Data.Map as Map
import Safe (readMay)
import Control.Applicative ((<*>), (<$>))
import Data.FileEmbed

import           Data.Monoid
import           Data.Map (Map)

{-

Types...
https://hackage.haskell.org/package/reflex-0.3.2/docs/Reflex-Dynamic.html

mapDyn :: (Reflex t, MonadHold t m) => (a -> b) -> Dynamic t a -> m (Dynamic t b)

combineDyn :: forall t m a b c. (Reflex t, MonadHold t m) => (a -> b -> c) -> Dynamic t a -> Dynamic t b -> m (Dynamic t c)

constDyn :: Reflex t => a -> Dynamic t a

count :: (Reflex t, MonadHold t m, MonadFix m, Num b) => Event t a -> m (Dynamic t b)

dynText :: MonadWidget t m => Dynamic t String -> m ()

-}

main = mainWidgetWithCss $(embedFile "style.css")  $ do
  elClass "div" "top-line" $ return ()

  elClass "div" "header" $ do
    elClass "h1" "logo" $ text "Image Aspect Ratio"

  elClass "div" "main" $ do

    uh <- elClass "div" "left" $ do
      rec
        attrs <- combineDyn (\x y -> imgAttrs x y) x1 y1
        elDynAttr' "img" (attrs) $ return ()

        x1 <- box "x1  =" "1024" never
        el "hr" $ return ()
        y1 <- box "y1  =" "768" never

      el "br" $ return ()

      text "ratio = "
      uh <- combineDyn (\x y -> calcAspectRatio x y) x1 y1
      test <- mapDyn show uh
      dynText test





    elClass "div" "right" $ do
      rec
        attrs <- combineDyn (\x y -> imgAttrs x y) x2 y2
        elDynAttr' "img" (attrs) $ return ()

        x2 <- box "x2  =" "640" never
        el "hr" $ return ()
        y2 <- box "y2  =" "480" never

      text "ratio = "
      uh <- combineDyn (\x y -> calcAspectRatio x y) x2 y2
      test <- mapDyn show uh
      dynText test


  divClass "footer" $ do
    text "(C) 2016 Demo of a ReflexFRP app. Designed by "
    elAttr' "a" ("href" =: "http://github.com/katychuang") $
      text "Kat Chuang"
  return ()


textInputAttrs :: Maybe Double -> Maybe Double -> Maybe Double -> Double
textInputAttrs x y x2 = case (x, y, x2) of 
  (Just x', Just y', Just x'') -> (x' * y' / x'')
  _ -> 0.0

imgAttrs :: Maybe Double -> Maybe Double -> Map String String
imgAttrs x y = case (x, y) of
  (Just x', Just y') -> "src" =: ("http://placehold.it/" ++ (show x') ++"x"++ (show y')) <> style <> static
  _ -> Map.empty
  where
    static = "width" =: "400"
    style = "style" =: "border: 1px solid red; margin-bottom: 25px;"

numberInput :: (MonadWidget t m) => String -> Event t Double -> m (Dynamic t (Maybe Double))
numberInput i e = do
  let errorState = Map.singleton "style" "border-color: red"
      validState = Map.singleton "style" "border-color: green"
  rec n <- textInput $ def & textInputConfig_inputType .~ "number"
                       & textInputConfig_initialValue .~ i
                       & textInputConfig_attributes .~ attrs
                       & setValue .~  fmap show e
      result <- mapDyn readMay $ _textInput_value n
      attrs <- mapDyn (\r -> case r of
                                  Just _ -> validState
                                  Nothing -> errorState) result
  return result


box :: (MonadWidget t m) => String -> String -> Event t Double -> m (Dynamic t (Maybe Double))
box t i e =
  elClass "div" "box height" $ do
    el "label" $ text t
    y <- numberInput i e
    return y
