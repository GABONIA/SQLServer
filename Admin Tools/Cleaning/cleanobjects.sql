/*

CREATE TABLE ##CodeTest (
	CodeID INT IDENTITY(1,1),
	NameProcess VARCHAR(250),
	Test TINYINT DEFAULT 0
)

INSERT INTO ##CodeTest (NameProcess)
SELECT 'sys.sp_refreshsqlmodule ''' + name + ''''
FROM sys.objects
WHERE type_desc = 'SQL_STORED_PROCEDURE'
	OR type_desc = 'VIEW'
	OR type_desc = 'SQL_SCALAR_FUNCTION'

DROP TABLE ##CodeTest

*/


DECLARE @begin INT, @max INT, @name VARCHAR(250), @sql NVARCHAR(MAX)
SELECT @begin = MIN(CodeID) FROM ##CodeTest WHERE Test = 0
SELECT @max = MAX(CodeID) FROM ##CodeTest WHERE Test = 0

WHILE @begin <= @max
BEGIN
	
	SELECT @sql = NameProcess FROM ##CodeTest WHERE CodeID = @begin AND Test = 0
	PRINT 'Testing ' + @sql
	EXECUTE(@sql)

	UPDATE ##CodeTest
	SET Test = 1
	WHERE NameProcess = @sql
	
	SET @begin = @begin + 1

END


/*

UPDATE ##CodeTest
SET Test = 2
WHERE NameProcess = 'sys.sp_refreshsqlmodule ''objectname'''


SELECT *
FROM ##CodeTest
WHERE Test = 2


;WITH Gimmie AS(
	SELECT RTRIM(LTRIM(REPLACE(REPLACE(NameProcess,'sys.sp_refreshsqlmodule',''),'''',''))) [ObjectName]
	FROM ##CodeTest
	WHERE Test = 2
)
SELECT o.name
	, SCHEMA_NAME(schema_id)
	, o.type_desc
FROM sys.objects o
	INNER JOIN Gimmie g ON o.name = g.ObjectName

*/
