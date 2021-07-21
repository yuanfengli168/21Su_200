-- CSE 414 -- Relational Data Model
-- Reading: 2.1, 2.2, 2.3
-- 
--
-- 1 Creating tables
--
CREATE TABLE Company
  (cname VARCHAR(20) primary key,
   country VARCHAR(20),
   no_employees INT,
   for_profit CHAR(1));

INSERT INTO Company  VALUES ('GizmoWorks', 'USA',  20000,'y');
INSERT INTO Company  VALUES ('Canon',     'Japan', 50000,'y');
INSERT INTO Company  VALUES ('Hitachi',   'Japan', 30000,'y');
INSERT INTO Company  VALUES('Charity',    'Canada',  500,'n');

SELECT * FROM Company;

-- Making sure SQL Lite shows us the data in a nicer format
-- These commands are specific to SQLite!
.header on
.mode column
.nullvalue NULL

-- 
-- 
-- Comment: upper/lower case; name conflicts
--    -- Company, company, COMPANY  = all the same
--    -- Company(cname, country), Person(pname, country) = repeated 'country' OK
--    -- Company(cname, country), Person(pname, company) = the attribute 'company' not ok

-- Null values: whenever we don't know the value, we can set it to NULL

INSERT INTO Company VALUES('MobileWorks', 'China', NULL, NULL);
SELECT * FROM COMPANY;

-- Deleting tuples from the database:

DELETE FROM Company WHERE cname = 'Hitachi';
SELECT * FROM COMPANY;

DELETE FROM Company WHERE for_profit = 'n';
-- what happens here??

SELECT * FROM Company;

-- cname is a key and SQL will ensure that it is unique:
INSERT INTO Company VALUES('Canon', 'Japan', null, null);
-- Error: UNIQUE constraint failed

-- Alerts: sql lite is REALLY light: it accepts many erroneous commands,
-- which other RDBMS would not accept.  We will flag these as alerts.
-- Alert 1: sqlite allows a key to be null

INSERT INTO Company VALUES(NULL, 'Somewhere', 0, 'n');
SELECT * FROM Company;

-- this is dangerous, since we cannot uniquely identify the tuple
-- better delete it before we get into trouble

DELETE FROM Company WHERE country = 'Somewhere';
SELECT * FROM Company;

-- Discussion in class:
--   tables are NOT ordered. They represent sets or bags.
--   tables do NOT prescribe how they should be implemented: PHYSICAL DATA INDEPENDENCE!
--   tables are FLAT (all attributes are base types)

------------------------------------------
-- 2  Altering a table  in SQL

-- Add/Drop attribute(s)
-- let's drop the for_profit attribute:

-- Note: SQL Lite does not support dropping an attribute:
-- ALTER TABLE Company DROP for_profit;  -- doesn't work

ALTER TABLE Company ADD ceo VARCHAR(20);
SELECT * FROM Company;

UPDATE Company SET ceo='Brown' WHERE cname = 'Canon';

SELECT * FROM Company;

-- A peek at the physical implementation:

-- What happens when you alter a table ?  Consider row-wise and column-wise.

------------------------------------------
-- 3 Multiple Tables, and Keys/Foreign-Keys
-- Now alter Company to add the products that they manufacture.
-- Problem: can't add an attribute that is a LIST OF PRODUCTS. What should we do??
--
--

-- Create a separate table Product, with a foreign key to the company:
CREATE TABLE Product
  (pname VARCHAR(20) PRIMARY KEY,
   price FLOAT,
   category VARCHAR(20),
   manufacturer VARCHAR(20) REFERENCES Company);

-- Alert 2: sqlite does NOT enforce foreign keys by default. To enable
-- foreign keys use the following command. The command will have no
-- effect if your version of SQLite was not compiled with foreign keys
-- enabled. Do not worry about it.

PRAGMA foreign_keys=ON;

INSERT INTO Product VALUES('Gizmo',      19.99, 'gadget', 'GizmoWorks');
INSERT INTO Product VALUES('PowerGizmo', 29.99, 'gadget', 'GizmoWorks');
INSERT into Product VALUES('SingleTouch', 149.99, 'photography', 'Canon');
INSERT into Product VALUES('MultiTouch', 199.99, 'photography', 'MobileWorks');
INSERT into Product VALUES('SuperGizmo', 49.99, 'gadget', 'MobileWorks');

-- now it enforces foreign kyes:
INSERT INTO Product VALUES('Hoverboard', 299.99, 'entertainment', 'NewCompany');

-- Error: FOREIGN KEY constraint failed
