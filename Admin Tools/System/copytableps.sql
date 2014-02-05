/*

Note: There are faster ways to do this through PS or C# directly.  This will work for those few environments where TSQL is only allowed, or developers are only familiar with TSQL.

  1.  Creates a job which copies table from one server to another
  2.  Runs the job.
  3.  Once the job is complete, deletes the job.

-- Example of how to run it:

EXECUTE stp_CopyTableInPowerShell 'SRVONE\INS'  -- Source server
	,'DBOne'  -- Source database
	,'SRVTWO\INS'  -- Destination server
	,'DBTwo'  -- Destination database
	,'Table'  -- Table to be copied
	,'NameOfJob'  -- Name of job (will be removed)


*/

CREATE PROCEDURE stp_CopyTableInPowerShell
@srcSRV NVARCHAR(250), @srcDB NVARCHAR(100), @destSRV NVARCHAR(250), @destDB NVARCHAR(100), @tb NVARCHAR(100), @jobname NVARCHAR(100)
AS
BEGIN

	DECLARE @sql NVARCHAR(MAX), @a INT = 0, @j NVARCHAR(110)
	SET @j = N'temp_' + @jobname + '_RemoveBy' + CONVERT(NVARCHAR,GETDATE()+1,112)
	SET @sql = 'USE [msdb]

	BEGIN TRANSACTION
	DECLARE @ReturnCode INT
	SELECT @ReturnCode = 0

	IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N''[IDW_Extract]'' AND category_class=1)
	BEGIN
	EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N''JOB'', @type=N''LOCAL'', @name=N''[IDW_Extract]''
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	END

	DECLARE @jobId BINARY(16)
	EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@j, 
			@enabled=1, 
			@notify_level_eventlog=0, 
			@notify_level_email=0, 
			@notify_level_netsend=0, 
			@notify_level_page=0, 
			@delete_level=0, 
			@description=N''No description available.'', 
			@category_name=N''[IDW_Extract]'', 
			@owner_login_name=N''US\ad.tim.smith'', @job_id = @jobId OUTPUT
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	/****** Object:  Step [PS Function To Copy Tables]    Script Date: 2/4/2014 11:24:18 AM ******/
	EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N''Write NULL file locally'', 
			@step_id=1, 
			@cmdexec_success_code=0, 
			@on_success_action=1, 
			@on_success_step_id=0, 
			@on_fail_action=2, 
			@on_fail_step_id=0, 
			@retry_attempts=0, 
			@retry_interval=0, 
			@os_run_priority=0, @subsystem=N''PowerShell'', 
			@command=N''Function CopyTable($srcServer, $srcDatabase, $destServer, $destDatabase, $bothTable)
	{

		$src = New-Object System.Data.SqlClient.SQLConnection
		$dest = New-Object System.Data.SqlClient.SQLConnection
		$src.ConnectionString = "SERVER=" + $srcServer + ";DATABASE=" + $srcDatabase + ";Integrated Security=True"
		$dest.ConnectionString = "SERVER=" + $destServer + ";DATABASE=" + $destDatabase + ";Integrated Security=True"
		$data = "SELECT * FROM " + $bothTable
		$getData = New-Object System.Data.SqlClient.SqlCommand($data, $src)

		try
		{
			$src.Open()
			$dest.Open()
			[System.Data.SqlClient.SqlDataReader] $reading = $getData.ExecuteReader()

			try
			{
				$trun = New-Object Data.SqlClient.SqlCommand
            			$trun.CommandText = "TRUNCATE TABLE " + $bothTable
            			$trun.Connection = $dest
            			$trun.ExecuteNonQuery()
				$copy = New-Object Data.SqlClient.SqlBulkCopy($dest)
				$copy.DestinationTableName = $bothTable
				$copy.WriteToServer($reading)
				"Job step successful."
			}
			catch [System.Exception]
			{
				$ex = $_.Exception
				throw($ex.Message)
			}
			finally
			{
				$reading.Close()
				$src.Close()
				$copy.Close()
			}
		}
		catch
		{
			throw("Cannot open a connection to " + $destServer + ".")
		}
	}

	CopyTable -srcServer "' + @srcSRV + '" -srcDatabase "' + @srcDB + '" -destServer "' + @destSRV + '" -destDatabase "' + @destDB + '" -bothTable "' + @tb + '"'', 
			@database_name=N''master'', 
			@flags=0
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N''(local)''
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	COMMIT TRANSACTION
	GOTO EndSave
	QuitWithRollback:
		IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
	EndSave:'

	-- Create the job
	EXEC sp_executesql @sql,N'@j NVARCHAR(110)',@j

	WAITFOR DELAY '00:00:02'
	RAISERROR('Job created.',0,1) WITH NOWAIT

	SELECT @a = COUNT(*) FROM msdb.dbo.sysjobs WHERE name = @j

	-- If job exists ...
	IF @a = 1
	BEGIN

		DECLARE @s NVARCHAR(MAX)
		SET @s = N'USE [msdb]

		EXEC sp_start_job @j'

		-- Run the job
		EXEC sp_executesql @s,N'@j NVARCHAR(110)',@j
		
		RAISERROR('Job started.',0,1) WITH NOWAIT


		-- Keep checking the job to see if it's finished
		DECLARE @i TINYINT = 0, @c TINYINT

		WHILE @i = 0
		BEGIN
			SELECT @c = COUNT(*) FROM msdb.dbo.sysjobs j INNER JOIN msdb.dbo.sysjobhistory h ON j.job_id = h.job_id WHERE j.name = @j AND h.message LIKE 'The job succeeded%'
			IF @c > 0
			BEGIN
				SET @i = 1
			END
			ELSE
			BEGIN
				WAITFOR DELAY '00:00:01'
				SET @i = 0
			END
		END
	
		
		IF @i = 1
		BEGIN

			DECLARE @d NVARCHAR(MAX)
			SET @d = N'USE [msdb]

			EXEC sp_delete_job @job_name = @j'

			-- Remove the job
			EXEC sp_executesql @d,N'@j NVARCHAR(110)',@j
			RAISERROR('Job removed.',0,1) WITH NOWAIT

		END
	END
END

