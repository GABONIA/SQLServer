-- No FK constraints
DECLARE @loop TABLE(
	TableID INT IDENTITY(1,1),
	TableName VARCHAR(250)
)

;WITH CTE AS(
	SELECT OBJECT_NAME(parent_object_id) Name
	FROM sys.foreign_key_columns
)
INSERT INTO @loop (TableName)
SELECT o.name
FROM sys.objects o
	INNER JOIN sys.tables t ON o.object_id = t.object_id
WHERE o.name NOT IN (SELECT Name FROM CTE)
	AND o.is_ms_shipped = 0
	AND t.is_ms_shipped = 0


-- FK constraints, order by dependency
INSERT INTO @loop (TableName)
SELECT o.name
	, OBJECT_NAME(k.referenced_object_id) Referenced
	, OBJECT_NAME(k.parent_object_id) Parent
FROM sys.objects o
	INNER JOIN sys.foreign_key_columns k ON o.object_id = k.parent_object_id
