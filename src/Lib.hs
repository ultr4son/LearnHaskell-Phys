module Phys where

import Data.List


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

collisionSpeed::Double->Double->Double->Double->Double
collisionSpeed b1Speed b2Speed b1Mass b2Mass = ((b1Mass - b2Mass)/(b1Mass+b2Mass)) * b1Speed + ((2*b2Mass)/(b1Mass + b2Mass)) * b2Speed

--Collide b1 with b2, returns speed of b1
collide::Body->Body->Double
collide StaticPoint{} StaticPoint{} = 0
collide (Point mass speed _ _) StaticPoint{} = let newSpeed = collisionSpeed speed 0 mass 0 in newSpeed
collide b1@StaticPoint{} b2@Point{} = collide b2 b1
collide (Point mass1 speed1 _ _) (Point mass2 speed2 _ _) = let b1Speed = collisionSpeed speed1 speed2 mass1 mass2 in b1Speed
	  
--Is there a better way to do this?
touching::Body->Body->Bool
touching b1 b2 = (position b1) == (position b2)

findTouching::Body->[Body]->Maybe Body
findTouching body bodies = find (\b -> touching b body && b /= body ) bodies

--Calculate force
force::Double->Double->Double
force acceleration mass = mass*acceleration

acceleration::Double->Double->Double
acceleration force mass = force/mass

attraction::Double->Double->Double->Double->Double
attraction g mass1 mass2 distance = (g*mass1*mass2) / distance^2

--How much the first body attracts the second in force units.
attracts::Double->Body->Body->Double
attracts g b1 b2 = let distance = (position b1) - (position b2) in attraction g (mass b1) (mass b2) distance

gNormal = 6.67*10^(-11)
earthPoint position = (StaticPoint (5.972 * 10^24) position)
-- gravityEffectNormal::Body->Body->Body
-- gravityEffectNormal = gravityEffect gNormal

simulateBody::[Body]->Double -> Body ->Body
simulateBody _ _ body@(StaticPoint _ _)= body
simulateBody bodies timeStep body@(Point mass speed accel position) =
  let attractionForce = foldr (\affectingBody v -> (if affectingBody /= body then (attracts 1 affectingBody body) else 0.0) + v) 0.0 bodies
      newAcceleration = (acceleration attractionForce mass)
      newSpeed = case findTouching body bodies of
				Just b2 -> collide body b2
				Nothing -> speedDelta speed newAcceleration timeStep
      newPosition = positionDelta newSpeed position timeStep
  in (Point mass newSpeed newAcceleration newPosition)

attractionForce::Double->Body->[Body] -> Double
attractionForce g body bodies = foldr (\affectingBody v -> (if affectingBody /= body then (attracts 1 affectingBody body) else 0.0) + v) 0.0 bodies

simulateBodies::[Body] -> Double -> [Body]
simulateBodies bodies timeStep = map (simulateBody bodies timeStep) bodies

simulate::[Body] -> Double -> Double -> [[Body]]
simulate _ _ 0 = []
simulate bodies timeStep iterations = let state = simulateBodies bodies timeStep in state:simulate state timeStep (iterations - 1)

printSimulationResult::[[Body]] -> IO()
printSimulationResult steps = printSimulationResult' steps 0 where
	printSimulationResult' (step:more) iteration = 
		do 
			putStrLn ("Step " ++ (show iteration) ++ ":")
			sequence_ (map putStrLn [(show x) | x <- steps])