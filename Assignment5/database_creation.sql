--Work on 3 tables of the form Ta(aid, a2, …), Tb(bid, b2, …), Tc(cid, aid, bid, …), where:
--		aid, bid, cid, a2, b2 are integers;
--		the primary keys are underlined;
--		a2 is UNIQUE in Ta;
--		aid and bid are foreign keys in Tc, referencing the primary keys in Ta and Tb, respectively.

CREATE DATABASE BookSales;
USE BookSales;

CREATE TABLE Customer(											-- Ta table
	customer_id INT IDENTITY(1, 1) PRIMARY KEY,					-- aid
	social_security_number INT UNIQUE NOT NULL,					-- a2
	birth_date DATE
);


CREATE TABLE Book(												-- Tb table
	book_id INT IDENTITY(1, 1) PRIMARY KEY,						-- bid
	number_pages INT NOT NULL,									-- b2
	title VARCHAR(64) NOT NULL
);

CREATE TABLE BookSales(											-- Tc table
	sale_id INT IDENTITY(1, 1) PRIMARY KEY,				        -- cid
	customer_id INT REFERENCES Customer(customer_id) NOT NULL,	-- aid
	book_id INT REFERENCES Book(book_id) NOT NULL				-- bid
);
