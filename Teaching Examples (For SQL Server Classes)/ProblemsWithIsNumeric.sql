-- The problem with ISNUMERIC

DECLARE @bad TABLE(
	BadValues VARCHAR(5)
)

INSERT INTO @bad
VALUES ('99999')
	, ('4$000')
	, ('$0000')
	, ('17e00')
	, ('7878')

SELECT *
FROM @bad
WHERE BadValues LIKE '[0-9][0-9][0-9][0-9][0-9]'

SELECT *
FROM @bad
WHERE ISNUMERIC(BadValues) = 1
