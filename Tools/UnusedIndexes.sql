---- Get unused indexes
SELECT DISTINCT
    OBJECT_NAME(s.[object_id]) AS ObjectName
       , p.rows AS RowCount
       , i.name AS IndexName
       , (user_seeks + user_scans + user_lookups) AS TotalReads
       , user_updates UserUpdates
FROM sys.dm_db_index_usage_stats s
    INNER JOIN sys.indexes i ON i.[object_id] = s.[object_id] 
        AND i.index_id = s.index_id 
    INNER JOIN sys.partitions p ON p.object_id = i.object_id
WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
       AND s.database_id = DB_ID()
       AND i.name IS NOT NULL
ORDER BY (user_seeks + user_scans + user_lookups) DESC
