/*

Step 1: Counts total number of tables and heaps in a database on a server

*/

CREATE TABLE #TTables(
	TableCount SMALLINT
)

CREATE TABLE #THeaps(
	HeapCount SMALLINT
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

	DECLARE @sqlone NVARCHAR(MAX)
	SET @sqlone = 'INSERT INTO #TTables (TableCount)
	SELECT COUNT(Name)
	FROM ' + @conn + '.sys.tables
	WHERE Name NOT LIKE ''%sys''
	
	INSERT INTO #THeaps (HeapCount)
	SELECT COUNT(t.name) Heap
	FROM ' + @conn + '.sys.tables t
		INNER JOIN ' + @conn + '.sys.indexes i ON t.object_id = i.object_id
	WHERE t.name NOT LIKE ''sys%''
		AND i.type_desc = ''HEAP'''

	EXECUTE(@sqlone)

	SET @start = @start + 1

END
