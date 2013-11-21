CREATE PROCEDURE stp_CompareObjects
AS
BEGIN

	DECLARE @db TABLE(
		DabID INT IDENTITY(1,1),
		DBName VARCHAR(250)
	)

	INSERT INTO @db (DBName)
	SELECT name
	FROM sys.databases
	WHERE database_id NOT IN (1,2,3,4)

	DECLARE @begin INT = 1, @max INT, @name VARCHAR(250), @sql NVARCHAR(MAX)
	SELECT @max = MAX(DabID) FROM @db

	WHILE @begin <= @max
	BEGIN

		SELECT @name = DBName FROM @db WHERE DabID = @begin

		SET @sql = 'DECLARE @p INT, @v INT, @f INT, @t INT

		SELECT @p = COUNT(*) FROM ' + @name + '.sys.objects WHERE type_desc = ''SQL_STORED_PROCEDURE'' AND is_ms_shipped = 0 
		SELECT @v = COUNT(*) FROM ' + @name + '.sys.objects WHERE type_desc = ''VIEW'' AND is_ms_shipped = 0 
		SELECT @f = COUNT(*) FROM ' + @name + '.sys.objects WHERE type_desc = ''SQL_SCALAR_FUNCTION'' AND is_ms_shipped = 0 
		SELECT @t = COUNT(*) FROM ' + @name + '.sys.objects WHERE type_desc = ''USER_TABLE'' AND is_ms_shipped = 0 
		SELECT @@SERVERNAME AS [Server] 
			, ''' + @name + ''' AS [Database]
			, @p AS [Procedures]
			, @v AS [Views]
			, @f AS [Scalar Functions]
			, @t AS [Tables]'

		EXEC sp_executesql @sql

		SET @begin = @begin + 1
		SET @sql = ''


	END

END


/*

EXECUTE stp_CompareObjects

*/
