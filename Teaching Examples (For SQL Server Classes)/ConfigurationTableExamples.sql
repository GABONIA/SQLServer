/*

Building a config table for easy changes

*/

-- Table is only for testing purposes
CREATE TABLE BusinessBilling(
	TestValues INT
)

INSERT INTO BusinessBilling VALUES (1),(2),(3),(4)

-- This is our configuration table
CREATE TABLE ConfigTable(
	TableName VARCHAR(50),
	Code VARCHAR(500)
)

INSERT INTO ConfigTable VALUES('BusinessBilling','Bill1'),('ResidentialBilling','Bill2'),('SpecialBilling','Bill3')

DECLARE @table VARCHAR(50)
SELECT @table = TableName FROM ConfigTable WHERE Purpose = 'Bill1'

DECLARE @dyn NVARCHAR(4000)
SET @dyn = 'SELECT * FROM ' + @table

EXECUTE(@dyn)