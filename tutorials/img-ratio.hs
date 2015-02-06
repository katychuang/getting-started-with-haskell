{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}

-- Modules start with imports


------------------------------------------------------------------------
-- Simple exercise: reduce input number in half
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

-- Reduce input by percentage indicated
redux :: ([Double], Double) -> [Double]
redux (theList, y) = map (*y) theList

redux' :: Double -> (Double, Double) -> (Double, Double)
redux' factor (x, y) = (x * factor, y * factor)
