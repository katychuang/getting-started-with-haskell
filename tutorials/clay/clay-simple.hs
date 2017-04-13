-- clay-simple.hs
-- http://www.shakthimaan.com/posts/2016/01/27/haskell-web-programming/news.html

{-# LANGUAGE OverloadedStrings #-}

import Clay

main :: IO ()
main = putCss exampleStylesheet

exampleStylesheet :: Css
exampleStylesheet = body ? fontFamily ["Baskerville", "Georgia", "Garamond", "Times"] [serif]

{-
- Compile with the command `ghc --make clay-simple.hs`
- Then execute `./clay-simple` to generate the css output
- -}
