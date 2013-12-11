/*

  For cleaning unused procedures
  
	-- Note that you can also store the object id of the procedure instead of the name

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
				SELECT SO.name
					, SD.last_execution_time
				FROM sys.dm_exec_procedure_stats SD
					INNER JOIN sys.procedures SO ON SO.object_id = SD.object_id
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
				
				
				;WITH D AS(
					SELECT name ProcName
					FROM sys.procedures
				)
				DELETE FROM adm.mainProcedureLog
				WHERE ProcedureName NOT IN (SELECT ProcName FROM D)

			END'')
		END'

	EXEC sp_msforeachdb @sql

END

/*

Job

*/

USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'mainLogProcedures', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'This job keeps a record of when procedures were last called so that we can quickly identify unused stored procedures.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'LOGIN', @job_id = @jobId OUTPUT
select @jobId
GO
-- CHANGE SERVER\INSTANCE below this
EXEC msdb.dbo.sp_add_jobserver @job_name=N'mainLogProcedures', @server_name = N'SERVER\INSTANCE'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'mainLogProcedures', @step_name=N'Log procedure last use', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE master
GO

DECLARE @com NVARCHAR(MAX)
SET @com = ''USE ?

EXECUTE stp_mainLogProcedures''

EXEC sp_msforeachdb @com', 
		@database_name=N'master', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'mainLogProcedures', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'This job keeps a record of when procedures were last called so that we can quickly identify unused stored procedures.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'LOGIN', 
		@notify_email_operator_name=N'', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'mainLogProcedures', @name=N'Nightly', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=127, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20131126, 
		@active_end_date=99991231, 
		@active_start_time=233100, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
