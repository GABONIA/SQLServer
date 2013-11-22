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
