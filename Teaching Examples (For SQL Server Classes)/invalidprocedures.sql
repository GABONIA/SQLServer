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



INSERT INTO ##testprocs (ProcName)
SELECT name ProcName
FROM sys.objects
WHERE type_desc = 'SQL_STORED_PROCEDURE'


DECLARE @begin INT = 1, @max INT, @name VARCHAR(250), @sql NVARCHAR(MAX)
SELECT @max = COUNT(ProcID) FROM ##testprocs

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
