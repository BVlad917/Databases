CREATE DATABASE SpaceFlightsDatabase;

USE SpaceFlightsDatabase;

SELECT DB_NAME();

SELECT * FROM SpaceMission;
SELECT * FROM Astronaut;
SELECT * FROM SpaceMission_Astronaut;


CREATE TABLE Spaceship(
	ID int PRIMARY KEY NOT NULL,
	NAME varchar(255),
	HEIGHT_meters float,
	MASS_tons float
);

CREATE TABLE LaunchSite(
	ID int PRIMARY KEY NOT NULL,
	OWNER varchar(255),
	NAME varchar(255),
	CityID varchar(255)
);

CREATE TABLE Astronaut(
	ID int PRIMARY KEY NOT NULL,
	NAME varchar(255),
	DateOfBirth date,
);

CREATE TABLE University(
	ID int PRIMARY KEY NOT NULL,
	NAME varchar(255),
	FoundationDate date,
	LocationID int
);

CREATE TABLE SpaceMission(
	ID int PRIMARY KEY NOT NULL,
	NAME varchar(255),
	TYPE varchar(255),
	HumanCrewNumber int,
	LaunchDate date,
	ReturnDate date,
	LaunchSiteID int,
	SpaceshipID int,
	Returned varchar(255),
	DuringColdWar varchar(255)
);

CREATE TABLE Planet(
	ID int PRIMARY KEY NOT NULL,
	NAME varchar(255),
	SolarSystemID int,
	RotationPeriod_EarthDays float,
	RevolutionPeriod_EarthYears float
);

CREATE TABLE Satellite(
	ID int PRIMARY KEY NOT NULL,
	NAME varchar(255),
	PlanetID int,
	MASS_EarthMasses float,
	OrbitalPeriod_EarthHours float
);

CREATE TABLE SolarSystem(
	ID int PRIMARY KEY NOT NULL,
	NAME varchar(255),
	NumberOfPlanets int,
);

CREATE TABLE City(
	ID int PRIMARY KEY NOT NULL,
	NAME varchar(255),
	CountryID int
);

CREATE TABLE Country(
	ID int PRIMARY KEY NOT NULL,
	NAME varchar(255)
);


-- ADDING THE FOREIGN KEYS TO THE TABLES --


-- 1:n relationship between LaunchSite and SpaceMission:
--		one launch site can be the place where multiple space missions launched
--		one space mission can launch from one launch site

ALTER TABLE SpaceMission
ADD LaunchSiteID int FOREIGN KEY REFERENCES LaunchSite(ID)  ON UPDATE CASCADE;

-- n:m relationship between Astronaut and University
--		one astronaut can be the graduate of multiple universities
--		one university can be the place where multiple astronauts graduated

CREATE TABLE Astronaut_University(
	AstronautID int FOREIGN KEY REFERENCES Astronaut(ID) ON UPDATE CASCADE,
	UniversityID int FOREIGN KEY REFERENCES University(ID) ON UPDATE CASCADE
);

ALTER TABLE Astronaut_University
ADD CONSTRAINT astronaut_university_unique UNIQUE (AstronautID, UniversityID);

-- n:m relationship between SpaceMission and Planet
--		one space mission can study/visit multiple planets
--		one planet can be studied/visited by multiple space missions

CREATE TABLE SpaceMission_Planet(
	SpaceMissionID int FOREIGN KEY REFERENCES SpaceMission(ID) ON UPDATE CASCADE,
	PlanetID int FOREIGN KEY REFERENCES Planet(ID) ON UPDATE CASCADE
);


ALTER TABLE SpaceMission_Planet
ADD CONSTRAINT spacemission_planet_unique UNIQUE (SpaceMissionID, PlanetID);

-- n:m relationship between SpaceMission and Astronaut
--		one space mission can have multiple astronauts
--		it is possible that one astronaut participated in multiple space missions

CREATE TABLE SpaceMission_Astronaut(
	SpaceMissionID int FOREIGN KEY REFERENCES SpaceMission(ID) ON UPDATE CASCADE,
	AstronautID int FOREIGN KEY REFERENCES Astronaut(ID) ON UPDATE CASCADE
);

