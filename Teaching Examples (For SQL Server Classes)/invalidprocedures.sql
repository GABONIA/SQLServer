USE SETRANS
GO


/*

CREATE TABLE ##procname(
	ProcName VARCHAR(250)
)

TRUNCATE TABLE ##procname

*/

DECLARE @testprocs TABLE (
	ProcID INT IDENTITY(1,1),
	ProcName VARCHAR(250)
)


INSERT INTO @testprocs (ProcName)
SELECT name ProcName
FROM sys.objects
WHERE type_desc = 'SQL_STORED_PROCEDURE'
	AND name NOT IN (SELECT ProcName FROM ##procname)
	-- Errored procedures:
	AND name NOT IN ('')


DECLARE @begin INT = 1, @max INT, @name VARCHAR(250), @sql NVARCHAR(MAX)
SELECT @max = COUNT(ProcID) FROM @testprocs


WHILE @begin <= @max
BEGIN
	
	SELECT @name = ProcName FROM @testprocs WHERE ProcID = @begin
	PRINT 'Testing procedure ' + @name + ' for errors ...'
	SET @sql = 'EXEC sys.sp_refreshsqlmodule ''' + @name + ''''
	

	EXECUTE(@sql)

	INSERT INTO ##procname
	SELECT @name
	
	SET @begin = @begin + 1

END


/*

SELECT *
FROM ##procname

DROP TABLE ##procname

*/
