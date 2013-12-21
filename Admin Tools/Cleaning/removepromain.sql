CREATE PROCEDURE stp_RemoveProcMaintenance
AS
BEGIN

	/* This removes the tables and procedures built by stp_BuildProcedureMaintenanceObjects */

	DECLARE @loop TABLE(
		DatabaseID INT IDENTITY(1,1),
		DatabaseName VARCHAR(250)
	)

	INSERT INTO @loop (DatabaseName)
	SELECT name
	FROM sys.databases

	DECLARE @begin INT = 1, @max INT, @rem NVARCHAR(MAX), @d VARCHAR(250)
	SELECT @max = MAX(DatabaseID) FROM @loop

	WHILE @begin <= @max
	BEGIN
		
		SELECT @d = DatabaseName FROM @loop WHERE DatabaseID = @begin

		SET @rem = 'DROP TABLE ' + @d + '.adm.mainProcedureLog 
		
		PRINT ''Procedure log tables removed on database ' + @d + '.'''

		EXEC sp_executesql @rem

		SET @begin = @begin + 1
		SET @rem = ''
	END

	DECLARE @pr NVARCHAR(MAX)
	SET @pr = 'USE ?  DROP PROCEDURE dbo.stp_mainLogProcedures'

	EXEC sp_msforeachdb @pr

	PRINT 'All stored procedures logging have been removed for each database.'

END

/*
-- Testing

EXECUTE stp_BuildProcedureMaintenanceObjects
EXECUTE stp_RemoveProcMaintenance

*/
