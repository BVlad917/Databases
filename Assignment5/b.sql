-- b. Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan. 
--	  Create a nonclustered index that can speed up the query. Examine the execution plan again.

-- table Tb = Book table
-- b2 = number_pages

SELECT Book.title
FROM Book
WHERE Book.number_pages = 105;



CREATE NONCLUSTERED INDEX IX_tblBook_Title
ON Book(number_pages)
INCLUDE (title);



SET STATISTICS TIME, IO ON;


SELECT Book.title
FROM Book
WHERE Book.number_pages = 105;


DROP INDEX IX_tblBook_Title ON Book;


-- Note: If we change the desired number of pages from 508 to something else (or change the data such that there will be more books
--       with 508 pages in them) the database optimizer might choose to NOT use the nonclustered index because there are so many records 
--       to return so it goes with the cheaper plan of just scanning the whole table
