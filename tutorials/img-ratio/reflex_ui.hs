-- Author: @katychuang
-- This is an example of using RefexFRP to make a calculator UI.


{-# LANGUAGE RecursiveDo, TemplateHaskell #-}
import Reflex
import Reflex.Dom
import qualified Data.Map as Map
import Safe (readMay)
import Control.Applicative ((<*>), (<$>))
import Data.FileEmbed

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
    elClass "h1" "logo" $ text "Image Ratio"

  elClass "div" "main" $ do

  x1 <- elClass "div" "box width" $ do
    el "label" $ text "width "
    x <- numberInput "1024"
    return x

  y1 <- elClass "div" "box height" $ do
    el "label" $ text "height "
    y <- numberInput "768"
    return y

  x2 <- elClass "div" "box width" $ do
    el "label" $ text "new width "
    x <- numberInput "640"
    return x

  step1 <- combineDyn (\x y -> (*) <$> x <*> y) x2 y1
  step2 <- combineDyn (\x y -> (/) <$> x <*> y) step1 x1

  resultString <- mapDyn show step2
  text "new height = "
  dynText resultString

numberInput :: (MonadWidget t m) => String -> m (Dynamic t (Maybe Double))
numberInput i = do
  let errorState = Map.singleton "style" "border-color: red"
      validState = Map.singleton "style" "border-color: green"
  rec n <- textInput $ def & textInputConfig_inputType .~ "number"
                       & textInputConfig_initialValue .~ i
                       & textInputConfig_attributes .~ attrs
      result <- mapDyn readMay $ _textInput_value n
      attrs <- mapDyn (\r -> case r of
                                  Just _ -> validState
                                  Nothing -> errorState) result
  return result


