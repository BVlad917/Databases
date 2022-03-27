USE SpaceFlightsDatabase;

-- INSERT DATA 

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


-- Add Locations

INSERT INTO Location(ID, NAME, CountryID)
VALUES(1, 'Merritt Island', 1);

INSERT INTO Location(ID, NAME, CountryID)
VALUES(2, 'Cape Canaveral', 1);

INSERT INTO Location(ID, NAME, CountryID)
VALUES(3, 'Lompoc', 1);

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

INSERT INTO Location
VALUES(9, 'Saratov', 2);

-- Add Countries

INSERT INTO Country(ID, NAME)
VALUES(1, 'USA');

INSERT INTO Country(ID, NAME)
VALUES(2, 'Russia');

INSERT INTO Country(ID, NAME)
VALUES(3, 'China');

INSERT INTO Country(ID, NAME)
VALUES(4, 'Romania');


-- Add Universities

INSERT INTO University(ID, NAME, FoundationDate, LocationID)
VALUES(1, 'Purdue University', '18690506', NULL);

INSERT INTO University(ID, NAME, FoundationDate, LocationID)
VALUES(2, 'Massachusetts Institute of Technology', '18610410', NULL);

INSERT INTO University(ID, NAME, FoundationDate, LocationID)
VALUES(3, 'United States Military Academy', '18020316', NULL);

INSERT INTO University(ID, NAME, FoundationDate, LocationID)
VALUES(4, 'University of Southern California', '18801006', NULL);

INSERT INTO University(ID, NAME, FoundationDate, LocationID)
VALUES(5, 'Saratov Technical College', '19301006', NULL);


-- Add Astronauts

INSERT INTO Astronaut(ID, NAME, DateOfBirth)
VALUES(1, 'Michael Collins', '19301031');

INSERT INTO Astronaut(ID, NAME, DateOfBirth)
VALUES(2, 'Buzz Aldrin', '19300120');

INSERT INTO Astronaut(ID, NAME, DateOfBirth)
VALUES(3, 'Neil Armstrong', '19300805');

INSERT INTO Astronaut 
VALUES(3, 'Yuri Gagarin', '19340309');

INSERT INTO Astronaut 
VALUES(4, 'Yuri Gagarin', '19340309');

INSERT INTO Astronaut
VALUES(5, 'Valentina Tereshkova', '19370306');

INSERT INTO Astronaut
VALUES(6, 'James Lovell', '19280325');

INSERT INTO Astronaut
VALUES(7, 'Sally Ride', '19510326');

INSERT INTO Astronaut
VALUES(8, 'Chris Hadfield', '19590829');



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




-- INSERTS WHICH VIOLATE REFERENTIAL INTEGRITY CONSTRAINTS

SELECT * FROM Country;

INSERT INTO Location(ID, NAME, CountryID)
VALUES(10, 'Cluj-Napoca', 5);	-- NO COUNTRY WITH ID 5

INSERT INTO Location(ID, NAME, CountryID)
VALUES(10, 'Cluj-Napoca', 4);	




INSERT INTO Planet(ID, NAME, RevolutionPeriod_EarthYears, RotationPeriod_EarthDays, SolarSystemID)
VALUES(5, 'Neptune', 165, 0.67, 4);    -- No solar system with ID 4

INSERT INTO Planet(ID, NAME, RevolutionPeriod_EarthYears, RotationPeriod_EarthDays, SolarSystemID)
VALUES(5, 'Neptune', 165, 0.67, 1);

