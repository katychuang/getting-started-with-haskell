-- Author: @katychuang
-- -- This code example creates a textbox with a header
-- -- using the diagrams library
--
-- ------------------------------------------------------------------------
-- -- Files begin with some settings to make sure ghc runs smoothly.
--
{-# LANGUAGE NoMonomorphismRestriction #-}

import Diagrams.Prelude
import Diagrams.Backend.SVG.CmdLine

-- Allow multiple run options
main = mainWith [("First", example1), ("Second", example2), ("Node", node)]

example, example1, example2, node :: Diagram B R2

------------------------------------------------------------------------
-- Examples from the Diagrams Tutorial
-- http://projects.haskell.org/diagrams/doc/quickstart.html

example = circle 1 # fc blue
                   # lw veryThick
                   # lc purple
                   # dashingG [0.2,0.05] 0

-- example = dashingG [0.2,0.05] 0 . lc purple . lw veryThick . fc blue $ circle 1

example1 = circle 1 # fc red # lw none ||| circle 1 # fc green # lw none
-- (fc red . lw none $ circle 1) ||| (fc green . lw none $ circle 1)

example2 = square 1 # fc aqua `atop` circle 1

-------------------------------------------------------------------------

header = text "Header Title" <> rect 14 2 # lw thin 
bodyText = text "First line of text" # fontSize (Local 1)
    === (text "Second line of text" # fontSize (Local 1) <>  strutY 2.9)
body = bodyText <> rect 14 4 # lw thin
node = header === body

------------------------------------------------------------------------
-- How to run this script:
-- 1. Open up ghci in your console and load this file `:l diagram-textbox.hs` or
--    `:load diagram-textbox.hs`. :l is short for :load.
-- 2. Call one of the defined functions, i.e. `:main --selection Node -o test.svg -w 400`
--
