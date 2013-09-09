CREATE TABLE #kk(
	ID INT IDENTITY(1,1),
	Alpha VARCHAR(1)
)

INSERT INTO #kk (Alpha)
VALUES ('a')
	, ('b')
	, ('c')
	, ('d')
	, ('e')
	, ('f')
	, ('g')
	, ('h')
	, ('i')
	, ('j')

SET ROWCOUNT 10

SELECT *
FROM #kk
WHERE ID > 1
-- Returns 9

SET ROWCOUNT 2

SELECT *
FROM #kk
WHERE ID > 1

DROP TABLE #kk
