/*

/* Note that this process will truncate all tables without any FK constraints, then delete from the initial tables that do (that are references and parents) and then remove the remaining.
Consider that if we have something even more complicated than the below example, this script would need another delete addition. */

-- Example:

CREATE TABLE TheOneRingToRuleThemAll(
	OneRing VARCHAR(9) PRIMARY KEY
)	

CREATE TABLE AssociativeTable(
	UniqueID INT IDENTITY(1,1) PRIMARY KEY,
	OtherTableID INT,
	YetAnotherTableID VARCHAR(1),
	OneRing VARCHAR(9) NOT NULL,
	FOREIGN KEY (OneRing) REFERENCES TheOneRingToRuleThemAll (OneRing),
	CONSTRAINT FFK_OtherTableID UNIQUE(OtherTableID),
	CONSTRAINT FFK_YetAnotherTableID UNIQUE(YetAnotherTableID)
)


CREATE TABLE OtherTable(
	OtherTableID INT PRIMARY KEY,
	Name VARCHAR(50),
	FOREIGN KEY (OtherTableID) REFERENCES AssociativeTable (OtherTableID)
)

CREATE TABLE YetAnotherTable(
	YetAnotherTableID VARCHAR(1) PRIMARY KEY,
	Name VARCHAR(50), 
	FOREIGN KEY (YetAnotherTableID) REFERENCES AssociativeTable (YetAnotherTableID)
)

INSERT INTO TheOneRingToRuleThemAll
VALUES ('Sauron')

INSERT INTO AssociativeTable (OneRing, OtherTableID, YetAnotherTableID)
VALUES ('Sauron',1,'A')
	, ('Sauron',2,'B')
	, ('Sauron',3,'C')

INSERT INTO OtherTable
VALUES (1,'Sarah')
	, (2,'George')
	, (3,'Bob')

INSERT INTO YetAnotherTable
VALUES ('A','Smith')

/* 

DROP TABLE OtherTable
DROP TABLE YetAnotherTable
DROP TABLE AssociativeTable
DROP TABLE TheOneRingToRuleThemAll

*/

*/

-- The script and note the rounds:

SET NOCOUNT ON

CREATE TABLE ##BeginRecording(
	TableName VARCHAR(250)
)

CREATE TABLE #loop (
	TableID INT IDENTITY(1,1),
	TableName VARCHAR(250)
)

-- No FK constraints
;WITH CTE AS(
	SELECT OBJECT_NAME(k.referenced_object_id) Referenced
        , OBJECT_NAME(k.parent_object_id) Parent
	FROM sys.objects o
        INNER JOIN sys.foreign_key_columns k ON o.object_id = k.parent_object_id
)
INSERT INTO #loop (TableName)
SELECT o.name
FROM sys.objects o
        INNER JOIN sys.tables t ON o.object_id = t.object_id
WHERE o.name NOT IN (SELECT Referenced FROM CTE)
        AND o.is_ms_shipped = 0
        AND t.is_ms_shipped = 0
		AND SCHEMA_NAME(o.schema_id) = 'dbo'

INSERT INTO ##BeginRecording
SELECT TableName
FROM #loop

DECLARE @begin INT = 1, @max INT, @t VARCHAR(250), @sql NVARCHAR(MAX)
SELECT @max = MAX(TableID) FROM #loop

WHILE @begin <= @max
BEGIN

	SELECT @t = TableName FROM #loop WHERE TableID = @begin

	SET @sql = 'TRUNCATE TABLE ' + @t + '
		PRINT ''Truncated table ' + @t + '.'''

	EXECUTE sp_executesql @sql

	SET @begin = @begin + 1
	SET @sql = ''

END


TRUNCATE TABLE #loop
PRINT 'Truncated parent tables that are not references or tables without any FK constraints.'


-- Parent that is also a reference  - we move to DELETEs
;WITH CTE AS(
	SELECT OBJECT_NAME(k.referenced_object_id) Referenced
        , OBJECT_NAME(k.parent_object_id) Parent
	FROM sys.objects o
        INNER JOIN sys.foreign_key_columns k ON o.object_id = k.parent_object_id
	WHERE SCHEMA_NAME(o.schema_id) = 'dbo'
)
INSERT INTO #loop (TableName)
SELECT DISTINCT Parent
FROM CTE
WHERE Parent IN (SELECT Referenced FROM CTE)

INSERT INTO ##BeginRecording
SELECT TableName
FROM #loop

DECLARE @beginTwo INT = 1, @maxTwo INT, @tTwo VARCHAR(250), @sqlTwo NVARCHAR(MAX)
SELECT @maxTwo = MAX(TableID) FROM #loop

WHILE @beginTwo <= @maxTwo
BEGIN

	SELECT @tTwo = TableName FROM #loop WHERE TableID = @beginTwo

	SET @sqlTwo = 'DELETE FROM ' + @tTwo + '
		PRINT ''Deleted from table ' + @tTwo + '.'''

	EXECUTE sp_executesql @sqlTwo

	SET @beginTwo = @beginTwo + 1
	SET @sqlTwo = ''

END


TRUNCATE TABLE #loop
PRINT 'Deleted from tables that are references and parents.'


-- Remaining tables
INSERT INTO #loop
SELECT name
FROM sys.tables
WHERE is_ms_shipped = 0
	AND SCHEMA_NAME(schema_id) = 'dbo'
	AND name NOT IN (SELECT TableName FROM ##BeginRecording)


DECLARE @fbeg INT = 1, @fmax INT, @ft VARCHAR(250), @fsql NVARCHAR(MAX)
SELECT @fmax = MAX(TableID) FROM #loop

WHILE @fbeg <= @fmax
BEGIN

	SELECT @ft = TableName FROM #loop WHERE TableID = @fbeg

	SET @fsql = 'DELETE FROM ' + @ft + '
		PRINT ''Deleted from table ' + @ft + '.'''

	EXECUTE sp_executesql @fsql

	SET @fbeg = @fbeg + 1
	SET @fsql = ''

END

PRINT 'Deleted from the remaining tables.  Note that if parent/references tables go another level, this script will not work.'


BEGIN TRY
	-- Adjust RESEED value if necessary
	EXECUTE sp_MSforeachtable 'DBCC CHECKIDENT(''?'', RESEED, 0)'
	PRINT 'Reseeded all identity tables'
END TRY
BEGIN CATCH
	PRINT 'Note: Any table without an identity was not reseeded.'
END CATCH


DROP TABLE #loop
DROP TABLE ##BeginRecording
PRINT 'Tables cleaned and identities reseeded to 1 (if reseed should be different number, change in the above code).'
