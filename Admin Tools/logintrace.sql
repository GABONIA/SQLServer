/* 

Edit where appropriate
-  Useful for setting up as a job

*/

USE master
GO

DECLARE @num INT
SELECT @num = COUNT(*)
	FROM msdb..sysjobhistory h
		INNER JOIN msdb..sysjobs s ON h.job_id = s.job_id
	-- EDIT: Change the Job name below
	WHERE s.name = 'OURJOBNAME'
		AND h.step_name = '(Job outcome)'
SELECT @num

-- Create a Queue
DECLARE @rc INT
DECLARE @TraceID INT
DECLARE @maxfilesize BIGINT
DECLARE @end DATETIME
DECLARE @string NVARCHAR(250)
-- EDIT: Change the filepath
SET @string =  N'\\OURLOCATION' + CONVERT(VARCHAR,GETDATE(),112) + CAST(@num AS VARCHAR(2))+ '_trace'

set @maxfilesize = 200
set @end = NULL

-- User options
EXEC @rc = sp_trace_create 
	@TraceID OUTPUT
	, 0
	, @string
	, @maxfilesize
	, @end
IF (@rc != 0) GOTO error

/* Events */
-- Auditing Logins (14), Logouts (15), Existing Connections (17)
-- NTUserName (6), NTDomainName (7), ApplicationName (10), SPID (12)

DECLARE @on BIT
SET @on = 1
EXEC sp_trace_setevent @TraceID, 14, 6, @on
EXEC sp_trace_setevent @TraceID, 14, 7, @on
EXEC sp_trace_setevent @TraceID, 14, 10, @on
EXEC sp_trace_setevent @TraceID, 14, 12, @on
EXEC sp_trace_setevent @TraceID, 15, 6, @on
EXEC sp_trace_setevent @TraceID, 15, 7, @on
EXEC sp_trace_setevent @TraceID, 15, 10, @on
EXEC sp_trace_setevent @TraceID, 15, 12, @on
EXEC sp_trace_setevent @TraceID, 17, 6, @on
EXEC sp_trace_setevent @TraceID, 17, 7, @on
EXEC sp_trace_setevent @TraceID, 17, 10, @on
EXEC sp_trace_setevent @TraceID, 17, 12, @on


-- Set the Filters
DECLARE @intfilter INT
DECLARE @bigintfilter BIGINT

EXEC sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL Server Profiler - 9cab2330-a33d-40d4-be59-cf5def384983'
-- Set the trace status to start
EXEC sp_trace_setstatus @TraceID, 1
--sp_trace_setstatus  @traceid =  2,  @status =  0    -- Trace stop

-- display trace id for future references
SELECT TraceID = @TraceID
GOTO finish

ERROR: 
SELECT ErrorCode=@rc

FINISH: 
GO
