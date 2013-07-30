CREATE TABLE DatabaseGrowthMonitoring(
	DatabaseID SMALLINT,
	DatabaseName VARCHAR(100),
	SizeInGigs DECIMAL(22,12)
	Date DATE
)

INSERT INTO DatabaseGrowthMonitoring
SELECT DISTINCT database_id [DatabaseID]
	, DB_NAME(database_id) AS [DatabaseName]
	, (((CAST(SUM(size) AS DECIMAL(25,2))*8)/1024)/1024) [SizeInGigs]
	, GETDATE()
FROM sys.master_files
WHERE database_id NOT IN (1,2,3,4)
GROUP BY database_id
