WITH OrderTheData AS(
	SELECT t.NAME AS TableName,
		p.rows AS TotalRows,
		(SUM(a.total_pages) * 8)/(1024*1024) AS TotalSpaceGIG,
		(SUM(a.used_pages) * 8)/(1024*1024) AS UsedSpaceGIG
	FROM sys.tables t
		INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
		INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
		INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
		INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
	WHERE t.is_ms_shipped = 0
	GROUP BY t.Name, s.Name, p.Rows
)
SELECT *
FROM OrderTheData
ORDER BY TotalSpaceGIG DESC, UsedSpaceGIG DESC
