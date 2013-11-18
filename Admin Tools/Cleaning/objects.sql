CREATE PROCEDURE [dbo].[stp_ModuleCodeTesting]
AS
BEGIN

	DECLARE @sql NVARCHAR(MAX)
	SET @sql = 'PRINT ''
	Now testing objects in ? ...
	''


	IF OBJECT_ID(''tempdb..##CodeTest'') IS NOT NULL
	BEGIN
		DROP TABLE ##CodeTest
	END


	CREATE TABLE ##CodeTest (
		CodeID INT IDENTITY(1,1),
		NameProcess VARCHAR(250),
		Test TINYINT DEFAULT 0
	)

	INSERT INTO ##CodeTest (NameProcess)
	SELECT ''sys.sp_refreshsqlmodule '''''' + name + ''''''''
	FROM ?.sys.objects
	WHERE is_ms_shipped = 0
			AND type_desc = ''SQL_STORED_PROCEDURE''
			OR type_desc = ''VIEW''
			AND is_ms_shipped = 0
			OR type_desc = ''SQL_SCALAR_FUNCTION''
			AND is_ms_shipped = 0

	DECLARE @n VARCHAR(250)
	SET @n = ''?''

	-- Place invalid procedure names here
	DELETE FROM ##CodeTest
	WHERE NameProcess LIKE ''%sp_hexadecimal%''
		OR NameProcess LIKE ''%sp_help_revlogin%''
		OR NameProcess LIKE ''%sysdtslog90%''
		OR NameProcess LIKE ''%usp_Maintenance_Prepare%''
		OR NameProcess LIKE ''%usp_Maintenance_Complete%''
		OR NameProcess LIKE ''%usp_'' + @n + ''_Complete%''
		
	DECLARE @begin INT, @max INT, @name VARCHAR(250), @sql NVARCHAR(MAX)
	SELECT @begin = MIN(CodeID) FROM ##CodeTest WHERE Test = 0
	SELECT @max = MAX(CodeID) FROM ##CodeTest WHERE Test = 0

	WHILE @begin <= @max
	BEGIN
        
			SELECT @sql = NameProcess FROM ##CodeTest WHERE CodeID = @begin AND Test = 0
			PRINT ''Testing '' + @sql
			EXECUTE(@sql)
        
			SET @begin = @begin + 1

	END


	SELECT *
	FROM ##CodeTest'


	EXEC sp_msforeachdb @sql

END
