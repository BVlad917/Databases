--a. Write queries on Ta such that their execution plans contain the following operators:
--		clustered index scan;
--		clustered index seek;
--		nonclustered index scan;
--		nonclustered index seek;
--		key lookup.

-- table Ta = Customer table

SET STATISTICS TIME, IO ON;

DBCC FreeProcCache;
DBCC DropCleanBuffers;


-- clustered index scan
SELECT *
FROM Customer
WHERE Customer.social_security_number >= 500000000;


-- clustered index seek;
SELECT *
FROM Customer
WHERE Customer.customer_id = 11;



CREATE NONCLUSTERED INDEX IX_tblCustomer_BirthDate
ON Customer(birth_date);


-- nonclustered index scan;
SELECT Customer.birth_date
FROM Customer
WHERE MONTH(Customer.birth_date) >= 7;


-- nonclustered index seek;
SELECT Customer.birth_date
FROM Customer
WHERE Customer.birth_date BETWEEN '2001/5/19' AND '2001/5/22';


-- key lookup.
SELECT *
FROM Customer
WHERE Customer.birth_date = '2001/05/21';



DROP INDEX IX_tblCustomer_BirthDate ON Customer;

