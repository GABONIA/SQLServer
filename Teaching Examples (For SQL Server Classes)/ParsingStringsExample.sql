/* 

Example: Parsing strings between commas

*/

DECLARE @comma VARCHAR(75) = 'hello,my,name,is,comma,and,i,am,unable,to,say,separate,'
DECLARE @begin INT = 0, @count INT = 0, @max INT
SELECT @max = LEN(@comma) - LEN(REPLACE(@comma,',',''))

WHILE @count < @max
BEGIN

	SELECT SUBSTRING(@comma,@begin,CHARINDEX(',',@comma,@begin+1)-@begin)
	SELECT (CHARINDEX(',',@comma,@begin+1)+1)
	SET @begin = (CHARINDEX(',',@comma,@begin+1)+1)

	SET @count = @count + 1

END
