
;WITH CheckIt AS(
	-- Total and individual
	SELECT
		DB_NAME(db.database_id) DatabaseName
		, OBJECT_NAME(p.object_id) ObjectName
		, db.page_type PageType
		, a.total_pages TotalPages
		, p.rows [Rows]
		, p.data_compression DataCompression
	FROM sys.dm_os_buffer_descriptors db
		INNER JOIN sys.allocation_units a ON db.allocation_unit_id = a.allocation_unit_id
		INNER JOIN sys.partitions p ON a.container_id = p.hobt_id
		INNER JOIN sys.objects o ON p.object_id = o.object_id
	WHERE o.is_ms_shipped = 0
)
SELECT ObjectName
	, COUNT(ObjectName)
FROM CheckIt
WHERE DatabaseName = ''
GROUP BY ObjectName
