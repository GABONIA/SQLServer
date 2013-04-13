SELECT SchemaName=s.name, TableName=o.name
FROM TableCheckTool.sys.objects o 
  INNER JOIN TableCheckTool.sys.schemas s ON s.schema_id=o.schema_id
    INNER JOIN TableCheckTool.sys.indexes i ON i.OBJECT_ID=o.OBJECT_ID
WHERE (o.type='U' 
	AND o.OBJECT_ID NOT IN (SELECT OBJECT_ID FROM TableCheckTool.sys.indexes WHERE index_id >0))
	


DECLARE @TableCount TABLE(
	DatabaseID SMALLINT IDENTITY(1,1),
	DatabaseName VARCHAR(200)
)

INSERT INTO @TableCount (DatabaseName)
SELECT DB_NAME(database_id)
FROM sys.master_files
WHERE DB_NAME(database_id) NOT IN ('master','tempdb','model','msdb')

DECLARE @begin SMALLINT = 1
DECLARE @max SMALLINT
SELECT @max = MAX(DatabaseID) FROM @TableCount

WHILE @begin <= @max
BEGIN
	
	
	
	SET @begin = @begin + 1
	
END