ALTER TABLE SpaceMission_Astronaut
ADD CONSTRAINT spacemission_astronaut_unique UNIQUE (SpaceMissionID, AstronautID);

-- n:m relationship between SpaceMission and Satellite
--		one space mission can study/visit multiple satellites
--		one satellite can be studied/visited by multiple space missions

CREATE TABLE SpaceMission_Satellite(
	SpaceMissionID int FOREIGN KEY REFERENCES SpaceMission(ID) ON UPDATE CASCADE,
	SatelliteID int FOREIGN KEY REFERENCES Satellite(ID) ON UPDATE CASCADE
);

ALTER TABLE SpaceMission_Satellite
ADD CONSTRAINT spacemission_satellite_unique UNIQUE (SpaceMissionID, SatelliteID);

-- 1:n relationship between LaunchSite and City
--		one launch site can be located in only one city
--		one city can have multiple launch sites

ALTER TABLE LaunchSite
ADD CityID int FOREIGN KEY REFERENCES City(ID) ON UPDATE CASCADE;

-- 1:n relationship between City and Country
--		one city belongs to one country
--		one country can have multiple cities

ALTER TABLE City
ADD CountryID int FOREIGN KEY REFERENCES Country(ID) ON UPDATE CASCADE;

-- 1:n relationship between Satellite and Planet
--		one satellite belongs to one planet
--		one planet can have multiple satellites

ALTER TABLE Satellite
ADD PlanetID int FOREIGN KEY REFERENCES Planet(ID) ON UPDATE CASCADE;

-- 1:n relationship between Planet and Solar System
--		one planet belongs to one solar system
--		one solar system can have multiple planets

ALTER TABLE Planet
ADD SolarSystemID int FOREIGN KEY REFERENCES SolarSystem(ID) ON UPDATE CASCADE;

-- 1:n relationship between SpaceMission and Spaceships
--		one space mission is carried out by one spaceship
--		one spaceship might have carried out multiple space missions

ALTER TABLE SpaceMission
ADD SpaceshipID int FOREIGN KEY REFERENCES Spaceship(ID) ON UPDATE CASCADE;

--ALTER TABLE SpaceMission
--DROP CONSTRAINT FK__SpaceMiss__Space__59FA5E80;
--
--ALTER TABLE SpaceMission
--DROP COLUMN SpaceMissionID;

-- 1:n relationship between city and university
--		one university belongs to one city
--		one city might have multiple universities

ALTER TABLE University
ADD LocationID int FOREIGN KEY REFERENCES Location(ID) ON UPDATE CASCADE;



-- ADDING VALUES

-- Add Solar Systems

INSERT INTO SolarSystem(ID, NAME, NumberOfPlanets)
VALUES(1, 'The Solar System', 8);

INSERT INTO SolarSystem(ID, NAME, NumberOfPlanets)
VALUES(2, 'Proxima Centauri', 2);

INSERT INTO SolarSystem(ID, NAME, NumberOfPlanets)
VALUES(3, 'Trappist-1', 7);


-- Add Planets

INSERT INTO Planet(ID, NAME, SolarSystemID, RotationPeriod_EarthDays, RevolutionPeriod_EarthYears)
VALUES(1, 'Earth', 1, 1, 1);

INSERT INTO Planet(ID, NAME, SolarSystemID, RotationPeriod_EarthDays, RevolutionPeriod_EarthYears)
VALUES(2, 'Mars', 1, 1.025, 1.88);

INSERT INTO Planet(ID, NAME, SolarSystemID, RotationPeriod_EarthDays, RevolutionPeriod_EarthYears)
VALUES(3, 'Jupiter', 1, 0.417, 11.78);

INSERT INTO Planet(ID, NAME, SolarSystemID, RotationPeriod_EarthDays, RevolutionPeriod_EarthYears)
VALUES(4, 'Saturn', 1, 0.45, 29);


-- Add Satellites

