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

DECLARE @begin INT = 1
DECLARE @max INT
DECLARE @sql NVARCHAR(MAX)
SELECT @max = MAX(DatabaseID) FROM @XP_Report

WHILE @begin <= @max
BEGIN

		DECLARE @name VARCHAR(500)
		SELECT @name = DatabaseName FROM @XP_Report WHERE DatabaseID = @begin

		SET @sql = 'DECLARE @DB VARCHAR(500)
			SET @DB = ''' + @name + '''
		
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

		EXECUTE(@sql)

		SET @begin = @begin + 1

END

SELECT *
FROM ##ProcedureReport

SELECT *
FROM ##JobReport

DROP TABLE ##ProcedureReport
DROP TABLE ##JobReport
