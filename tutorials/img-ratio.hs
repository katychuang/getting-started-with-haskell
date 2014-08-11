-- Simple exercise: reduce input in half

shrinkWidth :: Double -> Double
shrinkWidth x = x / 2

shrinkLength :: Double -> Double
shrinkLength x = x / 2

shrink :: (Double, Double) -> (Double, Double)
shrink (x, y) = (x / 2, y / 2)

shrink' :: [Double] -> [Double]
shrink' theList = map (/2) theList

-- Reduce input by percentage indicated
redux :: ([Double], Double) -> [Double]
redux (theList, y) = map (*y) theList

redux' :: Double -> (Double, Double) -> (Double, Double)
redux' factor (x, y) = (x * factor, y * factor)