--ALTER TABLE Satellite
--ADD OrbitalPeriod_EarthDays float;

--EXEC sp_RENAME 'Satellite.MASS_EarthMasses' , 'MASS_EarthMoonMasses', 'COLUMN';

INSERT INTO Satellite(ID, NAME, PlanetID, MASS_EarthMoonMasses, OrbitalPeriod_EarthDays)
VALUES(1, 'The Moon', 1, 1, 27);

INSERT INTO Satellite(ID, NAME, PlanetID, MASS_EarthMoonMasses, OrbitalPeriod_EarthDays)
VALUES(2, 'Io', 3, 1.21, 1.77);

INSERT INTO Satellite(ID, NAME, PlanetID, MASS_EarthMoonMasses, OrbitalPeriod_EarthDays)
VALUES(3, 'Europa', 3, 0.95, 3.54);

INSERT INTO Satellite(ID, NAME, PlanetID, MASS_EarthMoonMasses, OrbitalPeriod_EarthDays)
VALUES(4, 'Titan', 4, 1.82, 16);




-- Add Spaceships

INSERT INTO Spaceship(ID, NAME, HEIGHT_meters, MASS_tons)
VALUES(1, 'Saturn V', 110.6, 3.03);

INSERT INTO Spaceship(ID, NAME, HEIGHT_meters, MASS_tons)
VALUES(2, 'Titan IV', 55, 0.94);

INSERT INTO Spaceship(ID, NAME, HEIGHT_meters, MASS_tons)
VALUES(3, 'Titan IIIE', 48.8, 0.63);



-- Add Countries

INSERT INTO Country(ID, NAME)
VALUES(1, 'USA');

INSERT INTO Country(ID, NAME)
VALUES(2, 'Russia');

INSERT INTO Country(ID, NAME)
VALUES(3, 'China');

INSERT INTO Country(ID, NAME)
VALUES(4, 'Romania');



-- Add Locations

INSERT INTO Location(ID, NAME, CountryID)
VALUES(1, 'Merritt Island', 1);

INSERT INTO Location(ID, NAME, CountryID)
VALUES(2, 'Cape Canaveral', 1);

INSERT INTO Location(ID, NAME, CountryID)
VALUES(3, 'Lompoc', 1);

--exec sp_rename 'dbo.City', 'Location';

INSERT INTO Location(ID, NAME, CountryID)
VALUES(4, 'West Lafayette', 1);

INSERT INTO Location(ID, NAME, CountryID)
VALUES(5, 'Los Angeles', 1);

INSERT INTO Location(ID, NAME, CountryID)
VALUES(6, 'West Point', 1);

INSERT INTO Location(ID, NAME, CountryID)
VALUES(7, 'Cambridge', 1);

INSERT INTO Location(ID, NAME, CountryID)
VALUES(8, 'Xichang', 3);


SELECT * FROM Location;




-- Add Universities

--ALTER TABLE University
--DROP COLUMN CITY;

--ALTER TABLE University
--DROP COLUMN COUNTRY;


INSERT INTO University(ID, NAME, FoundationDate, CityID)
VALUES(1, 'Purdue University', '18690506', 4);


INSERT INTO University(ID, NAME, FoundationDate, CityID)
VALUES(2, 'Massachusetts Institute of Technology', '18610410', 7);

INSERT INTO University(ID, NAME, FoundationDate, CityID)
VALUES(3, 'United States Military Academy', '18020316', 6);

INSERT INTO University(ID, NAME, FoundationDate, CityID)
VALUES(4, 'University of Southern California', '18801006', 5);



-- Add Astronauts

INSERT INTO Astronaut(ID, NAME, DateOfBirth)
VALUES(1, 'Michael Collins', '19301031');

INSERT INTO Astronaut(ID, NAME, DateOfBirth)
VALUES(2, 'Buzz Aldrin', '19300120');

INSERT INTO Astronaut(ID, NAME, DateOfBirth)
VALUES(3, 'Neil Armstrong', '19300805');


-- Add Launch Sites

