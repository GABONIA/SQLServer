/*

Obtain connection strings for a server, including database, schema and table name

*/


CREATE TABLE ConnectionStrings(
	ServerName VARCHAR(200),
	DatabaseName VARCHAR(200),
	SchemaName VARCHAR(50),
	TableName VARCHAR(200),
	ConnectionString VARCHAR(650)
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
	SET @sqlone = 'DECLARE @DB VARCHAR(200)
	SET @DB = ''' + @conn + '''
	
	INSERT INTO ConnectionStrings (ServerName,DatabaseName,SchemaName,TableName)
	SELECT @@SERVERNAME, @DB, SCHEMA_NAME(t.schema_id), t.name
	FROM ' + @conn + '.sys.tables t'

	EXEC sp_executesql @sqlone

	SET @start = @start + 1

END


UPDATE ConnectionStrings
SET ConnectionString = '[' + ServerName + '].[' + DatabaseName + '].[' + SchemaName + '].[' + TableName + ']'
WHERE SchemaName IS NOT NULL

UPDATE ConnectionStrings
SET ConnectionString = '[' + ServerName + '].[' + DatabaseName + '].[' + TableName + ']'
WHERE SchemaName IS NULL


SELECT *
FROM ConnectionStrings

/*


DROP TABLE ConnectionStrings


*/
