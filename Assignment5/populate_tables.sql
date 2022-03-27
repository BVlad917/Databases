USE BookSales;

-- Populate the Books table
GO;
CREATE PROCEDURE populateBookTable @no_records INT
AS
	DECLARE @added_records INT = 0, @next_book_id INT = 1;
	DECLARE @number_pages INT, @title VARCHAR(64);

	WHILE @added_records < @no_records
		BEGIN
			SET @number_pages = FLOOR(RAND() * 771 + 30);	-- random number of pages in the range [30, 801] 
			SET @title = 'Book' + CONVERT(VARCHAR(10), @next_book_id);
			INSERT INTO Book(number_pages, title) VALUES(@number_pages, @title);

			SET @next_book_id = @@IDENTITY + 1;
			SET @added_records = @added_records + 1;
		END
GO;

EXEC populateBookTable 10;

SELECT *
FROM Book;

DELETE FROM Book;




-- Populate the Customers table
GO;
CREATE PROCEDURE populateCustomerTable @no_rows INT
AS
	DECLARE @added_records INT = 0, @social_security_number INT;
	DECLARE @random_day INT, @random_month INT, @random_year INT;
	DECLARE @random_date VARCHAR(255);

	WHILE @added_records < @no_rows
		BEGIN
			SET @random_day = FLOOR(RAND() * 28 + 1);
			SET @random_month = FLOOR(RAND() * 12 + 1);
			SET @random_year = FLOOR(RAND() * 84 + 1920);
			SET @random_date = CONVERT(VARCHAR(4), @random_year) + '/' + CONVERT(VARCHAR(2), @random_month) + '/' + CONVERT(VARCHAR(2), @random_day);

			SET @social_security_number = FLOOR(RAND() * 900000000 + 100000000);
			IF EXISTS (SELECT * FROM Customer WHERE Customer.social_security_number = @social_security_number)
				BEGIN
					CONTINUE;
				END
			
			INSERT INTO Customer(social_security_number, birth_date) VALUES(@social_security_number, @random_date);
			SET @added_records = @added_records + 1;
		END
GO;

EXEC populateCustomerTable 20;

SELECT *
FROM Customer;

DELETE FROM Customer;





-- Populate the BookSales table
GO;
CREATE PROCEDURE populateBookSalesTable @no_rows INT
AS
	DECLARE @added_rows INT = 0;
	DECLARE @customer_id INT = 0, @book_id INT = 0;

	WHILE @added_rows < @no_rows
		BEGIN
			SET @customer_id = (SELECT TOP 1 Customer.customer_id
								FROM Customer
								ORDER BY NEWID());
			SET @book_id = (SELECT TOP 1 Book.book_id
							FROM Book
							ORDER BY NEWID());
			INSERT INTO BookSales(customer_id, book_id) VALUES(@customer_id, @book_id);

			SET @added_rows = @added_rows + 1;
		END
GO;

EXEC populateBookTable 10;
EXEC populateCustomerTable 10;
EXEC populateBookSalesTable 20;


SELECT *
FROM BookSales;




DELETE FROM BookSales;
DELETE FROM Book;

DELETE FROM Customer;

DBCC CHECKIDENT ('Book', RESEED, 0);
DBCC CHECKIDENT ('Customer', RESEED, 0);
DBCC CHECKIDENT ('BookSales', RESEED, 0);


EXEC populateBookTable 10;			-- 17 758 ms ~ 18 sec
EXEC populateCustomerTable 10;		-- 31 613 ms ~ 32 sec (Customer table has a unique field (other than the PK) so it has 2 indexes => inserts take more time)
EXEC populateBookSalesTable 10;		-- 108 165 ms ~ 1:48 min (BookSales table has to select a random row from both Book and Customer tables at each insert => more time)


SELECT * FROM Book;
SELECT * FROM Customer;
SELECT * FROM BookSales;

SELECT COUNT(*) FROM Book;