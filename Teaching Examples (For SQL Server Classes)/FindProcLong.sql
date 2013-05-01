CREATE TABLE ##FindProcOnServer(
  ProcName VARCHAR(500),
	ProcID INT,
	DBName VARCHAR(200)
)


DECLARE @database TABLE(
	DatabaseID SMALLINT IDENTITY(1,1),
	DatabaseName VARCHAR(200)
)

INSERT INTO @database (DatabaseName)
SELECT name
FROM sys.databases
WHERE name NOT IN ('master','tempdb','model','msdb')


DECLARE @begin SMALLINT
SET @begin = 1
DECLARE @max SMALLINT
SELECT @max = MAX(DatabaseID) FROM @database
DECLARE @dbName VARCHAR(200)
DECLARE @sql NVARCHAR(MAX)
DECLARE @name VARCHAR(200) 
SET @name = 'cbe_GetEventsByAcct'

WHILE @begin <= @max
BEGIN
	
	SELECT @dbName = DatabaseName FROM @database WHERE DatabaseID = @begin
	
	SET @sql = 'INSERT INTO ##FindProcOnServer
	SELECT name, object_id, ''' + @dbName + '''
	FROM ' + @dbName + '.sys.procedures 
	WHERE name = ''' + @name + '''
	'

	EXECUTE(@sql)

	SET @begin = @begin + 1
	
END

SELECT *
FROM ##FindProcOnServer
