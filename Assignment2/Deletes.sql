USE SpaceFlightsDatabase;

SELECT * FROM Astronaut;

DELETE FROM Astronaut
WHERE DateOfBirth > '1955/01/01';


SELECT * FROM SolarSystem;

DELETE FROM SolarSystem
WHERE NAME IN ('Kepler-11', 'Proxima Centauri', 'Kepler-90');