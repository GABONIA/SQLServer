SELECT *
FROM sys.fn_dblog(NULL,NULL)
WHERE AllocUnitName LIKE '%%'
-- Solid read: http://rusanu.com/2014/03/10/how-to-read-and-interpret-the-sql-server-log/
