-- Compare tables in ETL processes

DECLARE @s NVARCHAR(MAX), @t1 NVARCHAR(250), @t2 NVARCHAR(250), @t3 NVARCHAR(250), @id NVARCHAR(25)
SET @t1 = 'Final' -- Product/Result table
SET @t2 = 'Stage' -- Mid table
SET @t3 = 'Raw' -- Original table
SET @id = 'ID'

SET @s = ';WITH CompareTables AS(
	SELECT *
	FROM ' + QUOTENAME(@t1) + ' t1
	WHERE NOT EXISTS (SELECT ' +  QUOTENAME(@id) + ' FROM TableTwo t2 WHERE t1.' + QUOTENAME(@id) + ' = t2.' + QUOTENAME(@id) + ')
)
SELECT t.*
FROM ' + QUOTENAME(@t3) + '
WHERE EXISTS (SELECT ' + QUOTENAME(@id) + ' FROM CompareTables WHERE ' + QUOTENAME(@t3) + '.' + QUOTENAME(@id) + ' = CompareTables.' + QUOTENAME(@id) + ')'

PRINT @s
--EXEC sp_executesql @s
