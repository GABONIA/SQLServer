-- Error:
-- Could not allocate space for object 'dbo.SORT temporary run storage:  [n]' in database 'tempdb' because the 'PRIMARY' filegroup is full.

-- If space related:
DBCC CHECKDB WITH ESTIMATEONLY
