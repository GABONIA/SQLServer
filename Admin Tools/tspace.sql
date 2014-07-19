-- Total and used space, as well as how many columns
WITH OrderTheData AS(
	SELECT t.name AS TableName,
		p.rows AS TotalRows,
		(SUM(a.total_pages) * 8)/(1024*1024) AS TotalSpaceGIG,
		(SUM(a.used_pages) * 8)/(1024*1024) AS UsedSpaceGIG
	FROM sys.tables t
		INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
		INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
		INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
		INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
	WHERE t.is_ms_shipped = 0
	GROUP BY t.name, p.Rows
), ColumnCount AS(
	SELECT DISTINCT TABLE_NAME TableName
		, COUNT(COLUMN_NAME) ColumnCounts
	FROM INFORMATION_SCHEMA.COLUMNS
	GROUP BY TABLE_NAME
)
SELECT o.*
	, c.ColumnCounts
FROM OrderTheData o
	INNER JOIN ColumnCount c ON o.TableName = c.TableName
ORDER BY TotalSpaceGIG DESC, UsedSpaceGIG DESC




--SELECT i.name IndexName
--	, t.name TableName
--FROM sys.tables t
--	INNER JOIN sys.indexes i ON t.object_id = i.object_id
--WHERE i.name IS NOT NULL
