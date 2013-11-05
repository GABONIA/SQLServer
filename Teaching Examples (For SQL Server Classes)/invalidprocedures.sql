
/*

CREATE TABLE ##testprocs (
	ProcID INT IDENTITY(1,1),
	ProcName VARCHAR(250)
)

CREATE TABLE ##procname(
	ProcName VARCHAR(250)
)

TRUNCATE TABLE ##testprocs
TRUNCATE TABLE ##procname

*/


;WITH CTE AS(
	SELECT ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) ID
		, OBJECT_NAME(id) ProcName
	FROM sys.syscomments
)
INSERT INTO ##testprocs
SELECT c.ProcName
FROM CTE c
	INNER JOIN sys.objects o ON c.ProcName = o.name
WHERE c.ID = 1
	AND o.type_desc = 'SQL_STORED_PROCEDURE'


DECLARE @begin INT = 1, @max INT, @name VARCHAR(250), @sql NVARCHAR(MAX)
SELECT @max = MAX(ProcID) FROM ##testprocs

WHILE @begin <= @max
BEGIN
	
	SELECT @name = ProcName FROM ##testprocs WHERE ProcID = @begin
	PRINT 'Testing procedure ' + @name + ' for errors ...'
	SET @sql = 'EXEC sys.sp_refreshsqlmodule ''' + @name + ''''
	

	EXECUTE(@sql)

	INSERT INTO ##procname
	SELECT @name

	DELETE FROM ##testprocs
	WHERE ProcName = @name
	
	SET @begin = @begin + 1

END


/*

DELETE FROM ##testprocs
WHERE ProcName = 'updateopenpositions'

SELECT *
FROM ##testprocs

SELECT *
FROM ##procname

DROP TABLE ##testprocs
DROP TABLE ##procname

*/
