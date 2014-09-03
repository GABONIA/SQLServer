--  Find non-compressed indexes 

SELECT DISTINCT name
FROM sys.indexes
WHERE object_id > 100
	AND NOT EXISTS (
		SELECT
			i.*
		FROM sys.partitions  p 
			INNER JOIN sys.objects o ON p.object_id = o.object_id 
			INNER JOIN sys.indexes i ON p.object_id = i.object_id
				AND i.index_id = p.index_id
		WHERE p.data_compression > 0 
			AND o.is_ms_shipped = 0
)
