/* 

Look Through the Transaction Log

*/


SELECT SUSER_SNAME([Transaction SID]) As Changer
	, [Transaction Name]
	, [Begin Time]
FROM fn_dblog(NULL, NULL)
WHERE [Transaction Name] IN ('CREATE TABLE','DROP TABLE');


SELECT *
FROM fn_dblog(NULL, NULL)
