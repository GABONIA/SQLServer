/*

-- Manual notation: we will evaluate these manually

*/

SET NOCOUNT ON

DECLARE @loop TABLE(
	ID INT IDENTITY(1,1),
	ExecuteIt NVARCHAR(MAX)
)

INSERT INTO @loop
-- Procedures
SELECT 'sys.sp_refreshsqlmodule ''' 
	+ QUOTENAME(SCHEMA_NAME(schema_id)) 
	+ '.' + QUOTENAME(name) + ''' -- Proc'
FROM sys.objects
WHERE is_ms_shipped = 0
	AND type_desc = 'SQL_STORED_PROCEDURE'

INSERT INTO @loop
-- Views
SELECT 'sys.sp_refreshsqlmodule ''' + name + ''' -- View'
FROM sys.objects
WHERE is_ms_shipped = 0
	AND type_desc = 'VIEW'

INSERT INTO @loop
-- Functions
SELECT 'sys.sp_refreshsqlmodule ''' + name + ''' -- Function'
FROM sys.objects
WHERE is_ms_shipped = 0
	AND type_desc = 'SQL_SCALAR_FUNCTION'

DECLARE @begin INT = 1, @max INT, @sql NVARCHAR(MAX)
SELECT @max = MAX(ID) FROM @loop

WHILE @begin <= @max
BEGIN

	SELECT @sql = ExecuteIt FROM @loop WHERE ID = @begin
	
	PRINT 'Testing ' + @sql

	BEGIN TRY
		EXECUTE sp_executesql @sql
	END TRY
	BEGIN CATCH
		PRINT '
			' + REPLACE(REPLACE(REPLACE(SUBSTRING(@sql,(CHARINDEX('[',@sql,3)+1),LEN(@sql)),'''',''),']',''),'[','') + ' failed.
			'
	END CATCH

	SET @begin = @begin + 1

END

SET NOCOUNT OFF
