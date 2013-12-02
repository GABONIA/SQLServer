CREATE PROCEDURE stp_FindTextInObjects
@find VARCHAR(100)
AS
BEGIN

	/* 
	
	-- Note: this procedure will find a procedure in any database (except master, msdb, model, tempdb) by text
	-- Returns the Database and ObjectID
	
	-- For Testing Purposes:
	DECLARE @find VARCHAR(100)
	SET @find = ''
	
	*/


	DECLARE @loop TABLE(
		DatabaseID INT IDENTITY(1,1),
		DatabaseName VARCHAR(250)
	)


	CREATE TABLE ##Saved(
		DatabaseName VARCHAR(250),
		ObjectID BIGINT,
		ObjectName VARCHAR(250)
	)


	INSERT INTO @loop (DatabaseName)
	SELECT name
	FROM master.sys.databases
	WHERE database_id NOT IN (1,2,3,4)


	DECLARE @begin INT = 1, @max INT, @d VARCHAR(250), @sql NVARCHAR(MAX)
	SELECT @max = MAX(DatabaseID) FROM @loop


	WHILE @begin <= @max
	BEGIN

		SELECT @d = DatabaseName FROM @loop WHERE DatabaseID = @begin

		SET @sql = ';WITH CheckAll AS(
			SELECT id ObjectID
				, o.name ObjectName
				, text ObjectText
			FROM ' + @d + '.sys.syscomments c
				INNER JOIN ' + @d + '.sys.objects o ON c.id = o.object_id 
			WHERE text LIKE ''%' + @find + '%''
		)
		INSERT INTO ##Saved (ObjectID,ObjectName,DatabaseName)
		SELECT DISTINCT ObjectID
			, ObjectName
			, ''' + @d + '''
		FROM CheckAll'

		EXECUTE sp_executesql @sql

		SET @begin = @begin + 1
		SET @d = ''

	END


	SELECT *
	FROM ##Saved


	DROP TABLE ##Saved

END
