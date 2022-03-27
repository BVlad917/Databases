USE SpaceFlightsDatabase;

-- Show all astronauts which were part of Apollo 11 but did not attend MIT
SELECT A.NAME
FROM Astronaut AS A
WHERE A.ID IN (SELECT SA.AstronautID
				FROM SpaceMission_Astronaut AS SA
				WHERE SA.SpaceMissionID IN (SELECT S.ID
											FROM SpaceMission AS S
											WHERE S.NAME = 'Apollo 11'))
EXCEPT
SELECT A2.NAME
FROM Astronaut AS A2
WHERE A2.ID IN (SELECT AU.AstronautID
					FROM Astronaut_University AS AU
					WHERE AU.UniversityID IN (SELECT U.ID
												FROM University AS U
												WHERE U.NAME = 'Massachusetts Institute of Technology'));



-- Select all the satellites which are not of Earth or of Mars and are more massive than the Moon
SELECT S1.NAME
FROM Satellite AS S1
WHERE S1.PlanetID NOT IN (SELECT P1.ID
							FROM Planet AS P1
							WHERE P1.NAME IN ('Earth', 'Mars'))
EXCEPT
SELECT S2.NAME
FROM Satellite AS S2
WHERE S2.MASS_EarthMoonMasses <= 1;
