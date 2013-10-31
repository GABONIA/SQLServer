CREATE TABLE TabCols(
	TableName VARCHAR(250),
	TableColumns VARCHAR(1000)
)


INSERT INTO TabCols
SELECT i.TABLE_NAME
	, STUFF((SELECT ', ' + ii.COLUMN_NAME AS [text()]
	FROM INFORMATION_SCHEMA.COLUMNS ii
	WHERE i.TABLE_NAME = ii.TABLE_NAME
		AND COLUMN_DEFAULT IS NULL
		AND COLUMNPROPERTY(object_id(TABLE_NAME),COLUMN_NAME,'IsIdentity') = 0
	ORDER BY ii.COLUMN_NAME
	FOR XML PATH('')),1,1,'') AS TableColumns
FROM INFORMATION_SCHEMA.COLUMNS i
GROUP BY TABLE_NAME


DECLARE @table VARCHAR(250), @columns VARCHAR(250), @sql NVARCHAR(MAX)
SET @table = 'TenPoundsChicken'
SELECT @columns = TableColumns FROM TabCols WHERE TableName = @table
SELECT @table, @columns

SET @sql = 'INSERT INTO ' + @table + ' (' + @columns + ')
SELECT GETDATE(),11.89

SELECT *
FROM ' + @table + ' '

EXECUTE(@sql)
