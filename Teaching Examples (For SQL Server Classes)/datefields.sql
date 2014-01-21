/*

Trim date fields (DEV & QA)

*/


DECLARE @DateTable TABLE(
	ID INT IDENTITY(1,1),
	Tab VARCHAR(100),
	Col VARCHAR(100)
)


INSERT INTO @DateTable (Tab,Col)
SELECT TABLE_NAME
	, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE LIKE '%date%'


DECLARE @b INT = 1, @m INT, @t VARCHAR(100), @c VARCHAR(100), @s NVARCHAR(MAX)
SELECT @m = MAX(ID) FROM @DateTable

WHILE @b <= @m
BEGIN

	SELECT @t = Tab FROM @DateTable WHERE ID = @b
	SELECT @c = Col FROM @DateTable WHERE ID = @b

	SET @s = 'DELETE FROM ' + @t + '
		WHERE ' + @c + ' > ''2012-01-01''
		
		PRINT ''Cleaned table ''' + @t + ''

	EXEC sp_executesql @s

	SET @b = @b + 1

END
