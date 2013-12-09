/* 

  Truncate n% of a table

*/

-- Example:

CREATE TABLE CleanIt(
	ID INT,
	Name VARCHAR(25)
)

INSERT INTO CleanIt
SELECT (RAND() * 1000)
	, 'durkdurkahstan'
GO 10000

SELECT *
FROM CleanIt


-- Cleaning Process:

DECLARE @cleaning INT, @sql NVARCHAR(MAX)

;WITH CTE AS(
	SELECT COUNT(*) TotalRows
	FROM CleanIt
)
-- The .1 value can be changed to any percent desired
SELECT @cleaning = (TotalRows * .1) FROM CTE

SET @sql = 'SELECT TOP ' + CAST(@cleaning AS VARCHAR(22)) + ' *
INTO ##Holding
FROM CleanIt

TRUNCATE TABLE CleanIt

INSERT INTO CleanIt
SELECT *
FROM ##Holding

DROP TABLE ##Holding'

EXECUTE sp_executesql @sql

SELECT *
FROM CleanIt
