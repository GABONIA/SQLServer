/*

For some reason, many scripts to obtain the database name and size have a significant amount of complexity.
Some offer loops, cursors and temp tables with several hundred lines of code, even though, to obtain this information, none
of this is necessary.  This simple script (a basic SELECT) provides the same information.  This has been tested on SQL Server 2005, 2008R2. 

*/

SELECT DISTINCT DB_NAME(database_id) DatabaseName
  , (CAST(SUM(Size) AS DECIMAL(20,2))*8)/(1024) SizeInMB
FROM sys.master_files
WHERE database_id > 4
GROUP BY database_id
