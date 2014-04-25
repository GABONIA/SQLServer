-- Testing to validation
DECLARE @interesting TABLE (DateOne VARCHAR(25), DateTwo VARCHAR(25))
DECLARE @move TABLE (DateOne DATE NULL, DateTwo DATE NULL)

INSERT INTO @interesting
VALUES (NULL,NULL)
	, ('NULL','NULL')
	, (CAST(GETDATE() AS VARCHAR(25)),CAST(GETDATE() AS VARCHAR(25)))
	, ('2013-01-01','2013-01-01')
	, (NULL,CAST(GETDATE() AS VARCHAR(25)))


SELECT *
FROM @interesting


INSERT INTO @move
SELECT *
FROM @interesting
WHERE ISDATE(DateOne) = 1
	AND ISDATE(DateTwo) = 1


INSERT INTO @move
SELECT *
FROM @interesting
WHERE DateOne IS NULL
	OR DateTwo IS NULL

SELECT *
FROM @move
