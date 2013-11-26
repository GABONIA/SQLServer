CREATE PROCEDURE stp_DeleteTestingTables
AS
BEGIN

	CREATE SEQUENCE DropTableTemp
	AS INT
	START WITH 1
	INCREMENT BY 1

	CREATE TABLE DropTable (
		TableID INT DEFAULT NEXT VALUE FOR DropTableTemp,
		TableName VARCHAR(500)
	)

	INSERT INTO DropTable (TableName)
	SELECT name
	FROM sys.tables
	-- Edit the schema
	WHERE SCHEMA_NAME(schema_id) = 'EDIT'

	DECLARE @begin INT = 1, @max INT, @sql NVARCHAR(MAX), @table VARCHAR(500)
	SELECT @max = MAX(TableID) FROM DropTable

	WHILE @begin <= @max
	BEGIN
		
		SELECT @table = TableName FROM DropTable WHERE TableID = @begin
    
    -- edit the schema
		SET @sql = 'DROP TABLE EDIT.' + @table

		EXECUTE(@sql)

		SET @begin = @begin + 1
		SET @sql = ''

	END

	DROP TABLE DropTable
	DROP SEQUENCE DropTableTemp

END
