/*

Finds the maximum value of tinyint, smallint, int, bigint columns in a column of a table within a database.

*/

CREATE TABLE #MaxValueTable(
  MaxValue BIGINT
)

DECLARE @ztable TABLE(
	TableColumnID SMALLINT IDENTITY(1,1),
	TableName VARCHAR(100),
	ColumnName VARCHAR(100)
)

INSERT INTO @ztable
SELECT TABLE_NAME
	, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE LIKE '%int%'
	AND TABLE_NAME NOT LIKE 'sys%'

DECLARE @column VARCHAR(100)
DECLARE @table VARCHAR(100)
DECLARE @begin TINYINT = 1
DECLARE @max SMALLINT
SELECT @max = MAX(TableColumnID) FROM @ztable

WHILE @begin <= @max
BEGIN

	SELECT @table = TableName FROM @ztable WHERE TableColumnID = @begin
	SELECT @column = ColumnName FROM @ztable WHERE TableColumnID = @begin
	
	DECLARE @sql NVARCHAR(MAX)
	SET @sql = 'INSERT INTO #MaxValueTable
	SELECT MAX(' + @column + ')
	FROM ' + @table
	
	EXECUTE(@sql)
	
	SET @begin = @begin + 1

END

SELECT *
FROM #MaxValueTable
