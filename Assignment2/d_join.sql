USE SpaceFlightsDatabase;

-- Get all the planets with their corresponding satellites
SELECT Planet.NAME, Satellite.NAME
FROM Satellite
INNER JOIN Planet ON Satellite.PlanetID = Planet.ID;


-- Get all the astronauts with their corresponding universities graduated
SELECT A.NAME, U.NAME
FROM Astronaut A
LEFT JOIN Astronaut_University AU ON A.ID = AU.AstronautID LEFT JOIN University U ON AU.UniversityID = U.ID;


-- Get all the astronauts with the space programmes they participated in
SELECT A.NAME, S.NAME
FROM Astronaut A
RIGHT JOIN SpaceMission_Astronaut SA ON A.ID = SA.AstronautID RIGHT JOIN SpaceMission S ON SA.SpaceMissionID = S.ID;


-- Get all the universities with the space programmes that these universities sent astronauts to
SELECT DISTINCT U.NAME, S.NAME
FROM University U
INNER JOIN Astronaut_University AU ON U.ID = AU.AstronautID INNER JOIN Astronaut A ON A.ID = AU.AstronautID
INNER JOIN SpaceMission_Astronaut SA ON A.ID = SA.AstronautID INNER JOIN SpaceMission S ON SA.SpaceMissionID = S.ID;



-- Get all the space missions along with their corresponding spaceships (and the spaceships along with their space missions)
SELECT SM.NAME, S.NAME
FROM SpaceMission SM
FULL JOIN Spaceship S ON S.ID = SM.SpaceshipID;
