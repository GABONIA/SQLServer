;WITH RecUp AS(
	SELECT o.name ObjectName
		, o.object_id ObjectID
		, st.name StName
		, st.stats_id StID
		, last_updated LastUpdated
		, modification_counter ModificationCounter
	FROM sys.objects AS o
		INNER JOIN sys.stats st ON st.object_id = o.object_id
		CROSS APPLY sys.dm_db_stats_properties(st.object_id, st.stats_id) AS s
	WHERE o.is_ms_shipped = 0
)
SELECT DISTINCT ObjectName
	, MAX(LastUpdated) AS MostRecentUpdate
FROM RecUp
GROUP BY ObjectName
