module PlanetSim where
  import Phys

  data Planet = Earth | Moon

  planetMass::Planet -> Double
  planetMass Earth = 5.972 * 10^24
  planetMass Moon = 7.348 * 10^22

  planetRadius::Planet->Double
  planetRadius Earth = 6.371 * 10^6
  planetRadius Moon = 1.737 * 10^6

  planetStatic::Planet->Double->Body
  planetStatic planet position = StaticPoint (planetMass planet) position

  planetPoint::Planet->Double->Body
  planetPoint planet position = Point (planetMass planet) 0 0 position
