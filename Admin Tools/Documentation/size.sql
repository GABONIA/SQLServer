
USE master
GO

SELECT DB_NAME(database_id)
	, CASE WHEN physical_name LIKE '%.ldf' THEN name + ' (LOG)' ELSE name END AS LogicalName
	, physical_name Location
	, ((size*8)/(1024*1024)) GB
FROM sys.master_files WITH(NOLOCK)
ORDER BY size DESC

---- Use PS; if unavailable, CTE above
