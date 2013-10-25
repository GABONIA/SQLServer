/* 

Look Through the Transaction Log

*/

SELECT SUSER_SNAME([Transaction SID]) As Changer
	, [Transaction Name]
FROM fn_dblog(NULL, NULL)
WHERE [Transaction Name] IN ('CREATE TABLE');


SELECT *
FROM fn_dblog(NULL, NULL)
