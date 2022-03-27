USE SpaceMissionsDatabase;



-- Tests – holds data about different test configurations;
CREATE TABLE Tests (
	test_id INT IDENTITY(1, 1) NOT NULL,
	name NVARCHAR(64) NOT NULL
);

ALTER TABLE Tests WITH NOCHECK
ADD CONSTRAINT PK_Tests PRIMARY KEY (test_id);



-- Tables – holds data about tables that might take part in a test;
CREATE TABLE Tables (
	table_id INT IDENTITY(1, 1) NOT NULL,
	name NVARCHAR(64) NOT NULL
);

ALTER TABLE Tables WITH NOCHECK
ADD CONSTRAINT PK_Tables PRIMARY KEY (table_id);



-- TestTables – link table between Tests and Tables (which tables take part in which tests);
CREATE TABLE TestTables (
	test_id INT NOT NULL,
	table_id INT NOT NULL,
	no_of_rows INT NOT NULL,
	position INT NOT NULL
);

ALTER TABLE TestTables WITH NOCHECK
ADD CONSTRAINT PK_TestTables PRIMARY KEY (test_id, table_id);

ALTER TABLE TestTables ADD 
CONSTRAINT FK_TestTables_Tables FOREIGN KEY (table_id) REFERENCES Tables(table_id)
ON DELETE CASCADE
ON UPDATE CASCADE,

CONSTRAINT FK_TestTables_Tests FOREIGN KEY (test_id) REFERENCES Tests(test_id)
ON DELETE CASCADE
ON UPDATE CASCADE;



-- Views – holds data about a set of views from the database, used to assess the performance 
--         of certain SQL queries;

CREATE TABLE Views (
	view_id INT IDENTITY(1, 1) NOT NULL,
	name NVARCHAR(64) NOT NULL
);

ALTER TABLE Views WITH NOCHECK
ADD CONSTRAINT PK_Views PRIMARY KEY (view_id);



-- TestViews – link table between Tests and Views (which views take part in which tests);
CREATE TABLE TestViews (
	test_id INT NOT NULL,
	view_id INT NOT NULL
);

ALTER TABLE TestViews WITH NOCHECK
ADD CONSTRAINT PK_TestViews PRIMARY KEY (test_id, view_id);

ALTER TABLE TestViews ADD
CONSTRAINT FK_TestViews_Tests FOREIGN KEY (test_id) REFERENCES Tests(test_id)
ON DELETE CASCADE
ON UPDATE CASCADE,

CONSTRAINT FK_TestViews_Views FOREIGN KEY (view_id) REFERENCES Views(view_id)
ON DELETE CASCADE
ON UPDATE CASCADE;



-- TestRuns – contains data about different test runs; each test run involves:
--            1) deleting the data from the test’s tables – in the order specified 
--               by the Position field (table TestTables);
--            2) inserting data into the test’s tables – reverse deletion order; the
--               number of records to insert is stored in the NoOfRows field (table TestTables);
--            3) evaluating the test’s views;

CREATE TABLE TestRuns (
	test_run_id INT IDENTITY(1, 1) NOT NULL,
	description NVARCHAR(2048) NULL,
	start_at DATETIME NULL,
	end_at DATETIME NULL
);


ALTER TABLE TestRuns WITH NOCHECK
ADD CONSTRAINT PK_TestRuns PRIMARY KEY (test_run_id);



-- TestRunTables – contains performance data for INSERT operations for every table in the test;
CREATE TABLE TestRunTables (
	test_run_id INT NOT NULL,
	table_id INT NOT NULL,
	start_at DATETIME NOT NULL,
	end_at DATETIME NOT NULL
);

ALTER TABLE TestRunTables WITH NOCHECK
ADD CONSTRAINT PK_TestRunTables PRIMARY KEY (test_run_id, table_id);


ALTER TABLE TestRunTables
ADD CONSTRAINT FK_TestRunTables_Tables FOREIGN KEY (table_id) REFERENCES Tables(table_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE TestRunTables
ADD CONSTRAINT FK_TestRunTables_TestRuns FOREIGN KEY (test_run_id) REFERENCES TestRuns(test_run_id)
ON DELETE CASCADE
ON UPDATE CASCADE;



-- TestRunViews – contains performance data for every view in the test.
CREATE TABLE TestRunViews (
	test_run_id INT NOT NULL,
	view_id INT NOT NULL,
	start_at DATETIME NOT NULL,
	end_at DATETIME NOT NULL
);

ALTER TABLE TestRunViews WITH NOCHECK
ADD CONSTRAINT PK_TestRunViews PRIMARY KEY (test_run_id, view_id);

ALTER TABLE TestRunViews
ADD CONSTRAINT FK_TestRunViews_Views FOREIGN KEY (view_id) REFERENCES Views(view_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE TestRunViews
ADD CONSTRAINT FK_TestRunViews_TestRuns FOREIGN KEY (test_run_id) REFERENCES TestRuns(test_run_id)
ON DELETE CASCADE
ON UPDATE CASCADE;




