-- Active transaction
SELECT *
FROM fn_dblog (NULL, NULL)
WHERE Operation = 'LOP_XACT_CKPT'

/*
-- From Gist:

DBCC LOGINFO(<DatabaseID>)

DBCC SQLPERF('LogSpace') 

DBCC LOG('<DatabaseName>') 

*/
