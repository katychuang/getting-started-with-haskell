-- clay-custom.hs
-- This is an example of adding custom values using the other type class or
-- fallback operator `-:` to explicitly specify values
-- http://www.shakthimaan.com/posts/2016/01/27/haskell-web-programming/news.html

{-# LANGUAGE OverloadedStrings #-}

import Clay

main :: IO ()
main = putCss $
  body ?
       do fontSize (other "11pt !important")
          "border" -: "0"