INSERT INTO LaunchSite(ID, OWNER, NAME, CityID)
VALUES(1, 'USA Department of Defense', 'Cape Canaveral Space Force Station', 2);

INSERT INTO LaunchSite(ID, OWNER, NAME, CityID)
VALUES(2, 'NASA', 'Kennedy Space Center', 1);

INSERT INTO LaunchSite(ID, OWNER, NAME, CityID)
VALUES(3, 'CCP', 'Xichang Satellite Launch Center', 8);



-- Add Space Missions

INSERT INTO SpaceMission(ID, NAME, TYPE, HumanCrewNumber, LaunchDate, ReturnDate, LaunchSiteID, SpaceshipID)
VALUES(1, 'Apollo 11', 'Crewed lunar landing', 3, '19690716', '19690724', 2, 1);

INSERT INTO SpaceMission(ID, NAME, TYPE, HumanCrewNumber, LaunchDate, ReturnDate, LaunchSiteID, SpaceshipID)
VALUES(2, 'Voyager 1', 'Outer planetary, heliosphere, and interstellar medium exploration', 0, '19770905', NULL, 1, 3);

INSERT INTO SpaceMission(ID, NAME, TYPE, HumanCrewNumber, LaunchDate, ReturnDate, LaunchSiteID, SpaceshipID)
VALUES(3, 'Voyager 2', 'Planetary exploration', 0, '19770820', NULL, 1, 3);

INSERT INTO SpaceMission(ID, NAME, TYPE, HumanCrewNumber, LaunchDate, ReturnDate, LaunchSiteID, SpaceshipID)
VALUES(4, 'Cassini–Huygens', 'Cassini: Saturn orbiter; Huygens: Titan lander', 0, '19971015', NULL, 1, 2);


-- Create links between astronauts and universities

SELECT * FROM University;
SELECT * FROM Astronaut;

INSERT INTO Astronaut_University(AstronautID, UniversityID)
VALUES(1, 3);

INSERT INTO Astronaut_University(AstronautID, UniversityID)
VALUES(2, 3);

INSERT INTO Astronaut_University(AstronautID, UniversityID)
VALUES(2, 2);

INSERT INTO Astronaut_University(AstronautID, UniversityID)
VALUES(3, 1);

INSERT INTO Astronaut_University(AstronautID, UniversityID)
VALUES(3, 4);

SELECT * FROM Astronaut_University;



-- Create links between Space Missions and Astronauts

SELECT * FROM SpaceMission;
SELECT * FROM Astronaut;


INSERT SpaceMission_Astronaut(SpaceMissionID, AstronautID)
VALUES(1, 1);

INSERT SpaceMission_Astronaut(SpaceMissionID, AstronautID)
VALUES(1, 2);

INSERT SpaceMission_Astronaut(SpaceMissionID, AstronautID)
VALUES(1, 3);


-- Create links between Space Missions and Planets

SELECT * FROM Planet;
SELECT * FROM SpaceMission;

INSERT SpaceMission_Planet(SpaceMissionID, PlanetID)
VALUES(2, 3);

INSERT SpaceMission_Planet(SpaceMissionID, PlanetID)
VALUES(2, 4);

INSERT SpaceMission_Planet(SpaceMissionID, PlanetID)
VALUES(3, 3);

INSERT SpaceMission_Planet(SpaceMissionID, PlanetID)
VALUES(3, 4);

INSERT SpaceMission_Planet(SpaceMissionID, PlanetID)
VALUES(4, 4);




-- Create links between Space Missions and Satellites

SELECT * FROM SpaceMission;
SELECT * FROM Satellite;

INSERT SpaceMission_Satellite(SpaceMissionID, SatelliteID)
VALUES(1, 1);

INSERT SpaceMission_Satellite(SpaceMissionID, SatelliteID)
VALUES(4, 4);

INSERT SpaceMission_Satellite(SpaceMissionID, SatelliteID)
VALUES(2, 2);

INSERT SpaceMission_Satellite(SpaceMissionID, SatelliteID)
VALUES(3, 3);
