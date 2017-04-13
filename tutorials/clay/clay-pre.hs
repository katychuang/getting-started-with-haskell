-- clay-pre.hs
-- This is a more comprehensive eample from:
-- http://www.shakthimaan.com/posts/2016/01/27/haskell-web-programming/news.html

{-# LANGUAGE OverloadedStrings #-}

import Clay

main :: IO ()
main = putCss $
  pre ?
    do border dotted (pt 1) black
       whiteSpace (other "pre")
       fontSize (other "8pt")
       overflow (other "auto")
       padding (em 20) (em 0) (em 20) (em 0)

{-
- Compile with `ghc --make clay-pre.hs`
- Execute ./clay-pre to produce the css
- -}
