/* 

Truncate tables (clean tables under certain schemas for moving databases into DEV from PROD (avoid NPI data)

*/

/*

-- Populate random data (NOTE - ON A NEW DATABASE ONLY):

CREATE TABLE TableOne(
  ID INT IDENTITY(1,1),
	ValueOne INT
)

CREATE TABLE TableTwo(
	ID INT IDENTITY(1,1),
	ValueTwo VARCHAR(100)
)

CREATE TABLE TableThree(
	ID INT IDENTITY(1,1),
	ValueThree VARCHAR(10)
)

DECLARE @begin INT = 1

WHILE @begin <= 10000
BEGIN
	
	INSERT INTO TableOne (ValueOne)
	SELECT (RAND()*10000)

	INSERT INTO TableTwo (ValueTwo)
	SELECT NEWID()

	INSERT INTO TableThree (ValueThree)
	SELECT SUBSTRING(REPLACE(NEWID(),'-',''),1,10)

	SET @begin = @begin + 1

END

SELECT COUNT(*)
FROM TableOne

SELECT COUNT(*)
FROM TableTwo

SELECT COUNT(*)
FROM TableThree

*/


DECLARE @Clean TABLE(
	TableID SMALLINT IDENTITY(1,1),
	TableName VARCHAR(100)
)


INSERT INTO @Clean
SELECT name
FROM sys.tables
WHERE SCHEMA_NAME(schema_id) = 'dbo'


DECLARE @begin SMALLINT = 1
DECLARE @max SMALLINT
SELECT @max = MAX(TableID) FROM @Clean
DECLARE @sql NVARCHAR(MAX)
DECLARE @table NVARCHAR(MAX)


WHILE @begin <= @max
BEGIN

	SELECT @table = TableName FROM @Clean WHERE TableID = @begin

	SET @sql = 'TRUNCATE TABLE ' + @table

	EXECUTE sp_executesql @sql

	PRINT 'TABLE ' + @table + ' has been truncated.'

	SET @begin = @begin + 1

END


SELECT COUNT(*)
FROM TableOne

SELECT COUNT(*)
FROM TableTwo

SELECT COUNT(*)
FROM TableThree

/*

-- Clean up:

DROP TABLE TableOne
DROP TABLE TableTwo
DROP TABLE TableThree

*/
