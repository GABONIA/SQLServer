

/* 

Keyword replace tool

*/

DECLARE @string TABLE(
  String VARCHAR(MAX)
)

INSERT INTO @string
VALUES ('The quick brown fox jumped over the lazy dogs.  The dogs heard this often written idiom and contacted Ruff, their attorney.  They filed a lawsuit against all the writers and developers using this often quoted idiom.')

SELECT *
FROM @string

DECLARE @keyword TABLE(
	ID SMALLINT IDENTITY(1,1),
	Keyword VARCHAR(100),
	Link VARCHAR(250)
)

INSERT INTO @keyword (Keyword,Link)
VALUES ('idiom','<a href="http://www.idiom.com/">idiom</a>')
	, ('dogs','<a href="http://lmgtfy.com/?q=dogs">dogs</a>')

DECLARE @begin SMALLINT = 1
DECLARE @max SMALLINT
SELECT @max = MAX(ID) FROM @keyword
DECLARE @key VARCHAR(100)
DECLARE @link VARCHAR(100)

WHILE @begin <= @max
BEGIN

	SELECT @key = Keyword FROM @keyword WHERE ID = @begin
	SELECT @link = Link FROM @keyword WHERE ID = @begin

	UPDATE @string
	SET String = REPLACE(String,@key,@link)
	FROM @String

	SET @begin = @begin + 1
	SET @key = NULL
	SET @link = NULL

END

SELECT *
FROM @string
