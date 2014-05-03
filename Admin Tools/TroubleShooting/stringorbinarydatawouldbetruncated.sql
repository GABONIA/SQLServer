-- Error: string or binary data would be truncated

;WITH CTE AS(
  --SELECT QUERY
)
SELECT *
INTO TempTable
FROM CTE

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TempTable'
  AND DATA_TYPE = 'varchar'
  
-- Loop through varchar columns obtain max length
