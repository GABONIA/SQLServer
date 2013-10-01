DECLARE @s VARBINARY(128)
SELECT @s = sql_handle
FROM sys.sysprocesses
-- edit this value:
WHERE spid = 54

SELECT text
FROM sys.dm_exec_sql_text(@s)
