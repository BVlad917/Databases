-- c. Create a view that joins at least 2 tables. 
--    Check whether existing indexes are helpful; if not, reassess existing indexes / examine the cardinality of the tables.

USE BookSales;

SET STATISTICS TIME, IO ON;

DBCC FreeProcCache;
DBCC DropCleanBuffers;

-- So far, we have created 2 indexes:

CREATE NONCLUSTERED INDEX IX_tblCustomer_BirthDate
ON Customer(birth_date)
INCLUDE (customer_id);

CREATE NONCLUSTERED INDEX IX_tblBook_Title
ON Book(number_pages)
INCLUDE (title);

--

DROP INDEX IX_tblCustomer_BirthDate ON Customer;

DROP INDEX IX_tblBook_Title ON Book;


-- For each customer born in March 1998, print the book that customer bought
GO;
CREATE VIEW View1 AS
SELECT C.customer_id, B.title
FROM Book B 
		INNER JOIN BookSales BS ON B.book_id = BS.book_id
		INNER JOIN Customer C ON C.customer_id = BS.customer_id
WHERE C.birth_date BETWEEN '1998-03-01' AND '1998-03-30';
GO;

SELECT * FROM View1;


-- Average execution time without the indexes: 28.5 ms
-- Average execution time with the indexes: 21 ms

-- Indexes don't help that much in this case





-- Find the number of books customer with a certain social security number bought
GO;
CREATE VIEW View2 AS
SELECT C.customer_id, COUNT(*) no_books_bought
FROM Customer C INNER JOIN BookSales BS ON BS.customer_id = C.customer_id
WHERE C.social_security_number = 147119636
GROUP BY C.customer_id
GO;

SELECT * FROM View2;

-- Average execution time without the indexes: 18.2 ms
-- Average execution time without the indexes: 17.7

CREATE NONCLUSTERED INDEX IX_tblBookSales_CustomerId
ON BookSales(customer_id)

DROP INDEX IX_tblBookSales_CustomerId ON BookSales;

-- Indexes don't help that much here either

-- Conclusion: Indexes can help here, but not a lot since the inner joins are done on primary key columns and those columns
--			   create an index implicitly

