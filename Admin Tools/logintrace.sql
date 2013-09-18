/* 

Edit where appropriate
-  Useful for setting up as a job

*/

USE master
GO

/* Initial to avoid duplicate names */
DECLARE @num INT
SELECT @num = COUNT(*)
	FROM msdb..sysjobhistory h
		INNER JOIN msdb..sysjobs s ON h.job_id = s.job_id
	-- EDIT: Change the Job name below
	WHERE s.name = 'OURJOBNAME'
		AND h.step_name = '(Job outcome)'
SELECT @num


DECLARE @rc INT
DECLARE @TraceID INT
DECLARE @maxfilesize BIGINT
DECLARE @end DATETIME
DECLARE @string NVARCHAR(250)
-- EDIT: Change the filepath
SET @string =  N'\\OURLOCATION' + CONVERT(VARCHAR,GETDATE(),112) + CAST(@num AS VARCHAR(2))+ '_trace'

-- EDIT: Change, depending on what you want your file size to be
SET @maxfilesize = 100
SET @end = NULL

-- From what you set above this:
EXEC @rc = sp_trace_create 
	@TraceID OUTPUT
	, 0
	, @string
	, @maxfilesize
	, @end
IF (@rc != 0) GOTO error

/* Events */
-- Auditing Logins (14), Logouts (15), Existing Connections (17)
-- NTUserName (6), LoginName (11), ApplicationName (10), SPID (12)

DECLARE @on BIT
SET @on = 1
EXEC sp_trace_setevent @TraceID, 14, 6, @on
EXEC sp_trace_setevent @TraceID, 14, 11, @on
EXEC sp_trace_setevent @TraceID, 14, 10, @on
EXEC sp_trace_setevent @TraceID, 14, 12, @on
EXEC sp_trace_setevent @TraceID, 15, 6, @on
EXEC sp_trace_setevent @TraceID, 15, 11, @on
EXEC sp_trace_setevent @TraceID, 15, 10, @on
EXEC sp_trace_setevent @TraceID, 15, 12, @on
EXEC sp_trace_setevent @TraceID, 17, 6, @on
EXEC sp_trace_setevent @TraceID, 17, 11, @on
EXEC sp_trace_setevent @TraceID, 17, 10, @on
EXEC sp_trace_setevent @TraceID, 17, 12, @on


-- Filter
DECLARE @intfilter INT
DECLARE @bigintfilter BIGINT

EXEC sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL Server Profiler - 9cab2330-a33d-40d4-be59-cf5def384983'
-- Set the trace status to start
EXEC sp_trace_setstatus @TraceID, 1


SELECT TraceID = @TraceID
GOTO finish

ERROR: 
SELECT ErrorCode=@rc

FINISH: 
GO

/*

/* Find all active traces */
SELECT * 
FROM :: fn_trace_getinfo(default)

-- STOP
sp_trace_setstatus OURTRACE, 0

-- DELETE
sp_trace_setstatus OURTRACE, 2

*/

/*

-- Load trace data
SELECT *
INTO TraceTable
FROM ::fn_trace_gettable('\\OURLOCATION', default)


-- Dependong on how the final data are saved, the below PIVOT will count the total of each (PIVOT):

SELECT [NTUserName], [LoginName], [ApplicationName]
FROM (SELECT InformationType, InformationDetails FROM P2SavedTraces) s1
PIVOT
(COUNT(InformationDetails)
FOR InformationType IN ([NTUserName], [LoginName], [ApplicationName])) AS s2


*/
