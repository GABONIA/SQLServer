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



/* 

Loop to remove tables with certain names by their creation date

*/

SET NOCOUNT ON

DECLARE @loop TABLE(
	TableID SMALLINT IDENTITY(1,1),
	TableName VARCHAR(100)
)

INSERT INTO @loop (TableName)
SELECT name
FROM sys.tables
-- Edit the below two lines:
WHERE name LIKE '%TERM%'
	AND create_date < 'DATE'


DECLARE @begin SMALLINT = 1, @max SMALLINT, @t VARCHAR(100), @s NVARCHAR(MAX)
SELECT @max = MAX(TableID) FROM @loop

WHILE @begin <= @max
BEGIN

	SELECT @t = TableName FROM @loop WHERE TableID = @begin
	SET @s = 'DROP TABLE ' + @t
	
	EXEC sp_executesql @s

	SET @begin = @begin + 1
	SET @s = ''
END

PRINT 'Old tables removed.'

SET NOCOUNT OFF
