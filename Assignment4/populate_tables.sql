-- The tests will be made on the columns:
--	-> Astronaut (has a single-column primary key and no foreign keys)
--	-> University (has a single-column primary key an one foreign key)
--	-> Astronaut_University (has a multicolumn primary key)

USE SpaceMissionsDatabase;



-- insert @no_rows test records in the Astronaut table
GO;
CREATE PROCEDURE InsertTestRecordsInAstronautTable @no_rows INT
AS
	DECLARE @added_records INT;
	SET @added_records = 0;

	DECLARE @max_id INT;
	SET @max_id = 1;

	DECLARE @random_day INT, @random_month INT, @random_year INT;
	DECLARE @random_date VARCHAR(255);

	WHILE @added_records < @no_rows
		BEGIN
			SET @random_day = FLOOR(RAND() * 29 + 1);
			SET @random_month = FLOOR(RAND() * 12 + 1);
			SET @random_year = FLOOR(RAND() * 80 + 1920);
			SET @random_date = CONVERT(VARCHAR(4), @random_year) + '/' + CONVERT(VARCHAR(2), @random_month) + '/' + CONVERT(VARCHAR(2), @random_day);

			INSERT INTO Astronaut(ID, NAME, DateOfBirth)
			VALUES (@max_id, 'TestAstronaut' + CONVERT(VARCHAR(255), NEWID()), @random_date);

			SET @max_id = @max_id + 1;
			SET @added_records = @added_records + 1;
		END
GO;






-- insert @no_rows test records in the University table
GO;
CREATE PROCEDURE InsertTestRecordsInUniversityTable @no_rows INT
AS
	DECLARE @added_records INT;
	SET @added_records = 0;

	DECLARE @max_id INT;
	SET @max_id = 1;

	DECLARE @random_day INT, @random_month INT, @random_year INT;
	DECLARE @random_date VARCHAR(255);
	DECLARE @random_location_id INT;

	WHILE @added_records < @no_rows
		BEGIN
			SET @random_day = FLOOR(RAND() * 29 + 1);
			SET @random_month = FLOOR(RAND() * 12 + 1);
			SET @random_year = FLOOR(RAND() * 600 + 1400);
			SET @random_date = CONVERT(VARCHAR(4), @random_year) + '/' + CONVERT(VARCHAR(2), @random_month) + '/' + CONVERT(VARCHAR(2), @random_day);

			SET @random_location_id = (SELECT TOP 1 Location.ID
										FROM Location
										ORDER BY NEWID());
			
			INSERT INTO University(ID, NAME, FoundationDate, LocationID)
			VALUES(@max_id, 'TestUniversity' + CONVERT(VARCHAR(255), NEWID()), @random_date, @random_location_id);

			SET @max_id = @max_id + 1;
			SET @added_records = @added_records + 1;
		END
GO;






-- insert @no_rows test records in the Astronaut_University table
-- NOTE: Might not insert exactly @no_rows, but a bit fewer, since it's generating
-- the IDs randomly and we might generate the same IDs multiple times
-- NOTE2: Only works if the tables Astronaut and University have test records in them
-- since this procedure will only add IDs from the test records of those two tables
GO;
CREATE PROCEDURE InsertTestRecordsInAstronaut_UniversityTable @no_rows INT
AS
	DECLARE @added_records INT, @time_taken INT;
	SET @added_records = 0;

	DECLARE @university_id INT, @astronaut_id INT;

	DECLARE @t1 DATETIME, @t2 DATETIME;

	SET @t1 = GETDATE();
	WHILE @added_records < @no_rows
		BEGIN
			SET @university_id = (SELECT TOP 1 University.ID
									FROM University
									ORDER BY NEWID());
			SET @astronaut_id = (SELECT TOP 1 Astronaut.ID
									FROM Astronaut
									ORDER BY NEWID());

			IF NOT EXISTS (SELECT * FROM Astronaut_University AS AU
							WHERE AU.AstronautID = @astronaut_id AND AU.UniversityID = @university_id)
				BEGIN
					INSERT INTO Astronaut_University(AstronautID, UniversityID)
					VALUES(@astronaut_id, @university_id);

					SET @added_records = @added_records + 1;
				END

			-- If the while loop takes too long (5 seconds here, can change) it means that the given @no_rows is
			-- too large, there aren't enough test records in the Astronaut and University tables
			-- => it will insert as many as it can (in 5 seconds) and then exit the loop
			SET @t2 = GETDATE();
			SET @time_taken = (SELECT DATEDIFF(SECOND, @t1, @t2));
			IF @time_taken > 5
				BEGIN
					BREAK;
				END
		END
GO;




-- remove all test records from a table
GO;
CREATE PROCEDURE DeleteTestRecordsInTable @table_name VARCHAR(255)
AS
	EXEC('DELETE FROM ' + @table_name);
GO;



EXEC DeleteTestRecordsInTable 'Astronaut_University';
EXEC DeleteTestRecordsInTable 'Astronaut';
EXEC DeleteTestRecordsInTable 'University';



EXEC InsertTestRecordsInUniversityTable 10;
EXEC InsertTestRecordsInAstronautTable 10;
EXEC InsertTestRecordsInAstronaut_UniversityTable 10;

SELECT *
FROM Astronaut;


SELECT *
FROM University;

SELECT *
FROM Astronaut_University;







-- CREATING THE VIEWS

-- a view with a SELECT statement operating on one table:
-- We'll have a view which shows all senior astronauts (age >= 60)
GO;
CREATE VIEW SeniorAstronautsView AS
SELECT Astronaut.NAME, Astronaut.DateOfBirth
FROM Astronaut
WHERE DATEDIFF(YEAR, Astronaut.DateOfBirth, GETDATE()) >= 60;
GO;

SELECT *
FROM SeniorAstronautsView;





-- a view with a SELECT statement operating on at least 2 tables:
-- A view which will show all the universities along with their respective countries

GO;
CREATE VIEW UniversityCountryView AS
SELECT University.NAME AS University, Country.NAME AS Country
FROM University
		INNER JOIN Location ON University.LocationID = Location.ID
		INNER JOIN Country ON Country.ID = Location.CountryID;
GO;

SELECT *
FROM UniversityCountryView;





-- a view with a SELECT statement that has a GROUP BY clause and operates on at least 2 tables

GO;
CREATE VIEW UniversityAstronautCountView AS
SELECT University.NAME, COUNT(Astronaut.ID) AS AstronautCount
FROM University 
		INNER JOIN Astronaut_University ON University.ID = Astronaut_University.UniversityID
		INNER JOIN Astronaut ON Astronaut.ID = Astronaut_University.AstronautID
GROUP BY University.NAME
GO;

SELECT *
FROM UniversityAstronautCountView;





