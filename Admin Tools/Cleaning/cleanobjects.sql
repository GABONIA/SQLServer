/*

-- Manual notation: we will evaluate these manually

*/

DECLARE @loop TABLE(
	ID INT IDENTITY(1,1),
	ExecuteIt NVARCHAR(MAX)
)

INSERT INTO @loop
-- Procedures
SELECT 'sys.sp_refreshsqlmodule ''' + name + ''' -- Procedure'
FROM sys.objects
WHERE is_ms_shipped = 0
	AND type_desc = 'SQL_STORED_PROCEDURE'
	-- Filer out issues (one-by-one):
	-- AND name <> ''

INSERT INTO @loop
-- Views
SELECT 'sys.sp_refreshsqlmodule ''' + name + ''' -- View'
FROM sys.objects
WHERE is_ms_shipped = 0
	AND type_desc = 'VIEW'
	-- Filer out issues (one-by-one):
	-- AND name <> ''

INSERT INTO @loop
-- Functions
SELECT 'sys.sp_refreshsqlmodule ''' + name + ''' -- Function'
FROM sys.objects
WHERE is_ms_shipped = 0
	AND type_desc = 'SQL_SCALAR_FUNCTION'
	-- Filer out issues (one-by-one):
	-- AND name <> ''

DECLARE @begin INT = 1, @max INT, @sql NVARCHAR(MAX)
SELECT @max = MAX(ID) FROM @loop

WHILE @begin <= @max
BEGIN

	SELECT @sql = ExecuteIt FROM @loop WHERE ID = @begin
	
	PRINT 'Testing ' + @sql
	EXECUTE sp_executesql @sql

	SET @begin = @begin + 1

END
