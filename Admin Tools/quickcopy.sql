IF OBJECT_ID('LoopTable') IS NOT NULL
BEGIN
	DROP TABLE LoopTable
END

SELECT ROW_NUMBER() OVER (ORDER BY name) ID 
	, name
INTO LoopTable
FROM sys.tables
WHERE is_ms_shipped = 0
	AND type = 'U'

DECLARE @b INT = 1, @m INT, @name VARCHAR(100), @sql NVARCHAR(MAX)
SELECT @m = MAX(ID) FROM LoopTable

WHILE @b <= @m
BEGIN

	SELECT @name = Name FROM LoopTable WHERE ID = @b

	SET @sql = 'SELECT * INTO DatabaseTwo.dbo.' + @name + ' FROM ' + @name

	EXEC sp_executesql @sql

	SET @b = @b + 1
END

DROP TABLE LoopTable
