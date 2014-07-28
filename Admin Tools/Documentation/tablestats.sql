SELECT t.name
	, MAX(STATS_DATE(t.object_id,s.stats_id))
FROM sys.tables t
	INNER JOIN sys.stats s ON t.object_id = s.object_id
WHERE t.is_ms_shipped = 0
GROUP BY t.name
