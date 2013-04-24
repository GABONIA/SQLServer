/* 

On tables that have the same schema, no clustered index, have an ID field for their primary key, this will create a clustered index on all of them.

*/

DECLARE @loop TABLE(
  ID SMALLINT IDENTITY(1,1),
	TableName VARCHAR(200)
)

INSERT INTO @loop (TableName)
SELECT '[' + SCHEMA_NAME(so.SCHEMA_ID) + '].[' + so.name + ']'
FROM sys.objects so
WHERE SCHEMA_NAME(so.SCHEMA_ID) = 'ref'


DECLARE @begin SMALLINT = 1
DECLARE @max SMALLINT
SELECT @max = MAX(ID) FROM @loop
DECLARE @table VARCHAR(200)

WHILE @begin <= @max
BEGIN

	SELECT @table = TableName FROM @loop WHERE ID = @begin

	DECLARE @sql NVARCHAR(MAX)
	SET @sql = 'CREATE CLUSTERED INDEX [IX_ID] ON ' + @table + '
	( [ID] ASC)'
	
	EXECUTE(@sql)
	
	SET @begin = @begin + 1
END
