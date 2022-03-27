-- First, we have to remove one column from the table SpaceMission because this column makes it NOT BCNF
-- We have a transitional dependency between LaunchDate and DuringColdWar (DuringColdWar can be inferred from LaunchDate)
-- So, we remove the column DuringColdWar
-- Note: Some queries from Assignment 2 might not work after this, since I used this column in some of them
-- but the database is now normalized!

USE SpaceMissionsDatabase;

ALTER TABLE SpaceMission
DROP COLUMN DuringColdWar;

SELECT *
FROM SpaceMission;

-- We notice that we have another column which makes this table not be in BCNF: the Returned column
-- If a space mission returned, then its value in the column ReturnDate will be a valid date (and not NULL)
-- Therefore, having the column Returned is redundant, as this column can be inferred from the column ReturnDate

ALTER TABLE SpaceMission
DROP COLUMN Returned;

SELECT *
FROM SpaceMission;




-- ASSIGNMENT 3

-- a) Modify the type of the 'DateOfBirth' column from DATE to VARCHAR and back
-- Modify to VARCHAR


GO
CREATE PROCEDURE UpgradeToVersion1
AS
	ALTER TABLE Astronaut
	ALTER COLUMN DateOfBirth VARCHAR(64);
GO


-- Modify back to DATE
GO
CREATE PROCEDURE DowngradeToVersion0
AS
	ALTER TABLE Astronaut
	ALTER COLUMN DateOfBirth DATE;
GO


-- b) Add column 'MaxSpeed_km_h' in the Spaceship table
GO
CREATE PROCEDURE UpgradeToVersion2
AS
	ALTER TABLE Spaceship
	ADD MaxSpeed_km_h INT;
GO



-- Remove 'MaxSpeed_km_h' from the Spaceship table
GO
CREATE PROCEDURE DowngradeToVersion1
AS
	ALTER TABLE Spaceship
	DROP COLUMN MaxSpeed_km_h;
GO



-- c) Add 'No owner' as default value for 'OWNER' in the LaunchSite table
-- NB: Only works if we actually have this column in the Spaceship 
-- table, so we don't execute the above procedure
GO
CREATE PROCEDURE UpgradeToVersion3
AS
	ALTER TABLE LaunchSite
	ADD CONSTRAINT default_owner
	DEFAULT 'No owner' FOR OWNER;
GO



-- Remove 'No owner' constraint
GO
CREATE PROCEDURE DowngradeToVersion2
AS
	ALTER TABLE LaunchSite
	DROP CONSTRAINT default_owner
GO



-- d) Remove 'ID' primary key from the SolarSystem table
-- I don't know the name of the primary key constraint => I have to find it first
SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'SolarSystem' AND CONSTRAINT_TYPE = 'PRIMARY KEY';



-- Now we remove the primary key constraint (and the column itself) from the table SolarSytem
-- Problem: It is referenced in the Planet table, so we must also remove the foreign 
-- key constraint from this table as well
-- Note: After this, the column 'SolarSystemID' from Planet becomes invalid. We could drop it
-- but we will keep it since we'll add it back
GO
CREATE PROCEDURE UpgradeToVersion4
AS
	-- Remove the foreign key constraint from Planet
	ALTER TABLE Planet
	DROP CONSTRAINT FK_Planet_SolarSystemID;
	-- Remove the primary key constraint from SolarSystem
	ALTER TABLE SolarSystem
	DROP CONSTRAINT PK_SolarSystem;
	-- Remove the ID column (the primary key) from SolarSystem
	ALTER TABLE SolarSystem
	DROP COLUMN ID;
GO


GO
CREATE PROCEDURE DowngradeToVersion3
AS
	ALTER TABLE SolarSystem 
	ADD ID INT IDENTITY(1, 1);
	ALTER TABLE SolarSystem 
	ADD CONSTRAINT PK_SolarSystem PRIMARY KEY (ID);
	ALTER TABLE Planet 
	ADD CONSTRAINT FK_Planet_SolarSystemID 
	FOREIGN KEY (SolarSystemID) REFERENCES SolarSystem(ID);
GO



-- e)  Add unique constraint for Location name, so it becomes a candidate key
GO
CREATE PROCEDURE UpgradeToVersion5
AS
	ALTER TABLE Location
	ADD CONSTRAINT UQ_Location_Name UNIQUE (NAME);
GO


GO
CREATE PROCEDURE DowngradeToVersion4
AS
	ALTER TABLE Location
	DROP CONSTRAINT UQ_Location_Name;
GO



-- f) Add the CountryID column as a foreign key 
-- in the Location table (referencing the ID column from the table Country) 
GO
CREATE PROCEDURE UpgradeToVersion6
AS
	ALTER TABLE Location
	ADD CONSTRAINT FK_Location_CountryID 
	FOREIGN KEY (CountryID) REFERENCES Country(ID);
GO

