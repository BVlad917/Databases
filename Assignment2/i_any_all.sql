USE SpaceFlightsDatabase;

-- Get all the astronauts who studied at MIT or at Purdue University
SELECT A.NAME AS astronaut_name
FROM Astronaut A
WHERE A.ID = ANY(SELECT A2.ID
				 FROM Astronaut A2 
				 INNER JOIN Astronaut_University AU ON AU.AstronautID = A2.ID
				 INNER JOIN University U ON U.ID = AU.UniversityID
				 WHERE U.NAME = 'Massachusetts Institute of Technology' OR U.NAME = 'Purdue University');
-- Rewrite using IN / [NOT] IN
SELECT A.NAME AS astronaut_name
FROM Astronaut A
WHERE A.ID IN (SELECT A2.ID
				 FROM Astronaut A2 
				 INNER JOIN Astronaut_University AU ON AU.AstronautID = A2.ID
				 INNER JOIN University U ON U.ID = AU.UniversityID
				 WHERE U.NAME = 'Massachusetts Institute of Technology' OR U.NAME = 'Purdue University');




-- Select all the planets with a revolution period (rotation around its star) bigger than
-- the revolution period of Earth and of Mars 
SELECT P.NAME
FROM Planet P
WHERE P.RevolutionPeriod_EarthYears > ALL(SELECT P2.RevolutionPeriod_EarthYears
										  FROM Planet P2
										  WHERE P2.NAME = 'Earth' OR P2.NAME = 'Mars');
-- Rewrite using IN / [NOT] IN
SELECT P.NAME
FROM Planet P
WHERE P.ID IN (SELECT P2.ID
			   FROM Planet P2
			   WHERE P2.RevolutionPeriod_EarthYears > (SELECT P3.RevolutionPeriod_EarthYears
													  FROM Planet P3
													  WHERE P3.NAME = 'Earth')
					 AND P2.RevolutionPeriod_EarthYears > (SELECT P4.RevolutionPeriod_EarthYears
														   FROM Planet P4
														   WHERE P4.NAME = 'Mars'));




-- Select all the astronauts who were born before all the space missions that launched from Merritt Island
SELECT A.NAME AS astronaut_name
FROM Astronaut A
WHERE A.DateOfBirth < ALL(SELECT SM.LaunchDate
					   FROM SpaceMission SM
					   INNER JOIN LaunchSite LS ON SM.LaunchSiteID = LS.ID
					   INNER JOIN Location L ON L.ID = LS.CityID
					   WHERE L.NAME = 'Merritt Island');
-- Rewrite using aggregation operators
SELECT A.NAME AS astronaut_name
FROM Astronaut A
WHERE A.DateOfBirth < (SELECT MIN(SM.LaunchDate)
					   FROM SpaceMission SM
					   INNER JOIN LaunchSite LS ON SM.LaunchSiteID = LS.ID
					   INNER JOIN Location L ON L.ID = LS.CityID
					   WHERE L.NAME = 'Merritt Island');




-- Select the satellites which have an orbital period (rotation around its planet) bigger than the rotation
-- period (rotation around the planet's axis, aka how long a day is on that planet) of all the registered planets from our solar system
SELECT S.NAME
FROM Satellite S
WHERE S.OrbitalPeriod_EarthDays > ALL(SELECT P.RotationPeriod_EarthDays
									  FROM Planet P
									  INNER JOIN SolarSystem S ON P.SolarSystemID = S.ID
									  WHERE S.NAME = 'The Solar System');
-- Rewrite using aggregation operators
SELECT S.NAME
FROM Satellite S
WHERE S.OrbitalPeriod_EarthDays > (SELECT MAX(P.RotationPeriod_EarthDays)
									  FROM Planet P
									  INNER JOIN SolarSystem S ON P.SolarSystemID = S.ID
									  WHERE S.NAME = 'The Solar System');




-- Count all the countries which have had launches
-- DISTINCT
SELECT COUNT(DISTINCT C.NAME) AS nr_countries_with_space_launches
FROM Country C
INNER JOIN Location L ON C.ID = L.CountryID
INNER JOIN LaunchSite LS ON LS.CityID = L.ID
INNER JOIN SpaceMission SM ON SM.LaunchSiteID = LS.ID;




-- Get all the launch dates from 1945 to 1991
-- DISTINCT 
SELECT DISTINCT S.LaunchDate
FROM SpaceMission S
WHERE S.LaunchDate >= '1945/01/01' AND S.LaunchDate <= '1991/12/31';




-- Count all the universities which have had astronauts
-- DISTINCT
SELECT COUNT(DISTINCT U.NAME) AS nr_universities_with_astronauts
FROM University U
INNER JOIN Astronaut_University AU ON AU.UniversityID = U.ID
INNER JOIN Astronaut A ON A.ID = AU.AstronautID
