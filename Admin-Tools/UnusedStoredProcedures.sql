/*

Very messy way to find unused stored procedures in the database, based on data from a trace file

*/

-- This assumes a trace file's data are stored on the database

DECLARE @Proc TABLE(
  PText VARCHAR(4000)
)

INSERT INTO @Proc
SELECT TextData
-- This is where the trace file's data should be
FROM TraceFileData

SELECT DISTINCT PText
INTO #New
FROM @Proc
WHERE PText IS NOT NULL

-- Note the SUBSTRING here makes assumptions about how applications call stored procedures
SELECT SUBSTRING(PText,CHARINDEX('&',REPLACE(PText,'exec ','& '),1),67) AS ParsedProcs
INTO #Final
FROM #New

DROP TABLE #New

DECLARE @ProcTable TABLE (
  ProcID INT IDENTITY(1,1),
	ProcName VARCHAR(200)
)

INSERT INTO @ProcTable (ProcName)
SELECT name
FROM OurDatabase.sys.procedures
WHERE is_ms_shipped = 0

INSERT INTO #UnusedProcedures (ProcedureName)
SELECT name
FROM OurDatabase.sys.procedures
WHERE is_ms_shipped = 0

DECLARE @begin INT = 1
DECLARE @max INT
SELECT @max = MAX(ProcID) FROM @ProcTable
DECLARE @procy VARCHAR(100)

WHILE @begin <= @max
BEGIN

  SELECT @procy = ProcName FROM @ProcTable WHERE ProcID = @begin

	DECLARE @sql VARCHAR(MAX)
	SET @sql = 'SELECT TOP 1 *
	FROM #Final
	WHERE ParsedProcs LIKE ''' + '%' + @procy + '%' + '''
	IF @@ROWCOUNT = 0
	BEGIN
		UPDATE #UnusedProcedures
		SET Used = 0
		WHERE ProcedureName = ''' + @procy + '''
	END'

	EXECUTE(@sql)

	SET @begin = @begin + 1

END

DROP TABLE #Final

SELECT *
FROM #UnusedProcedures

DROP TABLE #UnusedProcedures
