---- CPU
SELECT TOP 10
	last_execution_time AS LastExecutionTime
	--, (total_worker_time) AS TotalTime
	--, execution_count AS ExecutionCount
	, (total_worker_time * execution_count) AS Total
	, SUBSTRING([text],0,100) AS QueryText
-- MS: "Returns aggregate performance statistics for cached query plans in SQL Server"
FROM sys.dm_exec_query_stats
	CROSS APPLY sys.dm_exec_sql_text(sql_handle)
ORDER BY (total_worker_time * execution_count) DESC
