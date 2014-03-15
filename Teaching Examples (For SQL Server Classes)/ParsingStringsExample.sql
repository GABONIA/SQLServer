/* 

Example: Parsing values out of a string

*/

DECLARE @comma VARCHAR(75)
SET @comma = 'hello,my,name,is,comma,and,i,am,unable,to,say,separate,'
DECLARE @begin INT = 0, @count INT = 0, @max INT
SELECT @max = LEN(@comma) - LEN(REPLACE(@comma,',',''))

WHILE @count < @max
BEGIN

	-- Parses every string except "separate" unless comma follows it
	SELECT REPLACE(SUBSTRING(@comma,@begin,CHARINDEX(',',@comma,@begin+1)-@begin),',','')
	SELECT CHARINDEX(',',@comma,@begin+1)
	SET @begin = CHARINDEX(',',@comma,@begin+1)

	SET @count = @count + 1

END
