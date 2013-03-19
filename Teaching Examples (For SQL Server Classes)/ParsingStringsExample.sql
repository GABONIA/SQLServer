/* 

Example: Parsing values out of a string

*/

DECLARE @comma VARCHAR(75)
SET @comma = 'hello,my,name,is,comma,and,i,am,unable,to,say,separate,'
DECLARE @begin INT = 0
DECLARE @count INT = 0

WHILE @count < 12
BEGIN
	-- Parses every string except "separate" unless comma follows it
	SELECT REPLACE(SUBSTRING(@comma,@begin,CHARINDEX(',',@comma,@begin+1)-@begin),',','')
	SELECT CHARINDEX(',',@comma,@begin+1)
	SET @begin = CHARINDEX(',',@comma,@begin+1)
	
	SET @count = @count + 1
END