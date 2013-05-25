USE DatabaseName
GO

CREATE PROCEDURE AS stp_AdministrativeJobs
AS
BEGIN

/* Rebuild All Non-System Indexes */

DECLARE @RebuildIndex TABLE(
  IndexingID INT IDENTITY(1,1),
  IndexName VARCHAR(250),
  TableSchema VARCHAR(50),
  TableName VARCHAR(250)
)

INSERT INTO @RebuildIndex (IndexName,TableSchema,TableName)
SELECT i.name AS IndexName
	, SCHEMA_NAME(schema_id) AS TableSchema
	, o.name AS TableName
FROM sys.indexes i
	INNER JOIN sys.objects o ON i.object_id = o.object_id
	INNER JOIN sys.index_columns c ON c.object_id = o.object_id AND i.index_id = c.index_id
	INNER JOIN sys.columns sc ON sc.object_id = o.object_id AND sc.column_id = c.column_id
WHERE o.is_ms_shipped = 0

DECLARE @begin INT = 1
DECLARE @max INT
SELECT @max = MAX(IndexingID) FROM @RebuildIndex
DECLARE @IndexName VARCHAR(250), @TableSchema VARCHAR(50), @TableName VARCHAR(250)

WHILE @begin <= @max
BEGIN

	SELECT @IndexName = IndexName FROM @RebuildIndex WHERE IndexingID = @begin
	SELECT @TableSchema = TableSchema FROM @RebuildIndex WHERE IndexingID = @begin
	SELECT @TableName = TableName FROM @RebuildIndex WHERE IndexingID = @begin

	DECLARE @sql NVARCHAR(MAX)
	SET @sql = 'ALTER INDEX [' + @IndexName + '] ON [' + @TableSchema + '].[' + @TableName + '] REBUILD PARTITION = ALL WITH ( PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF )'

	EXECUTE(@sql)

	SET @begin = @begin + 1

END

/* Back up database */

DECLARE @name VARCHAR(25)  
DECLARE @path VARCHAR(256) 
DECLARE @fileName VARCHAR(256)  
DECLARE @fileDate VARCHAR(20)

SET @name = 'DatabaseName'
SET @path = 'D:\FilePath\'
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 
SET @fileName = @path + @name + '_' + @fileDate + '.BAK'
BACKUP DATABASE @name TO DISK = @fileName

/* Database Integrity Check, will return results from the temporary table */

IF OBJECT_ID('##Consistency') IS NOT NULL
BEGIN
	DROP TABLE ##Consistency
END

CREATE TABLE ##Consistency(
	Error VARCHAR(10),
	Level VARCHAR(10),
	State VARCHAR(10),
	MessageText VARCHAR(2000),
	RepairLevel VARCHAR(250),
	Status VARCHAR(10),
	DbId VARCHAR(10),
	ObjectID VARCHAR(25),
	IndexID VARCHAR(10),
	PartitionID VARCHAR(10),
	AllocUnitId VARCHAR(10),
	[File] VARCHAR(10),
	Page VARCHAR(10),
	Slot VARCHAR(10),
	RefFile VARCHAR(10),
	RefPage VARCHAR(10),
	RefSlot VARCHAR(10),
	Allocation VARCHAR(10)
)

INSERT INTO ##Consistency
EXEC('DBCC CHECKDB(DatabaseName) WITH TABLERESULTS')

SELECT *
FROM ##Consistency
WHERE MessageText LIKE 'CHECKDB found%'

DROP TABLE ##Consistency

END