--SELECT CONSTRAINT_NAME
--FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
--WHERE TABLE_NAME = 'Location' AND CONSTRAINT_TYPE = 'FOREIGN KEY';

--SELECT * FROM Location;

--EXEC UpgradeToVersion6;

--EXEC DowngradeToVersion5;

GO
CREATE PROCEDURE DowngradeToVersion5
AS
	ALTER TABLE Location
	DROP CONSTRAINT FK_Location_CountryID;
GO



-- g) Add a new table: Fuel
GO
CREATE PROCEDURE UpgradeToVersion7
AS
	CREATE TABLE Fuel(
		id INT IDENTITY(1, 1) PRIMARY KEY,
		name VARCHAR(64)
	);
GO


GO
CREATE PROCEDURE DowngradeToVersion6
AS
	DROP TABLE Fuel;
GO






-- Now we create the database versioning
-- This table will only have one value at all times
CREATE TABLE DatabaseVersion(
	version INT NOT NULL
);


-- Save the initial state of the database
INSERT INTO DatabaseVersion
VALUES(0);



GO
CREATE PROCEDURE GoToDatabaseVersion @version INT
AS
	DECLARE @current_version INT;	-- the current version of the database
	DECLARE @function_to_apply varchar(64);		-- the name of the function we need to apply to move forward/backward

	SET @current_version = (SELECT TOP 1 DV.version
							FROM DatabaseVersion DV);	-- get the current version of the database from the DatabaseVersion table

	-- if the @version the user wants is higher than the current version, then we need to perform upgrades
	IF @current_version < @version
	BEGIN
		PRINT 'Upgrading...';
	END
	WHILE @current_version < @version
	BEGIN
		SET @current_version = @current_version + 1;
		SET @function_to_apply = 'UpgradeToVersion' + CONVERT(VARCHAR(2), @current_version);
		PRINT 'Will apply function ' + @function_to_apply;
		EXEC @function_to_apply;
	END

	-- if the @version the user wants is lower than the current version, then we need to perform downgrades
	IF @current_version > @version
	BEGIN
		PRINT 'Downgrading...';
	END
	WHILE @current_version > @version
	BEGIN
		SET @current_version = @current_version - 1;
		SET @function_to_apply = 'DowngradeToVersion' + CONVERT(VARCHAR(2), @current_version);
		PRINT 'Will apply function ' + @function_to_apply;
		EXEC @function_to_apply;
	END

	PRINT 'Done.';

	-- update the current database version in the DatabaseVersion table
	UPDATE DatabaseVersion
	SET version = @version;
GO


EXEC GoToDatabaseVersion 4;
-- the versions 1 to 4 will create the following changes:
--		1) The 'DateOfBirth' column from the 'Astronaut' table will be a VARCHAR
--		2) The 'Spaceship' table will have a new column: 'MaxSpeed_km_h'
--		3) The 'OWNER' column from the 'LaunchSite' table will have a default value: 'No owner'
--		4) The table 'SolarSystem' will lose its primary key (ID)


SELECT * FROM DatabaseVersion;	-- this should be set to 4


-- 1)
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Astronaut' AND COLUMN_NAME = 'DateOfBirth';


-- 2)
SELECT *
FROM Spaceship;


-- 3)
SELECT COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'LaunchSite' AND COLUMN_NAME = 'OWNER';


-- 4)
SELECT *
FROM SolarSystem;

SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'SolarSystem' AND CONSTRAINT_TYPE = 'PRIMARY KEY';



-- going back to version 2 will do the following:
--		1) Stays the same as version 4
--		2) Stays the same as version 4
--		3) The column 'OWNER' from the table 'LaunchSite' no longer has a default value
--		4) 'SolarSystem' will regain its primary key (ID)
EXEC GoToDatabaseVersion 2;

-- 1)
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Astronaut' AND COLUMN_NAME = 'DateOfBirth';

-- 2)
SELECT *
FROM Spaceship;


-- 3)
SELECT COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'LaunchSite' AND COLUMN_NAME = 'OWNER';


-- 4)
SELECT *
FROM SolarSystem;

SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'SolarSystem' AND CONSTRAINT_TYPE = 'PRIMARY KEY';





EXEC GoToDatabaseVersion 0;
-- going back to version 0 will do the following:
--		1) The column 'DateOfBirth' from the 'Astronaut' table will be of type DATE
--		2) The 'Spaceship' table will no longer have the column 'MaxSpeed_km_h'
--		3) Stays the same as version 2
--		4) Stays the same as version 2


-- 1)
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Astronaut' AND COLUMN_NAME = 'DateOfBirth';

-- 2)
SELECT *
FROM Spaceship;


-- 3)
SELECT COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'LaunchSite' AND COLUMN_NAME = 'OWNER';


-- 4)
SELECT *
FROM SolarSystem;

SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'SolarSystem' AND CONSTRAINT_TYPE = 'PRIMARY KEY';


