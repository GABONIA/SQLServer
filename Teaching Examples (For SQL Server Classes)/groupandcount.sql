CREATE TABLE ValueRange(
	Results INT
)

INSERT INTO ValueRange
VALUES (1)
	, (2)
	, (3)
	, (4)
	, (1)
	, (2)
	, (1)
	, (3)
	, (4)
	, (5)
	, (1)
	, (2)
	, (2)
	, (2)
	, (1)
	, (3)
	, (5)

;WITH R AS(
	SELECT CASE
		WHEN Results BETWEEN 1 AND 2 THEN 'Unsatisfied'
		WHEN Results = 3 THEN 'Indifferent'
		WHEN Results BETWEEN 4 AND 5 THEN 'Satisfied'
		END AS ResultRange
	FROM ValueRange
)
SELECT ResultRange
	, COUNT(*) AS ResultCount
FROM R
GROUP BY ResultRange
