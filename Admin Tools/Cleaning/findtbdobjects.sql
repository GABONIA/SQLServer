CREATE PROCEDURE stp_FindTBDOrBAKObjects
AS
BEGIN

	DECLARE @loop TABLE(
		DatabaseID INT IDENTITY(1,1),
		DatabaseName VARCHAR(250)
	)


	INSERT INTO @loop (DatabaseName)
	SELECT name
	FROM master.sys.databases
	WHERE database_id NOT IN (1,2,3,4)


	CREATE TABLE ##DelObjects(
		DatabaseName VARCHAR(250),
		ObjectName VARCHAR(250),
		CreateDate DATE,
		ModifyDate DATE
	)


	DECLARE @begin INT = 1, @max INT, @d VARCHAR(250), @sql NVARCHAR(MAX)
	SELECT @max = MAX(DatabaseID) FROM @loop

	WHILE @begin <= @max
	BEGIN

		SELECT @d = DatabaseName FROM @loop WHERE DatabaseID = @begin

		SET @sql = ';WITH DelOb AS(
			SELECT name ObN
				, create_date CD
				, modify_date MD
			FROM ' + @d + '.sys.objects
			WHERE is_ms_shipped = 0
				AND name LIKE ''%TBD%''
				OR name LIKE ''%BAK%''
			)
			INSERT INTO ##DelObjects
			SELECT ''' + @d + '''
				, ObN
				, CD
				, MD
			FROM DelOb
			WHERE CD < DATEADD(MM,-3,GETDATE())'

		EXECUTE sp_executesql @sql

		SET @begin = @begin + 1
		SET @d = ''

	END


	SELECT *
	FROM ##DelObjects


	DROP TABLE ##DelObjects

END
