-- Investigate - faster way to import multiple trace files?  This script, which works well, takes a long time.

-- Change the ending time
DECLARE @begin INT = 1, @end INT = [END], @sql NVARCHAR(MAX), @path VARCHAR(1000)


WHILE @begin <= @end
BEGIN

  -- Change path and file format
	SET @path = 'C:\Traces\TraceFile_' + CAST(@begin AS VARCHAR(5)) + '.trc'

	SET @sql = 'INSERT INTO TraceData
			SELECT *
			FROM ::fn_trace_gettable(''' + @path + ''', default)'

	EXECUTE sp_executesql @sql

	SET @begin = @begin + 1
	SET @path = ''
	SET @sql = ''

END
