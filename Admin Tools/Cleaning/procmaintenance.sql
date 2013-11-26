/*

  For cleaning unused procedures

*/

CREATE PROCEDURE stp_BuildProcedureMaintenanceObjects
AS
BEGIN

	DECLARE @sql NVARCHAR(MAX)
	SET @sql = 'USE ?

		DECLARE @cnt TINYINT, @cntt TINYINT, @cnth TINYINT
		SELECT @cnt = COUNT(name) FROM sys.schemas WHERE name = ''adm''
		IF @cnt = 0
		BEGIN
			EXECUTE(''CREATE SCHEMA adm'')
		END
	
		SELECT @cntt = COUNT(name) FROM sys.tables WHERE name = ''mainProcedureLog''
		IF @cntt = 0
		BEGIN
			CREATE TABLE adm.mainProcedureLog(
			DatabaseName VARCHAR(250),
			ProcedureName VARCHAR(500),
			LastCallDate DATE
			)
		END
	
		SELECT @cnth = COUNT(name) FROM sys.procedures WHERE name = ''stp_mainLogProcedures''
		IF @cnth = 0
		BEGIN
			EXECUTE(''CREATE PROCEDURE stp_mainLogProcedures
			AS
			BEGIN

				INSERT INTO adm.mainProcedureLog
				SELECT DB_NAME()
					, SO.name
					, SD.last_execution_time
				FROM sys.dm_exec_procedure_stats SD
					INNER JOIN sys.objects SO ON SO.object_id = SD.object_id
				WHERE SO.name NOT IN (SELECT ProcedureName FROM adm.mainProcedureLog)


				;WITH U AS(
					SELECT SO.name Name
						, SD.last_execution_time LastDate
					FROM sys.dm_exec_procedure_stats SD
						INNER JOIN sys.objects SO ON SO.object_id = SD.object_id
				)
				UPDATE adm.mainProcedureLog
				SET LastCallDate = U.LastDate
				FROM U
				WHERE U.Name = adm.mainProcedureLog.ProcedureName

			END'')
		END'

	EXEC sp_msforeachdb @sql

END
