module Phys where

data Body = Point {mass::Double, speed::Double, accel::Double, position::Double} | StaticPoint {mass::Double, position::Double} deriving(Eq, Show)

--Haha I just did calculus :)
--Calculate speed if it was accelerated in some time
speedDelta::Double->Double->Double->Double
speedDelta speed accel time = speed + accel * time

--Calculate position if it went at a speed in some time
positionDelta::Double->Double->Double->Double
positionDelta speed position time = position + speed * time
---------------------------------------------------------------

--Calculate momentum
momentum::Double->Double->Double
momentum speed mass = speed * mass

--True if two bodies exist in the same position. False if not.
touching::Body->Body->Bool
touching b1 b2 = (position b1) == (position b2)

--Calculate force
force::Double->Double->Double
force acceleration mass = mass*acceleration

--Calculate acceleration
acceleration::Double->Double->Double
acceleration force mass = force/mass

--Calculate attraction
attraction::Double->Double->Double->Double->Double
attraction g mass1 mass2 distance = (g*mass1*mass2) / distance^2

--How much the first body attracts the second in force units.
attracts::Double->Body->Body->Double
attracts g b1 b2 = let distance = (position b1) - (position b2) in attraction g (mass b1) (mass b2) distance

gNormal = 6.67*10^(-11)
earthPoint position = (StaticPoint (5.972 * 10^24) position)
-- gravityEffectNormal::Body->Body->Body
-- gravityEffectNormal = gravityEffect gNormal

--Simulate a body for one tick.
simulateBody::[Body]->Double -> Body ->Body
simulateBody _ _ body@(StaticPoint _ _)= body
simulateBody bodies timeStep body@(Point mass speed accel position) =
  let attractionForce = netAttraction gNormal body bodies --foldr (\affectingBody v -> (if affectingBody /= body then (attracts 1 affectingBody body) else 0.0) + v) 0.0 bodies
      newAcceleration = (acceleration attractionForce mass)
      newSpeed = speedDelta speed newAcceleration timeStep
      newPosition = positionDelta newSpeed position timeStep
  in (Point mass newSpeed newAcceleration newPosition)

--Calculate the sum of the force of the attracting bodies on body
netAttraction::Double->Body->[Body] -> Double
netAttraction g body bodies = foldr (\affectingBody v -> (if affectingBody /= body then (attracts g affectingBody body) else 0.0) + v) 0.0 bodies

--Simulate multiple bodies for one tick
simulateBodies::[Body] -> Double -> [Body]
simulateBodies bodies timeStep = map (simulateBody bodies timeStep) bodies

--Simulate multiple bodies for a tick size for some amount of ticks. Each array represents the bodies's state at that tick.
simulate::[Body] -> Double -> Double -> [[Body]]
simulate _ _ 0 = []
simulate bodies timeStep iterations = let state = simulateBodies bodies timeStep in state:simulate state timeStep (iterations - 1)
