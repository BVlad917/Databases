USE SpaceFlightsDatabase;




-- Find how many universities each astronaut has graduated and only show the first half of astronauts (the ones
-- with the highest number of universities graduated)
-- ORDER BY (1)
SELECT TOP 50 PERCENT A.NAME AS astronaut_name, COUNT(U.ID) AS nr_of_universities_graduated
FROM Astronaut A 
		INNER JOIN Astronaut_University AU ON A.ID = AU.AstronautID
		INNER JOIN University U ON AU.UniversityID = U.ID
GROUP BY A.NAME
ORDER BY COUNT(U.ID) DESC;




-- Get all the plantes which have at least 2 satellites and only show the first 5 such planets
-- TOP (2)
SELECT TOP 5 P.NAME AS planet_name, COUNT(S.NAME) AS number_of_satellites
FROM Planet P
INNER JOIN Satellite S ON S.PlanetID = P.ID
GROUP BY P.NAME
HAVING COUNT(S.NAME) > 1
ORDER BY COUNT(S.NAME) DESC;



-- Find how many cities each country has in the database, only counting the countries where there were space mission launches
-- ORDER BY (2)
SELECT C.NAME AS country, COUNT(DISTINCT L.NAME) AS number_of_cities_with_space_launches
FROM Location L
	INNER JOIN Country C ON L.CountryID = C.ID
GROUP BY C.NAME
HAVING 0 < (SELECT COUNT(*)
			FROM SpaceMission SM
			INNER JOIN LaunchSite LS ON SM.LaunchSiteID = LS.ID
			INNER JOIN Location L ON L.ID = LS.CityID
			INNER JOIN Country C2 ON C2.ID = L.CountryID
			WHERE C2.NAME = C.NAME)
ORDER BY number_of_cities_with_space_launches DESC




-- For each spaceship with a mass above average and a height above average, display how many astronauts
-- have worked on this spaceship in a space mission. Display the spaceship mass in lbs and the spaceship height in feet
-- arithmetic expressions in the SELECT clause (3)
SELECT S1.NAME AS spaceship, S1.MASS_tons * 1000 * 2.2 AS spaceship_mass_lbs, 
	   S1.HEIGHT_meters * 3.28 AS spaceship_height_ft, COUNT(A.NAME) AS astronaut_who_worked_on_spaceship_count
FROM Spaceship S1
	INNER JOIN SpaceMission SM ON S1.ID = SM.SpaceshipID
	INNER JOIN SpaceMission_Astronaut SA ON SM.ID = SA.SpaceMissionID
	INNER JOIN Astronaut A ON A.ID = SA.AstronautID
GROUP BY S1.NAME, S1.ID, S1.MASS_tons, S1.HEIGHT_meters
HAVING S1.MASS_tons > (SELECT AVG(Spaceship.MASS_tons) FROM Spaceship) AND
	   S1.HEIGHT_meters > (SELECT AVG(Spaceship.HEIGHT_meters) FROM Spaceship)

