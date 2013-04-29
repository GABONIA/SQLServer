/*

Useful script for table backups to make sure the backup table is indexed the exact same way as the original table: requires three edits

*/

DECLARE @Indexing TABLE(
  IndexingID INT IDENTITY(1,1),
  IndexType VARCHAR(50),
  IndexName VARCHAR(250),
  TableName VARCHAR(250),
  ColumnName VARCHAR(200)
)

INSERT INTO @Indexing
SELECT i.type_desc AS IndexType
	, i.name AS IndexName
	, o.name AS TableName
	, sc.name ColumnName
FROM sys.indexes i
	INNER JOIN sys.objects o ON i.object_id = o.object_id
	INNER JOIN sys.index_columns c ON c.object_id = o.object_id
	INNER JOIN sys.columns sc ON sc.object_id = o.object_id AND sc.column_id = c.column_id
WHERE SCHEMA_NAME(SCHEMA_ID) = 'dbo'  -- Edit this schema name if different
	AND o.name = 'Reference'  -- Edit this original table name
	
DECLARE @begin INT = 1
DECLARE @max INT
SELECT @max = MAX(IndexingID) FROM @Indexing
DECLARE @IndexType VARCHAR(50), @IndexName VARCHAR(250), @TableName VARCHAR(250), @ColumnName VARCHAR(250)
SET @TableName = '' -- Edit this to be the value of the backup table

WHILE @begin <= @max
BEGIN	
	
	SELECT @IndexType = IndexType FROM @Indexing WHERE IndexingID = @begin
	SELECT @IndexName = IndexName FROM @Indexing WHERE IndexingID = @begin
	SELECT @ColumnName = ColumnName FROM @Indexing WHERE IndexingID = @begin
	
	
	DECLARE @sql NVARCHAR(MAX)
	SET @sql = 'CREATE ' + @IndexType + ' INDEX ' + @IndexName + ' ON ' + @TableName + '(' + @ColumnName + ')'
	
	EXECUTE(@sql)
	
	SET @begin = @begin + 1
	
END
