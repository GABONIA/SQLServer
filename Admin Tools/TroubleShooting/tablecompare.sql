-- Replace the column names you want to compare and the table names.

SELECT * 
FROM (
      SELECT ColumnOne, ColumnTwo, ColumnThree
      FROM dbo.Table
      EXCEPT
      SELECT ColumnOne, ColumnTwo, ColumnThree
      FROM [LinkedServer]
     ) AS R
UNION ALL
SELECT * 
FROM (
      SELECT ColumnOne, ColumnTwo, ColumnThree
      FROM [LinkedServer]
      EXCEPT
      SELECT ColumnOne, ColumnTwo, ColumnThree
      FROM dbo.Table
     ) AS R

/* 

-- Easy approach:

DECLARE @t1 VARCHAR(250), @t2 VARCHAR(250), @cols VARCHAR(2000), @sql NVARCHAR(MAX)
SET @t1 = 'TOne'
SET @t2 = 'TTwo'
SET @cols = 'I'

SET @sql = '
SELECT * 
FROM (
      SELECT ' + @cols + ' 
      FROM ' + @t1 + '
      EXCEPT
      SELECT ' + @cols + ' 
      FROM ' + @t2 + '
     ) AS R
UNION ALL
SELECT * 
FROM (
      SELECT ' + @cols + ' 
      FROM ' + @t2 + '
      EXCEPT
      SELECT ' + @cols + ' 
      FROM ' + @t1 + '
     ) AS R'

EXEC sp_executesql @sql


*/
