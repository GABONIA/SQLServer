/*

Example that will turn columns with a unique id into one row

*/

DECLARE @XMLTest TABLE(
  ID SMALLINT IDENTITY(1,1),
	ValueID SMALLINT,
	EachValue VARCHAR(25)
)


INSERT INTO @XMLTest (ValueID,EachValue)
VALUES (1,'One_1One')
	, (1,'Two_1One')
	, (1,'Three_1One')
	, (1,'Four_1One')
	, (2,'One_2Two')
	, (2,'Two_2Two')
	, (2,'Three_2Two')
	, (2,'Four_2Two')
	, (3,'One_3Three')
	, (3,'Two_3Three')
	, (3,'Three_3Three')
	, (3,'Four_3Three')


SELECT *
FROM @XMLTest


SELECT x1.EachValue + ' ' + x2.EachValue + ' ' + x3.EachValue + ' ' + x4.EachValue
FROM @XMLTest x1
	INNER JOIN @XMLTest x2 ON x2.ID = (x1.ID + 1) AND x1.ValueID = x2.ValueID
	INNER JOIN @XMLTest x3 ON x3.ID = (x1.ID + 2) AND x1.ValueID = x3.ValueID
	INNER JOIN @XMLTest x4 ON x4.ID = (x1.ID + 3) AND x1.ValueID = x4.ValueID
