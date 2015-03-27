-- Author: @katychuang
-- These are functions I wrote to practice thinking in Haskell to help with
-- photo processing work. See instructions below on how to use ghci

------------------------------------------------------------------------
-- Files begin with some settings to make sure ghc runs smoothly.

{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}
------------------------------------------------------------------------
-- Modules start with imports.

-- We don't need to import anything for this file.

------------------------------------------------------------------------
-- Simple exercises

-- reduce input number in half
shrinkWidth :: Double -> Double
shrinkWidth x = x / 2

shrinkHeight :: Double -> Double
shrinkHeight x = x / 2

-- Passing in width and height as a tuple
shrink :: (Double, Double) -> (Double, Double)
shrink (x, y) = (x / 2, y / 2)

-- Passing in in width and height as a list
shrink' :: [Double] -> [Double]
shrink' theList = map (/2) theList

-- Reduce a list of numbers by percentage (i.e. 0.5 for half size) indicated as the 2nd item in a tuple
redux :: ([Double], Double) -> [Double]
redux (theList, percentShrink) = map (*percentShrink) theList

-- Reduce a pair of width/height pair in a tuple, by a given factor, i.e. 0.5
redux' :: Double -> (Double, Double) -> (Double, Double)
redux' factor (x, y) = (x * factor, y * factor)

------------------------------------------------------------------------
-- Return calculations at 0.75, 0.5, 0.25 increments
quarters :: (Double, Double) -> [(Double, Double)]
quarters (x, y) = [(x * 0.75, y * 0.75), (x * 0.5, y * 0.5), (x * 0.25, y * 0.25)]

-- Return calculations at 0.10 increments, i.e. 0.9, 0.8, 0.7, etc
tenths :: (Double, Double) -> [(Double, Double)]
tenths (x, y) = [(x * 0.9, y * 0.9), (x * 0.8, y * 0.8), (x * 0.7, y * 0.7), 
		    (x * 0.6, y * 0.6), (x * 0.5, y * 0.5), (x * 0.4, y * 0.4),
		    (x * 0.3, y * 0.3), (x * 0.2, y * 0.2), (x * 0.1, y * 0.1)]

-- Return calculations at 0.10 increments, i.e. 0.9, 0.8, 0.7, etc (with recursion to keep it a oneliner)
tenths' :: (Double, Double) -> [(Double, Double)]
tenths' (x, y) = reverse $ [(x * factor / 10, y * factor / 10) | factor <- [1..9]]


------------------------------------------------------------------------
-- How to run this script:
-- 1. Open up ghci in your console and load this file `:l img-ratio.hs` or
--    `:load img-ratio.hs`. :l is short for :load.
-- 2. Call one of the defined functions, i.e. `shrinkWidth 1024` will return
--    the value of 1024 divided by 2; the output will be 512.0.
--    Note the data types in the function to understand correct input for
--    each method. For instance, shrinkWidth takes a Double type, so passing
--    in a string such as `blue` will produce an error "Not in scope: `blue'".
--    Similarly, for shrink' (pronounced shrink prime) it takes a list of
--    Doubles. Passing in a different type, such as a tuple
--      `shrink' (1024, 768)`,  will give you an error:
--    Couldn't match expected type `[Double]' with actual type `(t0, t1)'
      --In the first argument of shrink', namely `(1024, 768)'
      --In the expression: shrink' (1024, 768)
      --In an equation for `it': it = shrink' (1024, 768)
--- Another example of wrong input - passing in a list of strings: `shrink' ["red", "white", "blue"]`
--        Couldn't match expected type `Double' with actual type `[Char]'
--        In the expression: "red"
--        In the first argument of shrink', namely `["red", "white", "blue"]'
--        In the expression: shrink' ["red", "white", "blue"]



