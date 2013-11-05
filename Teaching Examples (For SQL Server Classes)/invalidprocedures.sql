/*

CREATE TABLE ##oname(
	ProcName VARCHAR(250)
)

TRUNCATE TABLE ##oname

*/

DECLARE @codetest TABLE (
	ProcID INT IDENTITY(1,1),
	ProcName VARCHAR(250)
)

INSERT INTO @codetest (ProcName)
SELECT name Name
FROM sys.objects
WHERE type_desc = 'SQL_STORED_PROCEDURE'
	AND name NOT IN (SELECT ProcName FROM ##oname)
	-- Errored procedures:
	AND name NOT IN ('co_EditCommissionJournal'
	,'CALLDB_UpdateUrgentMessages'
	,'SLS_GetClearingIDfromNoShorts',
	'updateopenpositions')
	OR type_desc = 'VIEW'
	AND name NOT IN (SELECT ProcName FROM ##oname)
	OR type_desc = 'SQL_SCALAR_FUNCTION'
	AND name NOT IN (SELECT ProcName FROM ##oname)



DECLARE @begin INT = 1, @max INT, @name VARCHAR(250), @sql NVARCHAR(MAX)
SELECT @max = COUNT(ProcID) FROM @codetest


WHILE @begin <= @max
BEGIN
	
	SELECT @name = ProcName FROM @codetest WHERE ProcID = @begin
	PRINT 'Testing procedure/view/function ' + @name + ' for errors ...'
	SET @sql = 'EXEC sys.sp_refreshsqlmodule ''' + @name + ''''
	

	EXECUTE(@sql)

	INSERT INTO ##oname
	SELECT @name
	
	SET @begin = @begin + 1

END


/*

SELECT *
FROM ##oname

DROP TABLE ##oname

*/
