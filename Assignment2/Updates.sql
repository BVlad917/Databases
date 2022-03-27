-- UPDATES

-- Update University location IDs

UPDATE University
SET LocationID = 9
WHERE NAME = 'Purdue University';

UPDATE University
SET LocationID = 7
WHERE NAME = 'Massachusetts Institute of Technology';

UPDATE University
SET LocationID = 6
WHERE NAME = 'United States Military Academy';

UPDATE University
SET LocationID = 5
WHERE NAME = 'University of Southern California';

UPDATE University
SET LocationID = 9
WHERE NAME = 'Saratov Technical College';




UPDATE SpaceMission
SET TYPE = TYPE + '; Manned mission'
WHERE HumanCrewNumber > 0;




ALTER TABLE SpaceMission
ADD	Returned varchar(255);

UPDATE SpaceMission
SET Returned = 'Yes'
WHERE ReturnDate IS NOT NULL;

UPDATE SpaceMission
SET Returned = 'No'
WHERE ReturnDate IS NULL;



ALTER TABLE SpaceMission
ADD DuringColdWar varchar(255);

UPDATE SpaceMission
SET DuringColdWar = 'Yes'
WHERE LaunchDate BETWEEN '1945/01/01' AND '1991/01/01';

UPDATE SpaceMission
SET DuringColdWar = 'No'
WHERE DuringColdWar IS NULL OR DuringColdWar NOT IN ('Yes', 'YES', 'Y', 'yes', 'y');




UPDATE Spaceship
SET MASS_tons += 0.01
WHERE NAME LIKE '%Titan%';

SELECT * FROM Spaceship;
