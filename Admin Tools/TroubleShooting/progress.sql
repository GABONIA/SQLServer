CREATE TABLE Progress(
	Step TINYINT,
	Passed BIT DEFAULT 0
)


INSERT INTO Progress (Step)
VALUES (1)
	, (2)
	, (3)
	, (4)
	, (5)
	, (6)
	, (7)
	, (8)
	, (9)
	, (10)


SELECT *
FROM Progress


DROP TABLE Progress
