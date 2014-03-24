/*

Very messy way to find unused stored procedures in the database, based on data from a trace file

Quick Clean (in case of breaks):
DROP TABLE #New
DROP TABLE #Final
DROP TABLE #UnusedProcedures

Another approach (more comprehensive): https://github.com/tmmtsmith/SQLServer/blob/master/Admin%20Tools/Cleaning/procmaintenance.sql

*/

-- This assumes a trace file's data are stored on the database

DECLARE @Proc TABLE(
  PText VARCHAR(8000)
)

INSERT INTO @Proc
SELECT TextData
-- This is where the trace file's data should be:
FROM StoredTraceData

SELECT DISTINCT PText
INTO #New
FROM @Proc
WHERE PText IS NOT NULL

-- Note the SUBSTRING here makes assumptions about how applications call stored procedures
SELECT SUBSTRING(PText,CHARINDEX('&',REPLACE(PText,'exec ','& '),1),67) AS ParsedProcs
INTO #Final
FROM #New

DROP TABLE #New

CREATE TABLE #UnusedProcedures (
	ProcID INT IDENTITY(1,1),
	ProcedureName VARCHAR(200),
	InUse BIT DEFAULT 0
)

INSERT INTO #UnusedProcedures (ProcedureName)
SELECT name
FROM OurDB.sys.procedures
WHERE is_ms_shipped = 0

DECLARE @begin INT = 1
DECLARE @max INT
SELECT @max = MAX(ProcID) FROM #UnusedProcedures
DECLARE @procy VARCHAR(100)

WHILE @begin <= @max
BEGIN

  SELECT @procy = ProcedureName FROM #UnusedProcedures WHERE ProcID = @begin

	DECLARE @sql VARCHAR(MAX)
	SET @sql = 'IF EXISTS(SELECT TOP 1 * FROM #Final WHERE ParsedProcs LIKE ''' + '%' + @procy + '%' + ''')
	BEGIN
		UPDATE #UnusedProcedures
		SET InUse = 1
		WHERE ProcedureName = ''' + @procy + '''
	END'

	EXECUTE(@sql)

	SET @begin = @begin + 1

END

DROP TABLE #Final

SELECT *
FROM #UnusedProcedures

DROP TABLE #UnusedProcedures

