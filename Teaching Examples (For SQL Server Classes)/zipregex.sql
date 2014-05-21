CREATE TABLE ##TestRegEx(
	Value VARCHAR(100)
)

INSERT INTO ##TestRegEx
VALUES ('517')
	, ('88888')
	, ('45815')
	, ('14')
	, ('bbbbb')
	, ('45e17')

SELECT *
FROM ##TestRegEx

SELECT *
FROM ##TestRegEx
WHERE Value LIKE '[0-9][0-9][0-9][0-9][0-9]'

DROP TABLE ##TestRegEx
