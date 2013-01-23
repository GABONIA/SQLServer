/* 

Finds the last time a stored procedure was run, assuming the cache has not been cleared.

*/

SELECT SO.name, SD.last_execution_time
FROM sys.dm_exec_procedure_stats SD
    INNER JOIN sys.objects SO ON SO.object_id = SD.object_id
WHERE SO.name = 'usp_InsertOurProcName'


/* 

Find an object's id

*/

SELECT OBJECT_ID('OurDatabase..OurTable')
SELECT OBJECT_ID('OurDatabase..OurStoredProcedure')

