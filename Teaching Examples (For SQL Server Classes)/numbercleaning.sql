/* 

When ISNUMERIC Breaks Down (key for data cleaning or transformation)

*/

DECLARE @NumberOnly TABLE(
  NumbersOnly VARCHAR(4)
)

INSERT INTO @NumberOnly
VALUES ('1000')
	, ('89d4')
	, ('2500')
	, ('89e1')
	, ('four')

SELECT *
FROM @NumberOnly

SELECT *
FROM @NumberOnly
WHERE ISNUMERIC(NumbersOnly) = 1

-- Produces only numbers
SELECT *
FROM @NumberOnly
WHERE NumbersOnly LIKE '[0-9][0-9][0-9][0-9]'

-- Produces only letters
SELECT *
FROM @NumberOnly
WHERE NumbersOnly LIKE '[a-z][a-z][a-z][a-z]'
