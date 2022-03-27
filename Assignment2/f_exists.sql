USE SpaceFlightsDatabase;

-- Get all the planets from our solar system and their rotation period in earth hours
-- arithmetic expressions in the SELECT clause (2)
SELECT Planet.NAME AS planet_name, Planet.RotationPeriod_EarthDays * 24 AS rotation_period_earth_hours
FROM Planet
WHERE EXISTS (SELECT *
				FROM SolarSystem
				WHERE SolarSystem.NAME = 'The Solar System' AND SolarSystem.ID = Planet.SolarSystemID);




-- Get all the astronauts who have graduated an American university
-- conditions with AND, OR, NOT, and parentheses in the WHERE clause (3)
SELECT Astronaut.NAME
FROM Astronaut
WHERE EXISTS (SELECT *
			FROM Astronaut_University
			WHERE Astronaut_University.AstronautID = Astronaut.ID AND Astronaut_University.UniversityID IN (SELECT University.ID
																											FROM University
																											WHERE EXISTS (SELECT *
																														  FROM Location
																														  WHERE University.LocationID = Location.ID AND Location.CountryID IN (SELECT Country.ID
																																															   FROM Country
																																															   WHERE Country.NAME = 'USA'))));



