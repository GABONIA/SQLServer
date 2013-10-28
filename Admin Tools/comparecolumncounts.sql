/*

Compare the column counts for tables in different environments/databases

*/

DECLARE @CompCounts TABLE(
	TableName VARCHAR(250),
	TableOneColumnCount INT,
	TableTwoColumnCount INT
)

INSERT INTO @CompCounts (TableName,TableOneColumnCount)
SELECT TABLE_NAME TableOne
	, COUNT(COLUMN_NAME) AS [ColumnCount]
FROM INFORMATION_SCHEMA.COLUMNS WITH(NOLOCK)
GROUP BY TABLE_NAME

;WITH GG AS(
	SELECT TABLE_NAME TN
		, COUNT(COLUMN_NAME) CC
	FROM INFORMATION_SCHEMA.COLUMNS WITH(NOLOCK)
	GROUP BY TABLE_NAME
)
UPDATE @CompCounts
SET TableTwoColumnCount = GG.CC FROM GG
WHERE GG.TN = TableName

SELECT *
FROM @CompCounts

/*

-- For finding tables that don't match:
SELECT *
FROM @CompCounts
WHERE TableOneColumnCount <> TableTwoColumnCount

*/
