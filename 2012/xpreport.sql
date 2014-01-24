/*  Finds procs/jobs with xp_cmdshell  */

DECLARE @XP_Report TABLE(
       DatabaseID SMALLINT IDENTITY(1,1),
       DatabaseName VARCHAR(500)
)

INSERT INTO @XP_Report (DatabaseName)
SELECT name
FROM msdb.sys.databases
WHERE name NOT IN ('master','tempdb','model','msdb')

CREATE TABLE ##ProcedureReport (
	DatabaseName VARCHAR(500),
	ProcedureName VARCHAR(1000)
)

CREATE TABLE ##JobReport(
	JobName VARCHAR(1000)
)

DECLARE @begin INT = 1, @max INT, @name VARCHAR(100), @sql NVARCHAR(MAX)
/* 
-- 2005
DECLARE @begin INT
DECLARE @max INT
DECLARE @name VARCHAR(100)
DECLARE @sql NVARCHAR(MAX)
SET @begin = 1

*/
SELECT @max = MAX(DatabaseID) FROM @XP_Report

WHILE @begin <= @max
BEGIN

	SELECT @name = DatabaseName FROM @XP_Report WHERE DatabaseID = @begin

	SET @sql = 'DECLARE @DB VARCHAR(500)
			SET @DB = @name
                
			INSERT INTO ##ProcedureReport
			SELECT @DB, p.name
			FROM ' + @name + '.sys.syscomments c
					INNER JOIN  ' + @name + '.sys.procedures p ON c.id = p.object_id
			-- Edit here if search criteria differs
			WHERE c.text LIKE ''%xp_cmdshell%''
                        
			INSERT INTO ##JobReport
			SELECT j.name
			FROM msdb.dbo.sysjobsteps s
					INNER JOIN msdb.dbo.sysjobs j ON s.job_id = j.job_id
			-- Edit here if search criteria differs
			WHERE s.command LIKE ''%xp_cmdshell%''
					AND j.name NOT IN (SELECT name FROM ##JobReport)
			'

	EXEC sp_executesql @sql, N'@name VARCHAR(500)', @name

	SET @begin = @begin + 1

END

SELECT *
FROM ##ProcedureReport

SELECT *
FROM ##JobReport

DROP TABLE ##ProcedureReport
DROP TABLE ##JobReport
