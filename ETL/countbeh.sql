CREATE TABLE TestThenDrop(
	ID INT
)

INSERT INTO TestThenDrop
VALUES (NULL)
	, (NULL)
	, (NULL)
	, (1)
	, (1)
	, (10)
	, (8)
	, (7)
	, (10)
	, (1)
	
SELECT COUNT(*)
FROM TestThenDrop

SELECT COUNT(ID)
FROM TestThenDrop

SELECT COUNT(DISTINCT ID)
FROM TestThenDrop

DROP TABLE TestThenDrop
