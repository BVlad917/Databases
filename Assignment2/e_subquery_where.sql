USE SpaceFlightsDatabase;

-- Get all the astronauts who have graduated Purdue, MIT, or The Military Academy
SELECT A1.NAME
FROM Astronaut AS A1
WHERE A1.ID IN (SELECT AU1.AstronautID
				FROM Astronaut_University AS AU1
				WHERE AU1.UniversityID IN (SELECT U1.ID
											FROM University AS U1
											WHERE U1.NAME IN ('Purdue University', 'Massachusetts Institute of Technology', 'United States Military Academy')));


-- Get all the astronauts who were part of the Apollo 11 space programme
SELECT A2.NAME
FROM Astronaut AS A2
WHERE A2.ID IN (SELECT SA.AstronautID
			FROM SpaceMission_Astronaut AS SA
			WHERE SA.SpaceMissionID IN (SELECT S.ID
										FROM SpaceMission AS S
										WHERE S.NAME = 'Apollo 11'));




-- Get all the astronauts who were born after 1925 and participated in space programmes during the Cold War
-- conditions with AND, OR, NOT, and parentheses in the WHERE clause (2)
SELECT A.NAME
FROM Astronaut AS A
WHERE A.DateOfBirth >= '1925/01/01' AND A.ID IN (SELECT SA.AstronautID
												FROM SpaceMission_Astronaut AS SA
												WHERE SpaceMissionID IN (SELECT S.ID
																		FROM SpaceMission AS S
																		WHERE S.DuringColdWar = 'Yes'));
