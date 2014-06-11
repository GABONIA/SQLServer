DECLARE @loop TABLE(
	LoopID INT IDENTITY(1,1),
	TableName VARCHAR(250)
)

INSERT INTO @loop (TableName)
SELECT name
FROM sys.views
-- sys.tables

DECLARE @b INT = 1, @m INT, @t VARCHAR(250)
SELECT @m = MAX(LoopID) FROM @loop

WHILE @b <= @m
BEGIN

	SELECT @t = TableName FROM @loop WHERE LoopID = @b

	PRINT @t
	EXECUTE('SELECT TOP 1 * FROM ' + @t + ' WHERE 1=1')

	SET @b = @b + 1

END
