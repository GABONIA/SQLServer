/*

Step 1: Counts total number of tables in a database on a server

*/

CREATE TABLE #DBCount(
	TableCount SMALLINT
)


DECLARE @DatabaseTable TABLE(
	DatabaseID SMALLINT IDENTITY(1,1),
	DatabaseName VARCHAR(200)
)


INSERT INTO @DatabaseTable (DatabaseName)
SELECT DB_NAME(database_id)
FROM sys.master_files
WHERE DB_NAME(database_id) NOT IN ('master','tempdb','model','msdb')
	AND data_space_id = 1


DECLARE @conn VARCHAR(200)
DECLARE @start TINYINT = 1
DECLARE @total TINYINT
SELECT @total = MAX(DatabaseID) FROM @DatabaseTable



WHILE @start <= @total
BEGIN

	SELECT @conn = DatabaseName FROM @DatabaseTable WHERE DatabaseID = @start

	DECLARE @sql NVARCHAR(MAX)
	SET @sql = 'INSERT INTO #DBCount (TableCount)
	SELECT COUNT(Name)
	FROM ' + @conn + '.sys.tables
	WHERE Name NOT LIKE ''%sys'''

	EXECUTE(@sql)

	SET @start = @start + 1

END

SELECT SUM(TableCount)
FROM #DBCount
