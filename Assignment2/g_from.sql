USE SpaceFlightsDatabase;


-- Get all the astronauts born after 1935
SELECT FilteredAstronauts.NAME
FROM (SELECT *
		FROM Astronaut
		WHERE Astronaut.DateOfBirth >= '1935/01/01') AS FilteredAstronauts;


-- Get the launch date of all the manned space missions during the Cold War
SELECT FilteredAstronauts.LaunchDate
FROM (SELECT *
		FROM SpaceMission
		WHERE SpaceMission.HumanCrewNumber > 0 AND SpaceMission.DuringColdWar = 'Yes') AS FilteredAstronauts;
