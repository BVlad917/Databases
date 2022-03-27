USE SpaceFlightsDatabase;



-- Select all the astronauts who have graduated MIT, Purdue, or the Military Academy OR have participated in the Apollo 11 space programme
SELECT A1.NAME
FROM Astronaut AS A1
WHERE A1.ID IN (SELECT AU1.AstronautID
				FROM Astronaut_University AS AU1
				WHERE AU1.UniversityID IN (SELECT U1.ID
											FROM University AS U1
											WHERE U1.NAME IN ('Purdue University', 'Massachusetts Institute of Technology', 'United States Military Academy')))
UNION
SELECT A2.NAME
FROM Astronaut AS A2
WHERE A2.ID IN (SELECT SA.AstronautID
			FROM SpaceMission_Astronaut AS SA
			WHERE SA.SpaceMissionID IN (SELECT S.ID
										FROM SpaceMission AS S
										WHERE S.NAME = 'Apollo 11'));





-- Select all the planets which have a rotation period of more than one Earth day or a revolution period of more than 25 Earth years
SELECT P1.NAME 
FROM Planet AS P1
WHERE P1.RotationPeriod_EarthDays > 1
UNION 
SELECT P2.NAME
FROM Planet P2
WHERE P2.RevolutionPeriod_EarthYears > 25;



-- Count number of astronauts born before 1935 or have participated in space missions during the Cold War
-- conditions with AND, OR, NOT, and parentheses in the WHERE clause (1)
SELECT COUNT(A.ID)
FROM Astronaut AS A
WHERE A.DateOfBirth >= '1935/01/01' OR A.ID IN (SELECT SA.AstronautID
												FROM SpaceMission_Astronaut AS SA
												WHERE SpaceMissionID IN (SELECT S.ID
																		FROM SpaceMission AS S
																		WHERE S.DuringColdWar = 'Yes')) ;
