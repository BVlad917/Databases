USE SpaceFlightsDatabase;

-- Get the mass (in lbs) of the spaceships which had human crew and operated during the Cold War
-- arithmetic expressions in the SELECT clause (1)
SELECT S.MASS_tons * 1000 * 2.2 AS spaceship_mass_lbs
FROM Spaceship AS S
WHERE S.ID IN (SELECT SP.ID
				FROM SpaceMission AS SP
				WHERE SP.HumanCrewNumber > 0)
INTERSECT
SELECT S2.MASS_tons * 1000 * 2.2 AS spaceship_mass_lbs
FROM Spaceship AS S2
WHERE S2.ID IN (SELECT SP2.ID
				FROM SpaceMission AS SP2
				WHERE SP2.DuringColdWar = 'Yes');



-- Get the launch sites from USA and which have launched manned missions
SELECT L.NAME
FROM LaunchSite AS L
WHERE L.CityID IN (SELECT Loc.ID
					FROM Location AS Loc
					WHERE Loc.CountryID IN (SELECT C.ID
											FROM Country AS C
											WHERE C.NAME = 'USA'))
INTERSECT
SELECT L2.NAME
FROM LaunchSite AS L2
WHERE L2.ID IN (SELECT S.LaunchSiteID
				FROM SpaceMission as S
				WHERE S.HumanCrewNumber > 0);